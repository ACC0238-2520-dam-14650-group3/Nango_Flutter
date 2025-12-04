import 'package:flutter/material.dart';
import 'package:nango_flutter/constants/app_colors.dart';

class NotificationsNangoView extends StatelessWidget {
  const NotificationsNangoView({super.key});

  // Mock data, to be replaced by backend data
  final List<Map<String, dynamic>> _notifications = const [
    {
      'name': 'John Doe',
      'type': 'chat',
      'message': 'Hey, are you available for a trip tomorrow?',
      'time': '10:45 AM',
      'avatar': 'J',
    },
    {
      'name': 'Jane Smith',
      'type': 'request',
      'message': 'Has accepted your travel request',
      'time': '9:30 AM',
      'avatar': 'J',
    },
    {
      'name': 'Peter Jones',
      'type': 'request',
      'message': 'Has rejected your travel request',
      'time': 'Yesterday',
      'avatar': 'P',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        foregroundColor: AppColors.secondaryText,
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title: const Text('Notifications',
            style: TextStyle(fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          final isChat = notification['type'] == 'chat';

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              onTap: isChat
                  ? () {
                      // TODO: Navigate to chat view
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Navigating to chat...')),
                      );
                    }
                  : null,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        notification['avatar'] as String,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification['name'] as String,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification['message'] as String,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 13.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          notification['type'] as String,
                          style: TextStyle(
                            color: isChat ? Colors.blue : Colors.green,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification['time'] as String,
                          style: const TextStyle(
                              color: Colors.black45, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
