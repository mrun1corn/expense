import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Notifications'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable AI Notifications'),
            subtitle: const Text('Get smart reminders and anomalies alerts.'),
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
          ),
          const Divider(),
          const ListTile(
            title: Text('Quiet Hours', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Notifications will be shifted until morning.'),
          ),
          ListTile(
            title: const Text('Start Time'),
            trailing: Text(_quietStart.format(context)),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _quietStart,
              );
              if (picked != null) setState(() => _quietStart = picked);
            },
          ),
          ListTile(
            title: const Text('End Time'),
            trailing: Text(_quietEnd.format(context)),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _quietEnd,
              );
              if (picked != null) setState(() => _quietEnd = picked);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Daily Max Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${_dailyCap.toInt()} alerts per day'),
          ),
          Slider(
            value: _dailyCap,
            min: 1,
            max: 20,
            divisions: 19,
            label: _dailyCap.toInt().toString(),
            onChanged: (val) => setState(() => _dailyCap = val),
          ),
        ],
      ),
    );
  }
}