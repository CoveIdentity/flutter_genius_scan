package com.geniusscansdk.flutter;

import android.app.Activity;
import android.content.Intent;

import com.geniusscansdk.scanflow.PluginBridge;
import com.geniusscansdk.scanflow.PromiseResult;

import java.util.HashMap;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterGeniusScanPlugin */
public class FlutterGeniusScanPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {

  private FlutterPluginBinding flutterPluginBinding;
  private MethodChannel channel;
  private Activity activity;
  private Result scanWithConfigurationResult;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    FlutterGeniusScanPlugin plugin = new FlutterGeniusScanPlugin();
    plugin.channel = new MethodChannel(registrar.messenger(), "flutter_genius_scan");
    plugin.activity = registrar.activity();
    plugin.channel.setMethodCallHandler(plugin);
    registrar.addActivityResultListener(plugin);
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    flutterPluginBinding = binding;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    flutterPluginBinding = null;
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_genius_scan");
    activity = binding.getActivity();
    channel.setMethodCallHandler(this);
    binding.addActivityResultListener(this);
  }

  @Override
  public void onDetachedFromActivity() {
    if (channel == null) {
      return;
    }

    channel.setMethodCallHandler(null);
    channel = null;
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onMethodCall(MethodCall call, @NonNull Result result) {
    if (call.method.equals("setLicenceKey")) {
      PromiseResult promiseResult = PluginBridge.setLicenseKey(activity, (String)call.arguments);
      returnResultFromPromiseResult(result, promiseResult);
    } else if (call.method.equals("scanWithConfiguration")) {
      scanWithConfigurationResult = result;
      PluginBridge.scanWithConfiguration(activity, call.<HashMap<String, Object>>arguments());
    } else {
      result.notImplemented();
    }
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    PromiseResult promiseResult = PluginBridge.getPromiseResultFromActivityResult(activity, requestCode, resultCode, data);
    if (promiseResult != null && scanWithConfigurationResult != null) {
      returnResultFromPromiseResult(scanWithConfigurationResult, promiseResult);
      return true;
    }
    return false;
  }

  private void returnResultFromPromiseResult(Result result, PromiseResult promiseResult) {
    if (promiseResult.isError) {
      result.error(promiseResult.errorCode, promiseResult.errorMessage, null);
    } else {
      result.success(promiseResult.result);
    }
  }
}
