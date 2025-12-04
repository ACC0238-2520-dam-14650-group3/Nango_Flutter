import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nango_flutter/constants/app_colors.dart';
import 'package:nango_flutter/views/home_view.dart';
import 'package:nango_flutter/views/quotes2_passenger.dart';
import 'package:nango_flutter/views/history_1_passenger.dart';
import 'package:nango_flutter/views/account_view.dart';
import 'package:nango_flutter/views/notifications_nango.dart';

class Quotes1Filters {
  final String start;
  final String dest;
  final String date;
  final String time;

  Quotes1Filters({
    required this.start,
    required this.dest,
    required this.date,
    required this.time,
  });
}

class Quotes1Passenger extends StatefulWidget {
  const Quotes1Passenger({super.key});

  @override
  State<Quotes1Passenger> createState() => _Quotes1PassengerState();
}

class _Quotes1PassengerState extends State<Quotes1Passenger> {
  final TextEditingController _startingPointController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  void dispose() {
    _startingPointController.dispose();
    _destinationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  InputDecoration _decoration({Widget? prefix}) {
    const radius = BorderRadius.all(Radius.circular(10));
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      prefixIcon: prefix,
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: Colors.black26, width: 1.2),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        foregroundColor: AppColors.secondaryText,
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title: const Text('Quotes', style: TextStyle(fontWeight: FontWeight.w800)),
        iconTheme: const IconThemeData(color: Colors.black87),
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
        currentIndex: 1,
        onTap: (i) {
          if (i == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeView()),
              (r) => false,
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
        elevation: 0,
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _label('Starting Point'),
            TextFormField(
              controller: _startingPointController,
              decoration: _decoration(prefix: const Icon(Icons.my_location, color: Colors.grey)),
            ),
            const SizedBox(height: 12),
            _label('Destination'),
            TextFormField(
              controller: _destinationController,
              decoration: _decoration(prefix: const Icon(Icons.location_on, color: Colors.grey)),
            ),
            const SizedBox(height: 12),
            _label('Departure Date'),
            TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: _decoration(prefix: const Icon(Icons.calendar_today, color: Colors.grey)),
            ),
            const SizedBox(height: 12),
            _label('Departure Time'),
            TextFormField(
              controller: _timeController,
              readOnly: true,
              onTap: () => _selectTime(context),
              decoration: _decoration(prefix: const Icon(Icons.access_time, color: Colors.grey)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                onPressed: () {
                  final filters = Quotes1Filters(
                    start: _startingPointController.text,
                    dest: _destinationController.text,
                    date: _dateController.text,
                    time: _timeController.text,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Quotes2Passenger(filters: filters),
                    ),
                  );
                },
                child: const Text('Find'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}