import 'package:flutter/material.dart';
import 'package:nango_flutter/constants/app_colors.dart';
import 'package:nango_flutter/views/home_view.dart';
import 'package:nango_flutter/views/history_2_passenger.dart';
import 'package:nango_flutter/views/quotes1_passenger.dart';
import 'package:nango_flutter/views/history_1_passenger.dart';
import 'package:nango_flutter/views/account_view.dart';
import 'package:nango_flutter/views/notifications_nango.dart';

import '../services/trip_history_service.dart'; // para TripCardData

class ReschedulePassengerView extends StatefulWidget {
  final TripCardData trip;
  const ReschedulePassengerView({super.key, required this.trip});

  @override
  State<ReschedulePassengerView> createState() =>
      _ReschedulePassengerViewState();
}

class _ReschedulePassengerViewState extends State<ReschedulePassengerView> {
  String _payment = 'Yape';

  @override
  Widget build(BuildContext context) {
    final t = widget.trip;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        foregroundColor: AppColors.secondaryText,
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title:
        const Text('Reschedule', style: TextStyle(fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black87),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsNangoView()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: IconButton(
              icon: const Icon(Icons.account_circle_outlined, color: Colors.black87),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AccountView()),
                );
              },
            ),
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
          } else if (i == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Quotes1Passenger()),
            );
          } else if (i == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const History1Passenger()),
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
            label: 'history',)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // mapa
            Container(
              height: 190,
              decoration: BoxDecoration(
                color: AppColors.secondaryText,
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/images/map_placeholder.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Driver + rating
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    t.driver.isNotEmpty ? t.driver[0] : '?',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.driver,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16)),
                      const Text(
                        'Student / Driver',
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    Icon(Icons.star_half, color: Colors.amber, size: 20),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),

            _rowTitleValue('Starting Point', t.start),
            const SizedBox(height: 8),
            _rowTitleValue('Destination', t.dest),
            const SizedBox(height: 8),
            _rowTitleValue(
              'Departure date',
              '${t.dateTime.day.toString().padLeft(2, '0')}/${t.dateTime.month.toString().padLeft(2, '0')}',
            ),
            const SizedBox(height: 8),
            _rowTitleValue(
              'Departure time',
              '${t.dateTime.hour.toString().padLeft(2, '0')}:${t.dateTime.minute.toString().padLeft(2, '0')}',
            ),
            const SizedBox(height: 8),
            _rowTitleValue('Estimated price', 'S/.${t.price}'),

            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Payment method',
                  style: TextStyle(
                      color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: [
                _paymentChip('Yape'),
                _paymentChip('Plin'),
                _paymentChip('Cash'),
              ],
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.tertiaryText),
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(
                      color: AppColors.tertiaryText,
                    ),),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      // confirmación >.<
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Schedule changed sucessfulyy')),
                      );
                    },
                    child: const Text('Request', style: TextStyle(
                      color: AppColors.backgroundDefault,
                    ),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentChip(String label) {
    final selected = _payment == label;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: AppColors.primary.withOpacity(0.15),
      onSelected: (_) => setState(() => _payment = label),
      labelStyle: TextStyle(
        color: selected ? AppColors.primary : Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: BorderSide(
        color: selected ? AppColors.primary : Colors.grey.shade400,
      ),
    );
  }

  Widget _rowTitleValue(String title, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style:
            TextStyle(color:  AppColors.primaryDark, fontWeight: FontWeight.w800)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(value,
              textAlign: TextAlign.right,
              style: const TextStyle(color:  AppColors.primaryDark, fontWeight: FontWeight.normal)),
        ),
      ],
    ),
  );
}
