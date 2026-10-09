# Offline Song Sheet Organizer Architecture

## Product

Build an Android-first Flutter app that manages song-sheet images locally.

Primary workflows:

1. Authorized folders → date-scoped metadata discovery → offline sheet classification → duplicate checking → title OCR → conditional enhancement → real file renaming → persistent library.
2. One selected service-list image → geometry-aware ordered title extraction → editable rows → local library matching → missing/ambiguous slots → saved Sunday collection.
3. Saved collection → scrolling, zooming, page/song navigation.

All installed-app features work offline.

## Architecture

Presentation:
- Multi-folder and inclusive date-range setup.
- Confirmed-only Song Library and search.
- Import progress.
- OCR and edition review.
- Services.
- Service builder.
- Reader.
- Settings and backup.

Application services:
- ImportCoordinator.
- SheetRecognitionService.
- DuplicateService.
- FileOperationCoordinator.
- SetlistRecognitionService.
- SongMatcher.
- BackupService.

Domain:
- Song.
- Edition.
- SheetAsset.
- ServiceCollection.
- ServiceEntry.
- ImportJob.
- FileOperation.
- SourceFolder.
- DiscoveryRecord.

Infrastructure:
- Drift/SQLite repositories.
- Bundled Google ML Kit OCR adapter.
- Kotlin SAF storage bridge.
- Temporary preprocessing and thumbnail cache.

Keep widgets free from direct SQL, destructive file operations, and OCR orchestration.

## Suggested project organization

lib/
  app/
  core/
    database/
    storage/
    ocr/
    image_processing/
  features/
    library/
    import/
    review/
    services/
    reader/
    settings/

Organize feature code into presentation, application, and domain/data components where useful. Avoid empty layers and excessive abstraction.

Keep native storage integration under the Android application source.

## Master storage

Authorize one or more local folders such as Documents/SongSheets. Persist every SAF grant. Subfolder discovery is opt-in per source.

Enumerate and manage existing images in place. Never expand discovery to gallery/DCIM/Downloads roots that the user did not explicitly authorize.

Each retained image has one stable asset ID and one canonical URI. Its filename may change without changing its identity.

The storage bridge returns a provider-stable identity, current URI, explicit parent URI, provider-added date when exposed, last-modified metadata, size, MIME type, and capabilities. Rename collision checks occur in the explicit parent, and returned URI/identity metadata replaces the old values.

All native provider queries, enumeration, reads, preview decoding, hashing, rename, delete, and copy operations run on a background executor. The Android main thread only launches pickers and marshals results.

SQLite stores metadata and references, not full image blobs.

Temporary OCR files and thumbnails may exist in bounded cache. They are not additional master images.

If importing outside the authorized folders requires copying, make source-retention behavior explicit. Reading an image does not automatically grant deletion permission.

## Data model

songs:
- id
- display_title
- normalized_title
- timestamps

aliases:
- id
- song_id
- normalized_alias

editions:
- id
- song_id
- nullable key_label
- nullable instrument
- nullable arrangement_label
- user_label

assets:
- id
- nullable edition_id
- document_uri
- filename
- mime_type
- byte_size
- sha256
- nullable pixel_fingerprint
- pixel dimensions
- nullable page_order
- extracted_title
- OCR/review/availability states
- content fingerprint
- processing_version

services:
- id
- local_date
- display_name
- timestamps

service_entries:
- id
- service_id
- position
- requested_title
- nullable requested_key
- nullable edition_id
- matched/missing/ambiguous status

import_jobs:
- id
- source_uri
- input fingerprint
- state
- attempts
- error

file_operations:
- id
- operation kind
- source/destination information
- nullable retained_asset_id
- expected fingerprint
- state
- error

reader_progress:
- service_id
- entry_id
- page position
- timestamps

source_folders:
- id
- tree_uri
- display_name
- include_subfolders
- added_at

discovery_ledger:
- id and stable provider identity
- source_folder_id
- document_uri, current_uri, and parent_uri
- filename, MIME type, byte size, and modified timestamp
- nullable provider_added_at and persistent first_seen_at
- eligibility_date and date_source
- metadata fingerprint and processing version
- classification and score
- processing state and failure reason
- nullable byte/pixel fingerprints
- per-stage timings and processing timestamps

Discovery states are: discovered, excluded, non_song_sheet, uncertain, processing, completed, duplicate_deleted, and failed. Every examined JPEG/PNG has a ledger row even when it never becomes a library asset.

Enable foreign keys and schema migrations.

Index normalized titles, hashes, pending jobs, and ordered asset queries.

Enforce unique service/position. Allow the same song at multiple service positions.

Do not make title or title/key a destructive uniqueness constraint.

## Import pipeline

1. Enumerate metadata from each explicitly authorized source; recurse only when enabled.
2. Resolve the ledger row by stable identity, falling back to URI.
3. Choose an eligibility date from provider-added metadata or the persisted first-seen date and apply inclusive local dates.
4. Persist excluded rows without reading image content. Skip unchanged terminal rows without preview, hash, decode, or OCR work.
5. Read a bounded preview and classify from staff-line/layout evidence offline.
6. Preserve non-sheets unchanged; send uncertain classifications to review.
7. For confirmed sheets only, stream the full image once while computing SHA-256 and check byte duplicates.
8. Decode/orientation-normalize once for the exact-pixel fingerprint and normal header crop; check exact-pixel duplicates.
9. OCR the normal header, create enhancements lazily only after weak results, and expand to the original only as a final bounded fallback.
10. Persist recognized metadata or pending title review.
11. Revalidate folder/date eligibility and fingerprints before a real rename or exact-duplicate deletion.
12. Update the asset, ledger identity/URI/name/fingerprint, mutation journal, and stage timings.

Process mutations through a durable serialized queue.

Changing a date range or processing version does not implicitly reprocess unchanged terminal rows. Settings exposes an explicit reprocess action.

## Classification boundary

The library contains confirmed song sheets only. Classification occurs before full OCR and before any destructive operation. Staff systems and page structure are positive evidence; recognized words by themselves do not make an image a song sheet.

Confident non-sheets remain in the ledger and remain physically untouched. Uncertain rows enter review. The review UI can override both uncertain and non-song decisions; confirmation resumes the normal guarded import pipeline.

## OCR boundaries

Use bundled Google ML Kit Latin text recognition.

Title detection uses header position, text size, plausible wording, and multiline grouping. Composer names or publisher text may appear before the title.

Preserve originals. Enhancement cannot reliably restore text lost to severe blur.

Support printed key labels and manual tagging. Staff key-signature recognition is a separate future feature.

## Duplicate decisions

Automatically delete only verified exact duplicates.

Keep images sharing a title when they differ in key, arrangement, page, annotation, or content.

Perceptual similarity produces a possible-duplicate status, never deletion authority.

Before deleting an incoming duplicate, verify the retained image is accessible, distinct, and unchanged. Preserve collection membership by redirecting references as needed.

Use full decoded pixel equality without resizing or aggressive image processing for destructive comparison.

## Mutation recovery

SQLite and filesystem operations do not share an atomic transaction.

Journal operations with states such as:
planned → references_committed → filesystem_done

Record failure/retry states.

For a rename, reconcile the returned URI and recover if the filesystem rename succeeded before the database update.

For deletion, redirect references before physical cleanup and retry safely after interruptions.

Revalidate fingerprints before every destructive retry.

## Sunday collections

User selects a local date.

Name:
Songs for Sunday (YYYY-MM-DD)

OCR the list image into ordered editable entries.

Only the image selected for that Sunday import is read. Creating a collection never scans authorized source folders.

Preserve numbering, continuation lines, repeated songs, and column reading order. Cluster OCR geometry into columns left-to-right, sort top-to-bottom inside each column, then join nearby continuation lines. Users can edit, insert, remove, and reorder entries before saving.

Match exact normalized titles, aliases, and normalized generated filenames, then key/version constraints. Filename similarity may propose fuzzy candidates but cannot silently select them.

A missing song remains a labeled empty slot. An ambiguous song remains unresolved until edition selection.

Show parsed, matched, missing, and ambiguous counts.

Save a virtual folder using references. Do not duplicate master images.

Physical folder export is a separate explicit operation that creates copies.

## Reader

Resolve service entries into ordered edition pages.

Support scrolling, pinch zoom, pan, next/previous song/page, and position restoration.

Keep missing entries visible. Show relinking when a URI is unavailable.

Use bounded adjacent-page prefetch and thumbnail caching.

Song Library navigation is built from the active filtered result list. Sunday Collection navigation is independently built from saved service-entry order; one mode never borrows the other's navigation set.

## Performance observability

The discovery ledger stores timings for eligibility, classification, stream read/hash, preprocessing/enhancement, OCR, rename, and duplicate deletion. Settings stores and displays last-scan discovery and total timing/count summaries. These measurements diagnose regressions without retaining extra full-resolution images.

## Persistence

Catalog and collections survive app closure, reboot, and normal updates.

App uninstall/clear-data can remove SQLite. Shared images surviving uninstall do not guarantee collection survival.

Provide backup/restore of catalog and collection metadata with relinking to selected storage.

## Delivery order

1. Storage bridge, SQLite, library, mutation journal.
2. Bundled OCR, review, actual renaming.
3. Automatic exact-duplicate deletion.
4. Service-list OCR and collection matching.
5. Reader, backup/restore, optimization, and device acceptance.

Every screen must use real repositories and working actions.
