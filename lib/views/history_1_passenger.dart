import 'package:flutter/material.dart';
import 'package:nango_flutter/views/history_2_passenger.dart';
import 'package:nango_flutter/views/home_view.dart';
import 'package:nango_flutter/constants/app_colors.dart';


class HistoryFilters {
  final String month;
  final String expense;
  final String tripType;
  const HistoryFilters({
    required this.month,
    required this.expense,
    required this.tripType});
}

class History1Passenger extends StatefulWidget {
  const History1Passenger({super.key});

  @override
  State<History1Passenger> createState() => _History1PassengerState();
}

class _History1PassengerState extends State<History1Passenger> {
  final _months   = const ['All','January','February','March','April','May','June','July','August','September','October','November','December'];
  final _expenses = const ['All','S/.20','S/.15','S/.25'];
  final _types    = const ['All','Student','Family'];

  String _selMonth   = 'All';
  String _selExpense = 'All';
  String _selType    = 'All';

  InputDecoration _decoration({String? hint, Widget? prefix, Widget? suffix}) {
    const radius = BorderRadius.all(Radius.circular(10));
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      prefixIcon: prefix,
      suffixIcon: suffix,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        foregroundColor: AppColors.secondaryText,
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title: Text('History',style: TextStyle(fontWeight: FontWeight.w800)),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: const [
          Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.notifications_none, color: Colors.black87)),
          Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.account_circle_outlined, color: Colors.black87)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // history
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
          label: 'history',)
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _label('Month'),
            DropdownButtonFormField<String>(
              initialValue: _selMonth,
              items: _months.map((m)=>DropdownMenuItem(value:m, child: Text(m))).toList(),
              onChanged: (v)=>setState(()=>_selMonth=v!),
              decoration: _decoration(),
            ),
            const SizedBox(height: 12),

            _label('Expenses'),
            DropdownButtonFormField<String>(
              initialValue: _selExpense,
              items: _expenses.map((e)=>DropdownMenuItem(value:e, child: Text(e))).toList(),
              onChanged: (v)=>setState(()=>_selExpense=v!),
              decoration: _decoration(),
            ),
            const SizedBox(height: 12),

            _label('Type of trip'),
            DropdownButtonFormField<String>(
              initialValue: _selType,
              items: _types.map((t)=>DropdownMenuItem(value:t, child: Text(t))).toList(),
              onChanged: (v)=>setState(()=>_selType=v!),
              decoration: _decoration(),
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
                  final f = HistoryFilters(month: _selMonth, expense: _selExpense, tripType: _selType);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => History2Passenger(filters: f)));
                },
                child: const Text('Generate'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
  );
}

