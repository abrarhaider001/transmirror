package com.transmirror.main

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.PixelFormat
import android.hardware.display.DisplayManager
import android.hardware.display.VirtualDisplay
import android.media.Image
import android.media.ImageReader
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.DisplayMetrics
import android.util.Log
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.nio.ByteBuffer

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.transmirror/screen_capture"
    private val PERMISSION_CODE = 1001
    
    private var mediaProjectionManager: MediaProjectionManager? = null
    private var mediaProjection: MediaProjection? = null
    private var virtualDisplay: VirtualDisplay? = null
    private var imageReader: ImageReader? = null
    
    private var screenDensity: Int = 0
    private var screenWidth: Int = 0
    private var screenHeight: Int = 0
    
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestPermission" -> {
                    requestProjectionPermission(result)
                }
                "captureScreen" -> {
                    captureScreen(result)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun requestProjectionPermission(result: MethodChannel.Result) {
        mediaProjectionManager = getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        startActivityForResult(mediaProjectionManager!!.createScreenCaptureIntent(), PERMISSION_CODE)
        pendingResult = result
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == PERMISSION_CODE) {
            if (resultCode == Activity.RESULT_OK && data != null) {
                // Initialize MediaProjection immediately
                try {
                    mediaProjection = mediaProjectionManager?.getMediaProjection(resultCode, data)
                    // Register callback as required by Android 14+
                    mediaProjection?.registerCallback(object : MediaProjection.Callback() {
                        override fun onStop() {
                            super.onStop()
                            mediaProjection = null
                            virtualDisplay?.release()
                            virtualDisplay = null
                        }
                    }, Handler(Looper.getMainLooper()))
                } catch (e: Exception) {
                    Log.e("MainActivity", "Failed to get MediaProjection: ${e.message}")
                    pendingResult?.error("SECURITY_EXCEPTION", "Failed to get MediaProjection. Foreground service might not be running.", e.message)
                    pendingResult = null
                    return
                }
                
                // Get Screen Metrics
                val metrics = DisplayMetrics()
                windowManager.defaultDisplay.getRealMetrics(metrics)
                screenDensity = metrics.densityDpi
                screenWidth = metrics.widthPixels
                screenHeight = metrics.heightPixels

                pendingResult?.success(true)
            } else {
                pendingResult?.success(false)
            }
            pendingResult = null
        }
    }

    private fun captureScreen(result: MethodChannel.Result) {
        if (mediaProjection == null) {
            result.error("NO_PERMISSION", "MediaProjection permission not granted", null)
            return
        }

        // Setup ImageReader
        imageReader = ImageReader.newInstance(screenWidth, screenHeight, PixelFormat.RGBA_8888, 2)
        
        // Create VirtualDisplay
        virtualDisplay = mediaProjection!!.createVirtualDisplay(
            "ScreenCapture",
            screenWidth,
            screenHeight,
            screenDensity,
            DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR,
            imageReader!!.surface,
            null,
            null
        )

        // Wait for the image to be available
        imageReader!!.setOnImageAvailableListener({ reader ->
            val image: Image? = reader.acquireLatestImage()
            if (image != null) {
                // Process image in background thread to avoid blocking UI
                Thread {
                    try {
                        val planes = image.planes
                        val buffer: ByteBuffer = planes[0].buffer
                        val pixelStride = planes[0].pixelStride
                        val rowStride = planes[0].rowStride
                        val rowPadding = rowStride - pixelStride * screenWidth
                        
                        val bitmap = Bitmap.createBitmap(
                            screenWidth + rowPadding / pixelStride,
                            screenHeight,
                            Bitmap.Config.ARGB_8888
                        )
                        bitmap.copyPixelsFromBuffer(buffer)
                        
                        // Crop out the padding if any
                        val finalBitmap = if (rowPadding == 0) {
                            bitmap
                        } else {
                            Bitmap.createBitmap(bitmap, 0, 0, screenWidth, screenHeight)
                        }

                        // Save to file
                        val file = File(cacheDir, "screenshot.png")
                        val fos = FileOutputStream(file)
                        finalBitmap.compress(Bitmap.CompressFormat.PNG, 100, fos)
                        fos.flush()
                        fos.close()
                        
                        // Cleanup
                        image.close()
                        virtualDisplay?.release()
                        virtualDisplay = null
                        imageReader?.close()
                        imageReader = null

                        // Return result on Main Thread
                        Handler(Looper.getMainLooper()).post {
                            result.success(file.absolutePath)
                        }
                    } catch (e: Exception) {
                        Handler(Looper.getMainLooper()).post {
                            result.error("CAPTURE_ERROR", e.message, null)
                        }
                    }
                }.start()
            }
        }, Handler(Looper.getMainLooper()))
    }

    override fun onDestroy() {
        super.onDestroy()
        mediaProjection?.stop()
        virtualDisplay?.release()
    }
}
