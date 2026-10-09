# Offline Song Sheet Organizer Architecture

## Product

Build an Android-first Flutter app that manages song-sheet images locally.

Primary workflows:

1. Images → duplicate checking → title OCR → conditional enhancement → real file renaming → persistent library.
2. Service-list image → ordered title extraction → local library matching → missing/ambiguous slots → saved Sunday collection.
3. Saved collection → scrolling, zooming, page/song navigation.

All installed-app features work offline.

## Architecture

Presentation:
- Folder setup.
- Library and search.
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

Select a local folder such as Documents/SongSheets once.

Persist its SAF read/write grant. Enumerate and manage existing images in place.

Each retained image has one stable asset ID and one canonical URI. Its filename may change without changing its identity.

SQLite stores metadata and references, not full image blobs.

Temporary OCR files and thumbnails may exist in bounded cache. They are not additional master images.

If importing outside the managed folder requires copying, make source-retention behavior explicit. Reading an image does not automatically grant deletion permission.

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

Enable foreign keys and schema migrations.

Index normalized titles, hashes, pending jobs, and ordered asset queries.

Enforce unique service/position. Allow the same song at multiple service positions.

Do not make title or title/key a destructive uniqueness constraint.

## Import pipeline

1. Discover a new/changed image.
2. Confirm the file is readable and stable, avoiding incomplete downloads.
3. Stream SHA-256.
4. Check for a verified exact duplicate.
5. Decode and normalize orientation.
6. Extract header title candidates.
7. Retry with limited preprocessing only when necessary.
8. Persist recognized metadata or pending review.
9. Rename the actual file when the title is credible.
10. Record completed state and clean temporary files.

Process mutations through a durable serialized queue.

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

Preserve numbering, continuation lines, repeated songs, and column reading order.

Match exact normalized titles and aliases, then key/version constraints.

A missing song remains a labeled empty slot. An ambiguous song remains unresolved until edition selection.

Show parsed, matched, missing, and ambiguous counts.

Save a virtual folder using references. Do not duplicate master images.

Physical folder export is a separate explicit operation that creates copies.

## Reader

Resolve service entries into ordered edition pages.

Support scrolling, pinch zoom, pan, next/previous song/page, and position restoration.

Keep missing entries visible. Show relinking when a URI is unavailable.

Use bounded adjacent-page prefetch and thumbnail caching.

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
