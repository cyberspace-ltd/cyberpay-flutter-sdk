package com.cyberspace.cyberpayflutter

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.BatteryManager
import androidx.annotation.NonNull
import androidx.appcompat.app.AppCompatActivity
import com.cyberspace.cyberpaysdk.CyberpaySdk
import com.cyberspace.cyberpaysdk.TransactionCallback
import com.cyberspace.cyberpaysdk.model.Transaction
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.*
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


/** CyberpayflutterPlugin */
public class CyberpayflutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var eventChannel: EventChannel

  private var activity: Activity? = null
  private var applicationContext: Context? = null
  private var RESULT_CODE = 1001
  private var pluginResult: Result? = null
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.applicationContext = flutterPluginBinding.applicationContext;
    onAttachedToEngine(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger)
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val instance = CyberpayflutterPlugin()
      registrar.addActivityResultListener(instance)
      instance.onAttachedToEngine(registrar.context(), registrar.messenger());

    }
  }

  private fun onAttachedToEngine(applicationContext: Context, messenger: BinaryMessenger) {
    this.applicationContext = applicationContext
    channel = MethodChannel(messenger, "cyberpayflutter")
    channel.setMethodCallHandler(this)
  }
  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    pluginResult = result
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    }
    else if (call.method == "checkout") {
      val integrationKey = call.argument<String>("integrationKey").toString()
      val amount = call.argument<Double>("amount")
      val customerEmail: String = call.argument<String>("customerEmail").toString()
      val liveMode = call.argument<Boolean>("liveMode")

      val intent = Intent(
              activity, PaymentActivity::class.java)
      intent.putExtra("integrationKey", integrationKey)
      intent.putExtra("mode", liveMode)
      intent.putExtra("referenceMode", false)
      intent.putExtra("customerEmail", customerEmail)
      intent.putExtra("amount", amount)

      activity!!.startActivityForResult(intent, RESULT_CODE)
    }
    else if (call.method == "checkoutRef") {
      val integrationKey = call.argument<String>("integrationKey").toString()
      val reference: String = call.argument<String>("reference").toString()
      val liveMode = call.argument<Boolean>("liveMode")
      val intent = Intent(
              activity, PaymentActivity::class.java)
      intent.putExtra("integrationKey", integrationKey)
      intent.putExtra("mode", liveMode)
      intent.putExtra("reference", reference)
      intent.putExtra("referenceMode", true)
      activity!!.startActivityForResult(intent, RESULT_CODE)
    }
     else {
      result.notImplemented()
    }
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    if (requestCode == RESULT_CODE) {
      if (resultCode == Activity.RESULT_OK) {
        if (data!!.hasExtra("success")){
          val result = data.getStringExtra("success")
          pluginResult!!.success(result)
        }
        else if (data.hasExtra("error")){
          val result = data.getStringExtra("error")
          pluginResult!!.error("CYBERPAY_ERROR", result,null )
        }
        else {
          pluginResult!!.notImplemented()
        }
        return true
      }
    }
    return false
  }
  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addActivityResultListener(this);
    channel.setMethodCallHandler(this)
  }
  override fun onDetachedFromActivity() {
    activity = null
    channel.setMethodCallHandler(null)
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }



}
