Use $build-offline-song-sheets to build this application.

You are a senior Flutter and Android engineer. Work directly in my current project. Read applicable AGENTS.md, `.agents/skills/build-offline-song-sheets/SKILL.md`, and `docs/song-sheet-architecture.md` before editing.

Build the complete Android-first offline song-sheet organizer. Do not stop after planning, scaffolding, or creating UI mockups.

Inspect existing code and tool versions. Preserve unrelated changes. If no Flutter project exists, create one without overwriting unrelated files.

Use Flutter, Riverpod, Drift/SQLite, bundled Google ML Kit Text Recognition through google_mlkit_text_recognition, and a Kotlin Android SAF bridge. Verify compatible package versions and actual bundled-model dependencies.

Implement:

1. A persistent searchable library using one master image per retained asset.
2. Folder selection with persisted access and actual file renaming.
3. Header/title OCR with conditional contrast/brightness/sharpening retries and manual correction.
4. Automatic physical deletion of verified exact duplicates, preserving different keys, arrangements, pages, and annotations.
5. Durable import jobs and crash-safe rename/delete recovery.
6. Service creation from a song-list image, preserving order and repeated songs.
7. Local matching with key/version selection, missing placeholders, and ambiguous states.
8. Saved virtual folders named Songs for Sunday (YYYY-MM-DD), without copying master images.
9. A reader with scrolling, pan, pinch zoom, next/previous navigation, multipage songs, and saved position.
10. Catalog/collection backup and restore.

Use a cohesive Material 3 interface with Library, Services, and Settings navigation. Include real progress, search, pending review, useful errors, and clear match counts.

Do not:
- Use cloud OCR or internet-dependent runtime features.
- Delete based only on title, title/key, or perceptual similarity.
- Pretend a database label rename changes the actual file.
- Bypass Android permissions.
- Copy images into every Sunday collection.
- Guess staff key signatures using title OCR.
- Leave primary actions as TODOs or mock handlers.
- Test destructive operations on my live image library.

Start with a short implementation plan and then execute all stages. Make routine engineering decisions independently.

Run formatting, required code generation, flutter analyze, meaningful tests, and an Android APK build when available.

Verify first-launch OCR in airplane mode, real rename/deletion, reboot persistence, collection saving without full-image copies, and reader gestures on a device when accessible.

If tools or hardware block a check, complete independent work and identify the exact unexecuted validation. Do not fabricate success.

Finish with a concise report of working features, tests/checks actually run, APK location if built, and concrete remaining blockers.
