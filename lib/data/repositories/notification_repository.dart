import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/dday.dart';
import '../models/milestone.dart';

class NotificationRepository {
  NotificationRepository._();
  static final NotificationRepository instance = NotificationRepository._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  static void initializeTimeZones() {
    tz.initializeTimeZones();
  }

  Future<void> initialize() async {
    if (_initialized || kIsWeb) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channel
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'daycount_milestones',
            'Milestone Alerts',
            description: 'Notifications for D-Day milestones',
            importance: Importance.high,
          ),
        );

    _initialized = true;
    debugPrint('[NotificationRepository] Initialized');
  }

  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint(
      '[NotificationRepository] Tapped notification: ${response.payload}',
    );
  }

  // ---------------------------------------------------------------------------
  // Permissions
  // ---------------------------------------------------------------------------

  Future<bool> requestPermissions() async {
    if (kIsWeb) return false;

    // iOS
    final iosGranted = await _plugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true) ??
        true;

    // Android 13+
    final androidGranted = await _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission() ??
        true;

    return iosGranted && androidGranted;
  }

  // ---------------------------------------------------------------------------
  // Schedule / Cancel
  // ---------------------------------------------------------------------------

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    if (kIsWeb) return;

    final scheduleTime = _toScheduleTime(scheduledDate);

    // Skip past dates
    if (scheduleTime.isBefore(tz.TZDateTime.now(tz.local))) {
      debugPrint(
        '[NotificationRepository] Skipping past notification id=$id '
        'scheduled=$scheduledDate',
      );
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'daycount_milestones',
      'Milestone Alerts',
      channelDescription: 'Notifications for D-Day milestones',
      importance: Importance.high,
      priority: Priority.high,
    );

    const darwinDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: '$id',
    );

    debugPrint(
      '[NotificationRepository] Scheduled id=$id at $scheduleTime',
    );
  }

  Future<void> cancelNotification(int id) async {
    if (kIsWeb) return;
    await _plugin.cancel(id);
  }

  Future<void> cancelAllForDday(int ddayId) async {
    if (kIsWeb) return;

    final pending = await _plugin.pendingNotificationRequests();
    final rangeStart = ddayId * 10000;
    final rangeEnd = rangeStart + 9999;

    for (final request in pending) {
      if (request.id >= rangeStart && request.id <= rangeEnd) {
        await _plugin.cancel(request.id);
      }
    }

    debugPrint(
      '[NotificationRepository] Cancelled all for ddayId=$ddayId',
    );
  }

  // ---------------------------------------------------------------------------
  // Reschedule all for a D-Day
  // ---------------------------------------------------------------------------

  Future<void> rescheduleAllForDday(
    DDay dday,
    List<Milestone> milestones, {
    bool milestoneAlertsEnabled = true,
    bool ddayAlertsEnabled = true,
  }) async {
    if (kIsWeb || dday.id == null) return;

    final ddayId = dday.id!;

    // 1. Cancel existing
    await cancelAllForDday(ddayId);

    // 2. Check if notifications are enabled for this D-Day
    if (!dday.notifyEnabled) {
      debugPrint(
        '[NotificationRepository] Notifications disabled for ddayId=$ddayId',
      );
      return;
    }

    final target = DateTime.parse(dday.targetDate);

    // 3. Schedule milestone notifications (if global toggle is ON)
    if (milestoneAlertsEnabled) {
      for (final milestone in milestones) {
        if (milestone.id == null) continue;

        final mDate = _milestoneDate(target, milestone.days, dday.category);

        for (final notifyBefore in milestone.notifyBefore) {
          final notifyType = _notifyTypeIndex(notifyBefore);
          if (notifyType < 0) continue;

          final notifDate = _notificationDate(mDate, notifyBefore);
          final notifId = _notificationId(ddayId, milestone.id!, notifyType);

          final body = _milestoneBody(
            notifyBefore: notifyBefore,
            ddayTitle: dday.title,
            milestoneLabel: milestone.label,
          );

          await scheduleNotification(
            id: notifId,
            title: dday.title,
            body: body,
            scheduledDate: notifDate,
          );
        }
      }
    }

    // 4. Schedule D-Day itself alert (if global toggle is ON)
    if (ddayAlertsEnabled) {
      final ddayNotifId = _ddayNotificationId(ddayId);
      await scheduleNotification(
        id: ddayNotifId,
        title: dday.title,
        body: '\u{1F389} Today is the day! ${dday.title}',
        scheduledDate: target,
      );
    }

    debugPrint(
      '[NotificationRepository] Rescheduled all for ddayId=$ddayId',
    );
  }

  // ---------------------------------------------------------------------------
  // ID helpers
  // ---------------------------------------------------------------------------

  int _notificationId(int ddayId, int milestoneId, int notifyType) {
    return ddayId * 10000 + milestoneId * 10 + notifyType;
  }

  int _ddayNotificationId(int ddayId) {
    return ddayId * 10000 + 9999;
  }

  int _notifyTypeIndex(String notifyBefore) {
    switch (notifyBefore) {
      case '7d':
        return 0;
      case '3d':
        return 1;
      case '0d':
        return 2;
      default:
        return -1;
    }
  }

  // ---------------------------------------------------------------------------
  // Date helpers
  // ---------------------------------------------------------------------------

  DateTime _milestoneDate(DateTime target, int days, String category) {
    if (category == 'exam') {
      return target.subtract(Duration(days: days));
    }
    return target.add(Duration(days: days));
  }

  DateTime _notificationDate(DateTime milestoneDate, String notifyBefore) {
    switch (notifyBefore) {
      case '7d':
        return milestoneDate.subtract(const Duration(days: 7));
      case '3d':
        return milestoneDate.subtract(const Duration(days: 3));
      case '0d':
      default:
        return milestoneDate;
    }
  }

  tz.TZDateTime _toScheduleTime(DateTime date) {
    return tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      9, // 9:00 AM
    );
  }

  // ---------------------------------------------------------------------------
  // Notification body text
  // ---------------------------------------------------------------------------

  String _milestoneBody({
    required String notifyBefore,
    required String ddayTitle,
    required String milestoneLabel,
  }) {
    switch (notifyBefore) {
      case '7d':
        return '7 days until $ddayTitle hits $milestoneLabel!';
      case '3d':
        return 'Only 3 days to go! $ddayTitle - $milestoneLabel';
      case '0d':
        return '\u{1F389} Today is $milestoneLabel for $ddayTitle!';
      default:
        return '$ddayTitle - $milestoneLabel';
    }
  }
}
