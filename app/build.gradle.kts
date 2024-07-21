import com.android.build.gradle.tasks.asJavaVersion

plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.compose.compiler)
    alias(libs.plugins.jetbrains.kotlin.android)
    alias(libs.plugins.kotlinx.serializer)
    alias(libs.plugins.kotlin.parcelize)
    alias(libs.plugins.secrets.gradle.plugin)
}

android {
    namespace = "dev.pyrossh.onlyBible"
    compileSdk = 34

    defaultConfig {
        applicationId = "dev.pyrossh.onlyBible"
        minSdk = 33
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary = true
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaLanguageVersion.of(11).asJavaVersion()
        targetCompatibility = JavaLanguageVersion.of(11).asJavaVersion()
    }
    buildFeatures {
        compose = true
        buildConfig = true
    }
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
    kotlinOptions {
        jvmTarget = JavaLanguageVersion.of(11).toString()
    }
    androidResources {
        generateLocaleConfig = true
    }
}

composeCompiler {
    enableStrongSkippingMode = true
}

dependencies {
    implementation(libs.kotlinx.serialization.json)
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.lifecycle.runtime.ktx)
    implementation(libs.androidx.activity.compose)
    implementation(platform(libs.androidx.compose.bom))
    implementation(libs.androidx.ui)
    implementation(libs.androidx.ui.graphics)
    implementation(libs.androidx.ui.tooling.preview)
    implementation(libs.androidx.material3)
    implementation(libs.androidx.material.icons.extended)
    implementation(libs.androidx.ui.util.android)
    implementation(libs.androidx.navigation.fragment.ktx)
    implementation(libs.androidx.navigation.ui.ktx)
    implementation(libs.androidx.navigation.compose)
    implementation(libs.androidx.foundation)
    implementation(libs.accompanist.systemuicontroller)
    implementation(libs.androidx.ui.text.google.fonts)
    implementation(libs.speech.client.sdk)
    implementation(libs.kotlinx.coroutines.core)
    implementation(libs.androidx.core.splashscreen)
    implementation(libs.androidx.lifecycle.viewmodel.compose)
    implementation(libs.androidx.appcompat)
    implementation(libs.androidx.appcompat.resources)

    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)
    androidTestImplementation(platform(libs.androidx.compose.bom))
    androidTestImplementation(libs.androidx.ui.test.junit4)
    debugImplementation(libs.androidx.ui.tooling)
    debugImplementation(libs.androidx.ui.test.manifest)
}