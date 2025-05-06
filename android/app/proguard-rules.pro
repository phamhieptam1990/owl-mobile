-keep class com.google.android.gms.** { *; }
-keep interface com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Firebase Messaging
-keep class com.google.firebase.messaging.FirebaseMessagingService { *; }
-keep class com.google.firebase.iid.FirebaseInstanceIdService { *; }
-keep class com.google.firebase.messaging.** { *; }
-dontwarn com.google.firebase.messaging.**

# Keep all Firebase components
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# --- Flutter plugins ---
-keep class io.flutter.plugins.** { *; }

# --- Background Geolocation (transistorsoft) ---
-keep class com.transistorsoft.** { *; }

# --- Android Lifecycle (ViewModel, LiveData...) ---
-keep class androidx.lifecycle.** { *; }
-keepclassmembers class * {
    @androidx.lifecycle.* <methods>;
}

# --- AppCompat, Jetpack, AndroidX ---
-keep class androidx.appcompat.** { *; }
-dontwarn androidx.appcompat.**
-dontwarn androidx.activity.result.**

# --- Kotlin support ---
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-keep class kotlin.coroutines.** { *; }
-dontwarn kotlin.*
-dontwarn kotlin.jvm.functions.**
-dontwarn kotlin.coroutines.jvm.internal.**

# --- android_intent_plus ---
-keep class dev.fluttercommunity.plus.androidintent.** { *; }

# --- Fix crash with missing foldable/window APIs ---
-dontwarn androidx.window.**
-keep class androidx.window.** { *; }

# --- Prevent removal of any @Keep annotated code ---
-keep @androidx.annotation.Keep class * { *; }
-keep @androidx.annotation.Keep interface * { *; }

# --- Optional: For Firebase Performance Monitoring ---
-keepclassmembers class * {
  @com.google.firebase.perf.metrics.AddTrace <methods>;
  @com.google.firebase.perf.metrics.AddTrace <fields>;
}

# --- Optional: To help keep logs & crash info clean ---
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}
# --- Firestore ---
-keep class com.google.firebase.firestore.** { *; }
-dontwarn com.google.firebase.firestore.**

# --- gRPC / protobuf (cực kỳ quan trọng nếu dùng Firestore) ---
-keep class io.grpc.** { *; }
-dontwarn io.grpc.**

# --- Enum giữ lại method values() và valueOf() (Fix crash Enum like o7.H0.values) ---
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# --- Annotations giữ nguyên để Firebase làm việc đúng ---
-keepattributes *Annotation*

