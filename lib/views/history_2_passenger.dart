
import 'package:flutter/material.dart';
import 'package:nango_flutter/constants/app_colors.dart';
import 'package:nango_flutter/services/trip_history_service.dart';
import 'package:nango_flutter/views/comments2_passenger.dart';
import 'home_view.dart';
import 'package:nango_flutter/views/home_view.dart';
import 'package:nango_flutter/views/reschedule_passenger.dart';

class History2Passenger extends StatelessWidget {
  const History2Passenger({super.key});

  @override
  Widget build(BuildContext context) {
    // Get trips from the service
    final items = TripHistoryService().trips;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        foregroundColor: AppColors.secondaryText,
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title: const Text('History', style: TextStyle(fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications_none, color: Colors.black87),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.account_circle_outlined, color: Colors.black87),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (i) {
          if (i == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeView()),
              (r) => false,
            );
          }
        },
        backgroundColor: AppColors.backgroundLight,
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'quotes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'history',
          )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _TripCard(data: items[i]),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final TripCardData data;
  const _TripCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: BorderSide(color: AppColors.secondaryText, width: 1),
    );

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: border,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Starting Point',
                style: TextStyle(
                    color: AppColors.primaryDark, fontWeight: FontWeight.w800)),
            Text(
              data.start,
              style: const TextStyle(
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 8),
            Text('Destination',
                style: TextStyle(
                    color: AppColors.primaryDark, fontWeight: FontWeight.w800)),
            Text(
              data.dest,
              style: const TextStyle(
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _kv('Drive', data.driver),
                _kv(
                  'Date',
                  '${data.dateTime.day.toString().padLeft(2, '0')}/${data.dateTime.month.toString().padLeft(2, '0')}',
                ),
                _kv(
                  'Time',
                  '${data.dateTime.hour.toString().padLeft(2, '0')}:${data.dateTime.minute.toString().padLeft(2, '0')}',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _kv('Pay', 'S/.${data.price}'),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReschedulePassengerView(trip: data),
                          ),
                        );
                      },
                      icon: const Icon(Icons.event_repeat_outlined,
                          color: AppColors.primaryDark),
                      label: const Text('Reschedule',
                          style: TextStyle(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Comments2PassengerView(trip: data),
                          ),
                        );
                      },
                      icon: const Icon(Icons.mode_comment_outlined,
                          color: AppColors.primaryDark),
                      label: const Text('Comment',
                          style: TextStyle(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Text('Confirmed'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(k,
              style: TextStyle(
                  color: AppColors.primaryDark, fontWeight: FontWeight.w800)),
          Text(v,
              style: const TextStyle(
                  color: AppColors.primaryDark, fontWeight: FontWeight.normal)),
        ],
      );
}
