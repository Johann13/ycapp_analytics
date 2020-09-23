package com.feser.ycappanalytics;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.InstanceIdResult;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * YcappanalyticsPlugin
 */
public class YcappanalyticsPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context context;
    public YcappanalyticsPlugin(){}

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "ycappanalytics");
        channel.setMethodCallHandler(new YcappanalyticsPlugin());
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "ycappanalytics");
        channel.setMethodCallHandler(new YcappanalyticsPlugin(registrar.context()));
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
        switch (call.method) {
            case "user":
                if(context!=null) {
                    UserWorker.enqueue(context);
                }
                result.success(null);
            case "getId":
                result.success(FirebaseInstanceId.getInstance().getId());
                break;
            case "log":
                @SuppressWarnings("unchecked")
                Map<String, Object> arguments = (Map<String, Object>) call.arguments;
                final String eventName = (String) arguments.get("name");

                @SuppressWarnings("unchecked") final Bundle parameterBundle =
                        createBundleFromMap((Map<String, Object>) arguments.get("parameters"));
                if(context!=null) {
                    AnalyticsHelper.log(context, eventName, parameterBundle);
                }

                result.success(null);
                break;
            case "enable":
                if (call.hasArgument("enable")) {
                    boolean enable = call.argument("enable");
                    FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.getInstance(context);
                    firebaseAnalytics.setAnalyticsCollectionEnabled(enable);
                    result.success(true);
                } else {
                    result.success(false);
                }
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        context = null;
        channel.setMethodCallHandler(null);
    }


    private Bundle createBundleFromMap(Map<String, Object> map) {
        if (map == null) {
            return null;
        }

        Bundle bundle = new Bundle();
        for (Map.Entry<String, Object> jsonParam : map.entrySet()) {
            final Object value = jsonParam.getValue();
            final String key = jsonParam.getKey();
            if (value instanceof String) {
                bundle.putString(key, (String) value);
            } else if (value instanceof Integer) {
                bundle.putInt(key, (Integer) value);
            } else if (value instanceof Long) {
                bundle.putLong(key, (Long) value);
            } else if (value instanceof Double) {
                bundle.putDouble(key, (Double) value);
            } else if (value instanceof Boolean) {
                bundle.putBoolean(key, (Boolean) value);
            } else {
                throw new IllegalArgumentException(
                        "Unsupported value type: " + value.getClass().getCanonicalName());
            }
        }
        return bundle;
    }
}
