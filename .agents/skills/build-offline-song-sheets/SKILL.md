---
name: build-offline-song-sheets
description: Build, debug, and optimize an Android Flutter song-sheet organizer using bundled Google ML Kit OCR, actual image-file renaming, automatic exact-duplicate deletion, SQLite persistence, service-list image matching, and a zoomable offline reader.
---

# Build Offline Song Sheets

Read `docs/song-sheet-architecture.md` from the project root before implementing. Follow applicable AGENTS.md and preserve unrelated changes.

## Execution

Inspect the project, installed Flutter/Dart versions, Android configuration, and existing dependencies. If there is no Flutter app, create an Android-first project without overwriting unrelated files.

Use:
- Flutter for the UI.
- Riverpod for state management.
- Drift over SQLite for persistent metadata.
- google_mlkit_text_recognition using Google's bundled Latin OCR model.
- A Kotlin MethodChannel bridge for Android Storage Access Framework operations.
- A lightweight image-processing library for temporary preprocessing.
- PhotoView or InteractiveViewer for reading.

Verify package APIs and compatible versions against the installed SDK. Do not blindly use remembered dependency versions.

Implement the entire requested workflow. Begin with a short plan, then write and validate working code. Do not stop at architecture, scaffolding, mock screens, or hardcoded data.

## Offline operation

Bundle the OCR model into the Android APK. First-launch OCR must work without downloading a model.

Use no cloud OCR, Firebase, login, server, or internet-dependent matching.

Verify resolved Android dependencies instead of assuming the Flutter wrapper bundles the correct model.

Distinguish development dependency downloads from installed-app runtime requirements.

## Storage and permissions

Select a dedicated local song folder through ACTION_OPEN_DOCUMENT_TREE and retain its read/write URI grant.

Use existing authorized images in place. Store content URIs as opaque identifiers, not filesystem paths.

Implement native enumeration, metadata, reading, rename, deletion, and capability checks. Update stored URIs when renaming returns a new URI.

Do not claim silent access to every gallery/download file. Respect Android's Downloads-root restrictions, read-only providers, and revoked grants.

Normal operations inside supported writable storage must not show an app confirmation for each rename or duplicate deletion.

If importing from an external read-only source requires a copy, explicitly report that the source remains. Never claim the external duplicate was deleted when permission prevented it.

Keep one permanent full-resolution master per retained asset. Use bounded temporary crops and thumbnail caches.

## Title OCR

Run exact duplicate checking before OCR when possible.

Normalize orientation for processing. OCR the header region first, then expand if necessary.

Identify title candidates using position, relative text size, multiline grouping, and text plausibility. Do not assume the first recognized line is the title.

Retain raw OCR separately from normalized search text.

Run normal OCR first. For weak results only, try a bounded sequence of contrast, brightness/gamma, grayscale, and modest sharpening/denoising variants.

Do not overwrite the original image with preprocessing results.

Use an application quality score without inventing ML Kit confidence values unavailable in the selected API.

Allow manual title/crop correction when uncertain. Do not rename an image using an unreliable guessed title.

Read printed key labels when available and allow manual key/version tagging. Do not pretend title OCR can identify musical key signatures drawn on a staff.

## Real file renaming

Rename the actual writable file, not only its database label.

Sanitize filenames, preserve extensions, and prevent collisions without overwriting.

Use known title/key/page plus a stable identifier suffix, for example:
The Prayer__Bb__p01__7c2a.jpg

Keep filenames independent from stable database identity.

## Automatic duplicate deletion

Automatically delete verified duplicates within authorized writable storage.

Permit automatic deletion for:
1. Byte-identical files verified with SHA-256.
2. Exactly equal full decoded image pixels after orientation normalization, with equal dimensions and compatible known metadata.

Never delete based only on:
- The same title.
- The same title and key.
- A perceptual hash.
- Similar OCR text.
- A similar resized, compressed, or cropped appearance.

Preserve different keys, arrangements, pages, and visible annotations.

Before deletion:
- Verify a distinct retained master remains readable.
- Reject self-deletion and aliases of the same document.
- Revalidate input and retained fingerprints.
- Redirect existing references when needed.
- Journal the operation before changing physical storage.

Serialize conflicting imports and mutations. Recover idempotently after crashes.

If deletion fails, keep cleanup pending and report the physical result accurately. A removed database row is not proof that the image was deleted.

## Service collections

Implement:
Create service → choose date → insert song-list image → OCR ordered rows → review → match library → retain missing/ambiguous slots → save.

Preserve list order, repeated songs, multiline titles, and page order.

Match exact normalized titles and aliases first. Apply requested key/version constraints.

Use fuzzy matching to propose candidates, not silently select a different song.

When several editions remain, require version selection. When nothing matches, retain a labeled empty slot.

Save collections as SQLite references to master images. Do not copy or move images into each collection.

Deleting a collection must not delete its master images.

## Reader

Implement:
- Pinch zoom and pan.
- Next/previous song and page.
- Vertical scrolling mode.
- Ordered multipage sheets.
- Saved reading position.
- Missing-song placeholders.
- Relinking for unavailable files.

Prevent zoomed-image panning from unintentionally turning pages.

## Persistence and optimization

Persist catalog, jobs, operations, collections, and reader progress outside cache.

Support app restart, reboot, and normal updates. Provide backup/restore for catalog and collections; do not promise persistence after uninstall without backup.

Process only new/changed images. Hash streams, preprocess off the UI isolate, use a serialized OCR queue, reuse the recognizer during batches, and bound caches.

Refresh incrementally on launch/resume and provide manual refresh. Do not promise instant background cleanup after Android kills the app.

## Verification

Run code generation when needed, formatting, flutter analyze, meaningful tests, and an Android APK build when supported.

Test filesystem mutations only in disposable fixture folders.

Cover:
- Exact duplicates and equal pixels with different metadata.
- Same title with different keys.
- Same title/key with different pages or arrangements.
- Visible annotation differences.
- Missing retained master and URI aliases.
- Filename collisions and revoked access.
- Crash recovery after rename/deletion.
- Missing/ambiguous/repeated service entries.
- Collection saving without full-image copies.
- Reader progress persistence.

Verify actual-device first-launch OCR in airplane mode, reboot persistence, real rename/deletion, large images, and reader gestures when a device is available.

Never fabricate build or device-test success. Finish with implemented behavior, checks actually run, APK path if built, and concrete remaining blockers.
