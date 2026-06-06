import 'package:expense/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _notificationsEnabled = true;
  TimeOfDay _quietStart = const TimeOfDay(hour: 23, minute: 0); // 11 PM
  TimeOfDay _quietEnd = const TimeOfDay(hour: 7, minute: 0);   // 7 AM
  double _dailyCap = 5;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      
      final startHour = prefs.getInt('notifications_quiet_start_hour') ?? 23;
      final startMin = prefs.getInt('notifications_quiet_start_minute') ?? 0;
      _quietStart = TimeOfDay(hour: startHour, minute: startMin);

      final endHour = prefs.getInt('notifications_quiet_end_hour') ?? 7;
      final endMin = prefs.getInt('notifications_quiet_end_minute') ?? 0;
      _quietEnd = TimeOfDay(hour: endHour, minute: endMin);

      _dailyCap = prefs.getDouble('notifications_daily_cap') ?? 5.0;
    });
  }

  Future<void> _saveSetting(String key, dynamic val) async {
    final prefs = await SharedPreferences.getInstance();
    if (val is bool) {
      await prefs.setBool(key, val);
    } else if (val is int) {
      await prefs.setInt(key, val);
    } else if (val is double) {
      await prefs.setDouble(key, val);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.getBgBase(context),
      appBar: AppBar(
        title: const Text('Smart Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Switch card
          Container(
            decoration: AppShadows.getCardDecoration(context, radius: 12),
            child: SwitchListTile(
              activeThumbColor: AppColors.getBrandPrimary(context),
              title: Text(
                'Enable AI Notifications',
                style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
              ),
              subtitle: Text(
                'Get smart reminders and anomalies alerts.',
                style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
              ),
              value: _notificationsEnabled,
              onChanged: (val) {
                setState(() => _notificationsEnabled = val);
                _saveSetting('notifications_enabled', val);
              },
            ),
          ),
          const SizedBox(height: 20),

          // Quiet hours card
          Text(
            'QUIET HOURS',
            style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: AppShadows.getCardDecoration(context),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Notifications shifted',
                    style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
                  ),
                  subtitle: Text(
                    'Incoming notifications are delayed until quiet hours end.',
                    style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(
                    'Start Time',
                    style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
                  ),
                  trailing: Text(
                    _quietStart.format(context),
                    style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                  ),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _quietStart,
                    );
                    if (picked != null) {
                      setState(() => _quietStart = picked);
                      _saveSetting('notifications_quiet_start_hour', picked.hour);
                      _saveSetting('notifications_quiet_start_minute', picked.minute);
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(
                    'End Time',
                    style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
                  ),
                  trailing: Text(
                    _quietEnd.format(context),
                    style: AppTextStyles.bodySm(color: AppColors.getFgSecondary(context)),
                  ),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _quietEnd,
                    );
                    if (picked != null) {
                      setState(() => _quietEnd = picked);
                      _saveSetting('notifications_quiet_end_hour', picked.hour);
                      _saveSetting('notifications_quiet_end_minute', picked.minute);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Daily limits card
          Text(
            'ALERT LIMITS',
            style: AppTextStyles.overline(color: AppColors.getFgTertiary(context)),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: AppShadows.getCardDecoration(context),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daily Max Notifications',
                      style: AppTextStyles.headingSm(color: AppColors.getFgPrimary(context)),
                    ),
                    Text(
                      '${_dailyCap.toInt()} per day',
                      style: AppTextStyles.captionBold(color: AppColors.getBrandPrimary(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Slider(
                  value: _dailyCap,
                  min: 1,
                  max: 20,
                  divisions: 19,
                  activeColor: AppColors.getBrandPrimary(context),
                  inactiveColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5E5),
                  label: _dailyCap.toInt().toString(),
                  onChanged: (val) {
                    setState(() => _dailyCap = val);
                    _saveSetting('notifications_daily_cap', val);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
