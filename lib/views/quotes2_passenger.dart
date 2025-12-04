import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nango_flutter/constants/app_colors.dart';
import 'package:nango_flutter/services/trip_history_service.dart';
import 'package:nango_flutter/views/home_view.dart';
import 'package:nango_flutter/views/quotes1_passenger.dart';
import 'package:nango_flutter/views/reserve_passenger.dart';
import 'package:nango_flutter/views/history_1_passenger.dart';
import 'package:nango_flutter/views/account_view.dart';
import 'package:nango_flutter/views/notifications_nango.dart';

class QuoteCardData {
  final String start;
  final String dest;
  final String driver;
  final double price;
  final DateTime dateTime;
  final int seatsAvailable;
  final String licensePlate;
  final String carBrand;

  QuoteCardData({
    required this.start,
    required this.dest,
    required this.driver,
    required this.price,
    required this.dateTime,
    required this.seatsAvailable,
    required this.licensePlate,
    required this.carBrand,
  });
}

// Converted to StatefulWidget
class Quotes2Passenger extends StatefulWidget {
  final Quotes1Filters filters;

  const Quotes2Passenger({super.key, required this.filters});

  @override
  State<Quotes2Passenger> createState() => _Quotes2PassengerState();
}

class _Quotes2PassengerState extends State<Quotes2Passenger> {
  // Data moved into the state
  final List<QuoteCardData> _allQuotes = [
    QuoteCardData(
      start: 'Plaza Norte, Independencia',
      dest: 'Real Plaza, Centro Cívico',
      driver: 'Juan Perez',
      price: 10.50,
      dateTime: DateTime(2024, 8, 15, 8, 0),
      seatsAvailable: 2,
      licensePlate: 'ABC-123',
      carBrand: 'Toyota Yaris',
    ),
    QuoteCardData(
      start: 'MegaPlaza, Independencia',
      dest: 'Jockey Plaza, Surco',
      driver: 'Maria Rodriguez',
      price: 15.00,
      dateTime: DateTime(2024, 8, 15, 9, 30),
      seatsAvailable: 3,
      licensePlate: 'DEF-456',
      carBrand: 'Hyundai Accent',
    ),
    QuoteCardData(
      start: 'Aeropuerto Jorge Chávez, Callao',
      dest: 'Parque Kennedy, Miraflores',
      driver: 'Carlos Gomez',
      price: 25.00,
      dateTime: DateTime(2024, 8, 16, 14, 0),
      seatsAvailable: 1,
      licensePlate: 'GHI-789',
      carBrand: 'Kia Rio',
    ),
    QuoteCardData(
      start: 'Mall del Sur, SJM',
      dest: 'Plaza San Miguel, San Miguel',
      driver: 'Ana Torres',
      price: 12.00,
      dateTime: DateTime(2024, 8, 17, 18, 0),
      seatsAvailable: 4,
      licensePlate: 'JKL-012',
      carBrand: 'Nissan Versa',
    ),
  ];

  // State variable to hold the filtered list
  late List<QuoteCardData> _filteredQuotes;

  @override
  void initState() {
    super.initState();
    // Apply filters on initialization
    _filteredQuotes = _applyFilters(_allQuotes);
  }

  // Filter logic moved into the state
  List<QuoteCardData> _applyFilters(List<QuoteCardData> quotes) {
    return quotes.where((quote) {
      final startMatch = widget.filters.start.isEmpty ||
          quote.start.toLowerCase().contains(widget.filters.start.toLowerCase());
      final destMatch = widget.filters.dest.isEmpty ||
          quote.dest.toLowerCase().contains(widget.filters.dest.toLowerCase());
      return startMatch && destMatch;
    }).toList();
  }

  // Function to handle navigation and state update
  Future<void> _joinTrip(int index) async {
    final data = _filteredQuotes[index];

    // Create a TripCardData from the QuoteCardData
    final tripData = TripCardData(
      start: data.start,
      dest: data.dest,
      driver: data.driver,
      dateTime: data.dateTime,
      price: data.price.round(), // Convert double to int
      type: 'Student', // Hardcode a type for now
      carBrand: data.carBrand,
      licensePlate: data.licensePlate,
      seatsAvailable: data.seatsAvailable,
    );

    // Navigate to the reserve screen and wait for a result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReservePassengerView(trip: tripData),
      ),
    );

    // If the result is true, it means the trip was reserved successfully
    if (result == true && mounted) {
      setState(() {
        // Remove the trip from the list
        _filteredQuotes.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI now uses the state variable _filteredQuotes
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        foregroundColor: AppColors.secondaryText,
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title: const Text('Quotes', style: TextStyle(fontWeight: FontWeight.w800)),
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
        currentIndex: 1,
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
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredQuotes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          // Pass the data and the handler function to the card
          return _QuoteCard(
            data: _filteredQuotes[index],
            onJoinTrip: () => _joinTrip(index),
          );
        },
      ),
    );
  }
}

// _QuoteCard now accepts an onJoinTrip callback
class _QuoteCard extends StatelessWidget {
  final QuoteCardData data;
  final VoidCallback onJoinTrip;

  const _QuoteCard({required this.data, required this.onJoinTrip});

  @override
  Widget build(BuildContext context) {
    final border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: const BorderSide(color: Colors.black, width: 1),
    );
    return Card(
      elevation: 2,
      shape: border,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/map_placeholder.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.start,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.arrow_forward, size: 20),
                    ),
                    Expanded(
                      child: Text(
                        data.dest,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Drive:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(data.driver),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text('S/.${data.price.toStringAsFixed(2)}'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _rowTitleValue('Departure date', DateFormat('dd/MM/yyyy').format(data.dateTime)),
                _rowTitleValue('Departure Time', DateFormat.jm().format(data.dateTime)),
                _rowTitleValue('Seats available', '${data.seatsAvailable}'),
                _rowTitleValue('License Plate', data.licensePlate),
                _rowTitleValue('Car Brand', data.carBrand),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    // Use the passed callback
                    onPressed: onJoinTrip,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Join Trip'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _rowTitleValue(String title, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            Flexible(
              child: Text(value, textAlign: TextAlign.right),
            ),
          ],
        ),
      );
}
