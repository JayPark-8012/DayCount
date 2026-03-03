package com.daycount.daycount

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class DdayWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_dday)

            val isEmpty = widgetData.getBoolean("widget_dday_empty", true)
            if (isEmpty) {
                views.setTextViewText(R.id.widget_title, "Add your first D-Day")
                views.setTextViewText(R.id.widget_days, "")
                views.setTextViewText(R.id.widget_emoji, "\uD83D\uDCC5")
            } else {
                val emoji = widgetData.getString("widget_dday_emoji", "\uD83D\uDCC5") ?: "\uD83D\uDCC5"
                val title = widgetData.getString("widget_dday_title", "") ?: ""
                val days = widgetData.getInt("widget_dday_days", 0)
                val isPast = widgetData.getBoolean("widget_dday_is_past", false)
                val isDday = widgetData.getBoolean("widget_dday_is_dday", false)

                views.setTextViewText(R.id.widget_emoji, emoji)
                views.setTextViewText(R.id.widget_title, title)
                views.setTextViewText(
                    R.id.widget_days,
                    when {
                        isDday -> "D-Day!"
                        isPast -> "D+$days"
                        else -> "D-$days"
                    }
                )
            }

            val intent = HomeWidgetLaunchIntent.getActivity(
                context, MainActivity::class.java
            )
            views.setOnClickPendingIntent(R.id.widget_root, intent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
