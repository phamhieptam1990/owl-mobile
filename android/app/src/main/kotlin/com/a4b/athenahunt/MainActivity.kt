package com.a4b.athenahunt // hoặc com.a4b.athenahunt tùy theo flavor

import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity
import com.google.firebase.FirebaseApp

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Nếu bạn cần init Firebase thủ công, có thể thêm:
         FirebaseApp.initializeApp(this)
    }
}
