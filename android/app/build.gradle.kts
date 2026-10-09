plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.song_sheets"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.song_sheets"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Local acceptance builds use the debug key. Configure a private
            // release keystore before publishing to an app store.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // This is ML Kit's bundled Latin model, not the Play Services dynamically
    // downloaded artifact. Keeping it explicit makes offline packaging auditable.
    implementation("com.google.mlkit:text-recognition:16.0.1")
    implementation("androidx.documentfile:documentfile:1.1.0")
}

flutter {
    source = "../.."
}
