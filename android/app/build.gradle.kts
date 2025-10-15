import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle plugin must be applied last
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties safely
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
} else {
    println("Warning: key.properties not found. Release builds will fail if signing is required.")
}

android {
    namespace = "com.example.ecommerece_shop"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.ecommerece_shop"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"]?.toString()
                ?: throw GradleException("keyAlias is missing in key.properties")
            keyPassword = keystoreProperties["keyPassword"]?.toString()
                ?: throw GradleException("keyPassword is missing in key.properties")
            storeFile = keystoreProperties["storeFile"]?.let { file(it.toString()) }
                ?: throw GradleException("storeFile is missing in key.properties")
            storePassword = keystoreProperties["storePassword"]?.toString()
                ?: throw GradleException("storePassword is missing in key.properties")
                
            storeType = "PKCS12"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")

            // Disable shrinking if you don't want minification
            isMinifyEnabled = false
            isShrinkResources = false

            // If you want shrinking, uncomment these lines:
            /*
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            */
        }
    }
}

flutter {
    source = "../.."
}
