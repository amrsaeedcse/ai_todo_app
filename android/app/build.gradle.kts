plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.todo_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        // ✅ في Kotlin DSL لازم تكتب isCoreLibraryDesugaringEnabled
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.todo_app"
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // لحد دلوقتي مفيش signingConfig release مخصص
            signingConfig = signingConfigs.getByName("debug")

            // ضيف الأسطر دي لحل مشكلة النوتيفيكشن
            isMinifyEnabled = false
            isShrinkResources = false

            // لو عايز تشغل الـ proguard بعدين
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ مكتبة desugaring المطلوبة لـ flutter_local_notifications
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")

    // لو محتاج كوتلن ستاندرد (موجود تلقائي غالباً)
    implementation("org.jetbrains.kotlin:kotlin-stdlib")
}
