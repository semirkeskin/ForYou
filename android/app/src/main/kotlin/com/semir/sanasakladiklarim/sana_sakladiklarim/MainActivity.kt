package com.semir.sanasakladiklarim.sana_sakladiklarim

import android.app.PictureInPictureParams
import android.os.Build
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    /**
     * Home tusuna basildiginda otomatik olarak Picture-in-Picture moduna gec.
     * Boylece uygulama arka plana atildiginda kucuk surukleyebilir pencere
     * olarak ekranda kalir. Android 8 (API 26) ve uzeri destekler.
     */
    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
            packageManager.hasSystemFeature(
                android.content.pm.PackageManager.FEATURE_PICTURE_IN_PICTURE
            )
        ) {
            // 9:16 portrait oraninda kucuk pencere
            val params = PictureInPictureParams.Builder()
                .setAspectRatio(Rational(9, 16))
                .build()
            runCatching { enterPictureInPictureMode(params) }
        }
    }
}
