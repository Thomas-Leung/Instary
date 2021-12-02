package com.example.instary

import android.content.ContentValues
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import android.webkit.MimeTypeMap
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.IOException

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "flutter_media_store"
        ).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
                call, result ->
            when (call.method) { // "when" is like "switch" in java
                "downloadBackup" -> {
                    downloadBackup(call.argument("path")!!, call.argument("name")!!)
                    result.success(null)
                }
            }
        }
    }

    private fun downloadBackup(path: String, name: String) {
        val extension = MimeTypeMap.getFileExtensionFromUrl(path)
        var mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension)
        // Because .iry is not mime media types, mimeType will return null
        // and we need to use a special type
        if (mimeType == null) {
            mimeType = "application/octet-stream"
        }

        val collection: Uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            MediaStore.Downloads.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
        } else {
            // For Android 11 and below, so far I cannot find a way to save to external storage nor create a directory.
            // Therefore, export items will be in the Pictures folder
//            MediaStore.Files.getContentUri(Environment.getExternalStorageDirectory().path)
            println(MediaStore.Images.Media.EXTERNAL_CONTENT_URI)
            MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        }

        val values = ContentValues().apply {
            // TODO: NEED TO FIX THIS PART, for now accept a file, not image
            put(MediaStore.Downloads.DISPLAY_NAME, name)
            put(MediaStore.Downloads.MIME_TYPE, mimeType)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                put(
                    MediaStore.MediaColumns.RELATIVE_PATH,
                    Environment.DIRECTORY_DOWNLOADS + File.separator + "Instary Backup"
                )
                put(MediaStore.Downloads.IS_PENDING, 1)
            }
        }

        val resolver = applicationContext.contentResolver
        val uri = resolver.insert(collection, values)!!

        try {
            resolver.openOutputStream(uri).use { os ->
                File(path).inputStream().use { it.copyTo(os!!) }
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                values.clear()
                values.put(MediaStore.Downloads.IS_PENDING, 0)
                resolver.update(uri, values, null, null)
            }
        } catch (ex: IOException) {
            Log.e("MediaStore", ex.message, ex)
        }
    }
}
