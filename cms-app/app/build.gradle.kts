plugins {
    alias(libs.plugins.android.application)
}

android {
    namespace = "com.netflix_plus_plus.cms"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.netflix_plus_plus.cms"
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
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
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    buildFeatures {
        viewBinding = true
    }
}

dependencies {
    // AndroidX Core
    implementation(libs.appcompat)
    implementation(libs.material)
    implementation(libs.activity)
    implementation(libs.constraintlayout)

    // Retrofit for API calls
    implementation("com.squareup.retrofit2:retrofit:2.9.0")
    implementation("com.squareup.retrofit2:converter-gson:2.9.0")
    implementation("com.squareup.okhttp3:logging-interceptor:4.11.0")

    // RecyclerView
    implementation("androidx.recyclerview:recyclerview:1.3.2")
    implementation("androidx.cardview:cardview:1.0.0")

    // Image loading (for cover images)
    implementation("com.github.bumptech.glide:glide:4.16.0")

    // Testing
    testImplementation(libs.junit)
    androidTestImplementation(libs.ext.junit)
    androidTestImplementation(libs.espresso.core)

    // Google Cloud Storage
    implementation("com.google.cloud:google-cloud-storage:2.29.1")
    // Google Auth Library
    implementation("com.google.auth:google-auth-library-oauth2-http:1.20.0")
    // Guava (required by GCS SDK)
    implementation("com.google.guava:guava:32.1.3-android")
    // Gson for JSON parsing
    implementation("com.google.code.gson:gson:2.10.1")
}