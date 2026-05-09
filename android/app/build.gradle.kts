// CI-TEMPLATE-SIGNING-V1
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release 署名設定。
// ローカル: android/key.properties から読み込む（gitignore 対象）
// CI: 環境変数 ANDROID_STORE_FILE / ANDROID_STORE_PASSWORD / ANDROID_KEY_ALIAS / ANDROID_KEY_PASSWORD から
val keystoreProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) load(FileInputStream(file))
}

fun signingValue(propName: String, envName: String): String? =
    keystoreProperties.getProperty(propName) ?: System.getenv(envName)



android {
    namespace = "com.cocktailbook.cocktail_recipe_manager"
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
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.cocktailbook.cocktail_recipe_manager"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val store = signingValue("storeFile", "ANDROID_STORE_FILE")
            if (store != null) {
                storeFile = file(store)
                storePassword = signingValue("storePassword", "ANDROID_STORE_PASSWORD")
                keyAlias = signingValue("keyAlias", "ANDROID_KEY_ALIAS")
                keyPassword = signingValue("keyPassword", "ANDROID_KEY_PASSWORD")
            }
        }
    }


    buildTypes {
        release {
            // 署名情報が揃っていれば release 鍵で、なければ debug 鍵にフォールバック
            // （flutter run --release を手元で署名なしでも回せるようにするため）
            val releaseSigning = signingConfigs.getByName("release")
            signingConfig = if (releaseSigning.storeFile != null)
                releaseSigning
            else
                signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
