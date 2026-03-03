import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import '../models/card_theme.dart';
import '../models/dday.dart';

class WidgetService {
  static const _appGroupId = 'group.com.daycount.app';
  static const _androidWidgetName = 'DdayWidgetProvider';
  static const _iosWidgetName = 'DdayWidget';

  static Future<void> initialize() async {
    HomeWidget.setAppGroupId(_appGroupId);
  }

  /// Update the home screen widget with the closest D-Day.
  static Future<void> updateWidget(DDay? dday, DdayCardTheme? theme) async {
    if (dday == null) {
      await HomeWidget.saveWidgetData('widget_dday_title', '');
      await HomeWidget.saveWidgetData('widget_dday_empty', true);
    } else {
      final daysDiff = _calculateDaysDiff(dday);
      await HomeWidget.saveWidgetData('widget_dday_emoji', dday.emoji);
      await HomeWidget.saveWidgetData('widget_dday_title', dday.title);
      await HomeWidget.saveWidgetData('widget_dday_date', dday.targetDate);
      await HomeWidget.saveWidgetData('widget_dday_days', daysDiff.abs());
      await HomeWidget.saveWidgetData('widget_dday_is_past', daysDiff < 0);
      await HomeWidget.saveWidgetData('widget_dday_is_dday', daysDiff == 0);
      await HomeWidget.saveWidgetData('widget_dday_id', dday.id);

      if (theme != null) {
        final colors = _extractGradientColors(theme.background);
        await HomeWidget.saveWidgetData(
          'widget_theme_bg_start',
          colors.$1.toRadixString(16),
        );
        await HomeWidget.saveWidgetData(
          'widget_theme_bg_end',
          colors.$2.toRadixString(16),
        );
        await HomeWidget.saveWidgetData(
          'widget_theme_text',
          theme.textColor.toARGB32().toRadixString(16),
        );
        await HomeWidget.saveWidgetData(
          'widget_theme_accent',
          theme.accentColor.toARGB32().toRadixString(16),
        );
      }
      await HomeWidget.saveWidgetData('widget_dday_empty', false);
    }

    await HomeWidget.updateWidget(
      androidName: _androidWidgetName,
      iOSName: _iosWidgetName,
    );
  }

  /// Find the closest upcoming D-Day; falls back to most recent past.
  static DDay? findClosestDday(List<DDay> ddays) {
    if (ddays.isEmpty) return null;
    final today = DateUtils.dateOnly(DateTime.now());

    // Future D-Days sorted nearest first
    final future = ddays
        .where(
            (d) => !DateTime.parse(d.targetDate).isBefore(today))
        .toList()
      ..sort((a, b) => a.targetDate.compareTo(b.targetDate));
    if (future.isNotEmpty) return future.first;

    // No future — pick most recent past
    final past = ddays.toList()
      ..sort((a, b) => b.targetDate.compareTo(a.targetDate));
    return past.first;
  }

  static int _calculateDaysDiff(DDay dday) {
    final target = DateTime.parse(dday.targetDate);
    final now = DateUtils.dateOnly(DateTime.now());
    return target.difference(now).inDays;
  }

  /// Extract ARGB int values from a Gradient's first and last colors.
  static (int, int) _extractGradientColors(Gradient gradient) {
    final colors = gradient.colors;
    return (
      colors.first.toARGB32(),
      colors.last.toARGB32(),
    );
  }
}
