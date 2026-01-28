plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Google Services plugin is required for Firebase to work
    id("com.google.gms.google-services") 
    // The Flutter Gradle Plugin must be applied after Android and Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.restaurant_globe"
    compileSdk = 36 // Change from 36 to 35
    
    // Explicitly set this to a version you likely have
    buildToolsVersion = "36.0.0"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.restaurant_globe"
        minSdk = flutter.minSdkVersion 
        targetSdk = 35 // Match compileSdk
        
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Signing with the debug keys for now so 'flutter run --release' works
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
