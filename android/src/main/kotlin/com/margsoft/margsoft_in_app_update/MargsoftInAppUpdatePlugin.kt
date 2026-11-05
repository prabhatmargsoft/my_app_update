
package com.margsoft.margsoft_in_app_update

import android.app.Activity
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.google.android.play.core.appupdate.AppUpdateManager
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.appupdate.AppUpdateOptions
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.UpdateAvailability

class MargsoftInAppUpdatePlugin :
    FlutterPlugin,
    MethodChannel.MethodCallHandler,
    ActivityAware {

    private lateinit var channel: MethodChannel
    private lateinit var appUpdateManager: AppUpdateManager

    private var activity: Activity? = null

    companion object {
        private const val CHANNEL = "margsoft_in_app_update"
        private const val REQUEST_CODE = 1001
    }

    override fun onAttachedToEngine(
        binding: FlutterPlugin.FlutterPluginBinding
    ) {
        appUpdateManager = AppUpdateManagerFactory.create(
            binding.applicationContext
        )

        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {

            "getPlatformVersion" -> {
                result.success("Android ${Build.VERSION.RELEASE}")
            }

            "checkForUpdate" -> {
                appUpdateManager.appUpdateInfo
                    .addOnSuccessListener { info ->

                        result.success(
                            mapOf(
                                "updateAvailable" to
                                        (info.updateAvailability() ==
                                                UpdateAvailability.UPDATE_AVAILABLE),
                                "availableVersionCode" to
                                        info.availableVersionCode(),
                                "updateAvailability" to
                                        info.updateAvailability(),
                                "immediateAllowed" to
                                        info.isUpdateTypeAllowed(
                                            AppUpdateType.IMMEDIATE
                                        ),
                                "flexibleAllowed" to
                                        info.isUpdateTypeAllowed(
                                            AppUpdateType.FLEXIBLE
                                        )
                            )
                        )
                    }
                    .addOnFailureListener { error ->
                        result.error(
                            "UPDATE_CHECK_FAILED",
                            error.message,
                            null
                        )
                    }
            }

            "startImmediateUpdate" -> {
                startImmediateUpdate(result)
            }

            else -> result.notImplemented()
        }
    }

    private fun startImmediateUpdate(
        result: MethodChannel.Result
    ) {
        val currentActivity = activity

        if (currentActivity == null) {
            result.error(
                "ACTIVITY_NOT_AVAILABLE",
                "Android Activity is not attached.",
                null
            )
            return
        }

        appUpdateManager.appUpdateInfo
            .addOnSuccessListener { info ->

                val availability = info.updateAvailability()

                val updateAvailable =
                    availability == UpdateAvailability.UPDATE_AVAILABLE ||
                            availability == UpdateAvailability
                        .DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS

                if (!updateAvailable) {
                    result.success(
                        mapOf(
                            "started" to false,
                            "reason" to "no_update_available"
                        )
                    )
                    return@addOnSuccessListener
                }

                if (!info.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)) {
                    result.success(
                        mapOf(
                            "started" to false,
                            "reason" to "immediate_update_not_allowed"
                        )
                    )
                    return@addOnSuccessListener
                }

                try {
                    val options = AppUpdateOptions
                        .newBuilder(AppUpdateType.IMMEDIATE)
                        .build()

                    val started =
                        appUpdateManager.startUpdateFlowForResult(
                            info,
                            currentActivity,
                            options,
                            REQUEST_CODE
                        )

                    result.success(
                        mapOf("started" to started)
                    )

                } catch (error: Exception) {
                    result.error(
                        "IMMEDIATE_UPDATE_FAILED",
                        error.message,
                        null
                    )
                }
            }
            .addOnFailureListener { error ->
                result.error(
                    "UPDATE_CHECK_FAILED",
                    error.message,
                    null
                )
            }
    }

    override fun onAttachedToActivity(
        binding: ActivityPluginBinding
    ) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(
        binding: ActivityPluginBinding
    ) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromEngine(
        binding: FlutterPlugin.FlutterPluginBinding
    ) {
        channel.setMethodCallHandler(null)
    }
}
