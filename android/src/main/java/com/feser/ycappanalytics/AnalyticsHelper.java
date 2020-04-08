package com.feser.ycappanalytics;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import com.feser.ycapp_foundation.prefs.Prefs;
import com.feser.ycappconnectivity.Connectivity;
import com.google.firebase.analytics.FirebaseAnalytics;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;


public class AnalyticsHelper {

    public static void log(Context context, String log) {
        log(context, log, null);
    }

    public static void log(Context context, String log, Bundle bundle) {
        Log.d("AnalyticsHelper", "log");

        Prefs prefs = new Prefs(context);
        boolean analyticsPermission = prefs.getBool("analyticsPermission", false);

        if (!analyticsPermission) {
            return;
        }

        if (bundle == null) {
            bundle = new Bundle();
        }

        try {

            Date date = new Date();
            @SuppressLint("SimpleDateFormat")
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
            String utcString = sdf.format(date);
            Log.d("AnalyticsHelper", utcString);
            bundle.putString("utc", utcString);

            String networkType = Connectivity.getNetworkType(context);

            bundle.putString("networkType", networkType);
            bundle.putInt("androidSDK", Build.VERSION.SDK_INT);

        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.getInstance(context);
            firebaseAnalytics.logEvent(log, bundle);
        } catch (Exception e) {
            Log.e("Analytics", "error", e);
        }

        prefs.destroy();

    }


}
