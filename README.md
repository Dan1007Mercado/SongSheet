# Song Sheets

An Android-first Flutter organizer for photographed song sheets. Cataloging, Google ML Kit Latin OCR, matching, service collections, and reading work without a network connection after installation.

## Run

```text
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

On first launch, choose a dedicated writable folder through Android's system folder picker. The app keeps the persisted Storage Access Framework grant and manages authorized images in place. Importing from elsewhere copies the selected image into that folder and leaves the external source unchanged.

## Data safety

- Physical duplicate deletion is limited to revalidated SHA-256 equality or exact full decoded-pixel equality.
- Similar titles, OCR text, perceptual similarity, keys, and arrangements never authorize deletion.
- Rename and delete operations are journaled for recovery because SQLite and document-provider mutations cannot share a transaction.
- Service collections contain database references and never copy or delete master images.
- Export a catalog backup before uninstalling or clearing app data.

## Checks

```text
flutter analyze
flutter test
flutter build apk --debug
```

The Android runtime explicitly resolves `com.google.mlkit:text-recognition:16.0.1`, whose Latin OCR model and native pipeline are packaged in the APK.
