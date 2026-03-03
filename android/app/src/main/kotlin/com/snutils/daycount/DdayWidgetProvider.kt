package com.snutils.daycount

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Paint
import android.graphics.RectF
import android.graphics.Shader
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

            val density = context.resources.displayMetrics.density
            val emojiSizePx = (32 * density).toInt()

            val isEmpty = widgetData.getBoolean("widget_dday_empty", true)
            if (isEmpty) {
                views.setTextViewText(R.id.widget_title, "Add your first D-Day")
                views.setTextViewText(R.id.widget_days, "")
                views.setTextViewText(R.id.widget_date, "")
                views.setTextViewText(R.id.widget_label, "")
                views.setImageViewBitmap(R.id.widget_emoji, emojiBitmap("\uD83D\uDCC5", emojiSizePx))
            } else {
                val emoji = widgetData.getString("widget_dday_emoji", "\uD83D\uDCC5") ?: "\uD83D\uDCC5"
                val title = widgetData.getString("widget_dday_title", "") ?: ""
                val date = widgetData.getString("widget_dday_date", "") ?: ""
                val days = widgetData.getInt("widget_dday_days", 0)
                val isPast = widgetData.getBoolean("widget_dday_is_past", false)
                val isDday = widgetData.getBoolean("widget_dday_is_dday", false)

                views.setImageViewBitmap(R.id.widget_emoji, emojiBitmap(emoji, emojiSizePx))
                views.setTextViewText(R.id.widget_title, title)
                views.setTextViewText(R.id.widget_date, date)
                views.setTextViewText(
                    R.id.widget_days,
                    when {
                        isDday -> "D-Day!"
                        isPast -> "D+$days"
                        else -> "D-$days"
                    }
                )
                views.setTextViewText(
                    R.id.widget_label,
                    when {
                        isDday -> ""
                        isPast -> if (days == 1) "day ago" else "days ago"
                        else -> if (days == 1) "day left" else "days left"
                    }
                )

                // Apply theme colors
                val bgStart = parseArgbHex(
                    widgetData.getString("widget_theme_bg_start", null),
                    0xFF6C63FF.toInt()
                )
                val bgEnd = parseArgbHex(
                    widgetData.getString("widget_theme_bg_end", null),
                    0xFF8B5CF6.toInt()
                )
                val textColor = parseArgbHex(
                    widgetData.getString("widget_theme_text", null),
                    Color.WHITE
                )
                val accentColor = parseArgbHex(
                    widgetData.getString("widget_theme_accent", null),
                    Color.WHITE
                )

                // Dynamic gradient background bitmap
                val bgBitmap = createGradientBitmap(bgStart, bgEnd, 500, 200)
                views.setImageViewBitmap(R.id.widget_bg, bgBitmap)

                // Text colors from theme
                views.setTextColor(R.id.widget_title, textColor)
                views.setTextColor(R.id.widget_date, adjustAlpha(textColor, 0.35f))
                views.setTextColor(R.id.widget_days, accentColor)
                views.setTextColor(R.id.widget_label, adjustAlpha(textColor, 0.35f))
            }

            val intent = HomeWidgetLaunchIntent.getActivity(
                context, MainActivity::class.java
            )
            views.setOnClickPendingIntent(R.id.widget_root, intent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun parseArgbHex(hex: String?, fallback: Int): Int {
        if (hex.isNullOrEmpty()) return fallback
        return try {
            java.lang.Long.parseLong(hex, 16).toInt()
        } catch (e: NumberFormatException) {
            fallback
        }
    }

    private fun createGradientBitmap(startColor: Int, endColor: Int, width: Int, height: Int): Bitmap {
        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        val paint = Paint()
        val cornerRadius = 16f * (width / 500f) // scale radius proportionally

        paint.shader = LinearGradient(
            0f, 0f, width.toFloat(), height.toFloat(),
            startColor, endColor,
            Shader.TileMode.CLAMP
        )
        canvas.drawRoundRect(
            RectF(0f, 0f, width.toFloat(), height.toFloat()),
            cornerRadius, cornerRadius, paint
        )
        return bitmap
    }

    private fun emojiBitmap(emoji: String, sizePx: Int): Bitmap {
        val bitmap = Bitmap.createBitmap(sizePx, sizePx, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        val paint = Paint(Paint.ANTI_ALIAS_FLAG)
        paint.textSize = sizePx * 0.75f
        paint.textAlign = Paint.Align.CENTER
        val x = sizePx / 2f
        val y = sizePx / 2f - (paint.ascent() + paint.descent()) / 2f
        canvas.drawText(emoji, x, y, paint)
        return bitmap
    }

    private fun adjustAlpha(color: Int, factor: Float): Int {
        val alpha = (Color.alpha(color) * factor).toInt().coerceIn(0, 255)
        return Color.argb(alpha, Color.red(color), Color.green(color), Color.blue(color))
    }
}
