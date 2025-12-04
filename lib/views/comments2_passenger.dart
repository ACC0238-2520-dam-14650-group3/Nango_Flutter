import 'package:flutter/material.dart';
import 'package:nango_flutter/constants/app_colors.dart';
import 'package:nango_flutter/services/trip_history_service.dart';
import 'package:nango_flutter/views/home_view.dart';
import 'package:nango_flutter/views/notifications_nango.dart';

class Comments2PassengerView extends StatefulWidget {
  final TripCardData trip;
  const Comments2PassengerView({super.key, required this.trip});

  @override
  State<Comments2PassengerView> createState() =>
      _Comments2PassengerViewState();
}

class _Comments2PassengerViewState extends State<Comments2PassengerView> {
  final _controller = TextEditingController();
  String _ratingFilter = 'All';

  final _ratings = const ['All', '5 stars', '4+ stars', '3+ stars'];

  // comentarios
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Ana Ríos',
      'rating': 5,
      'text':
      'Very punctual and friendly, the trip was super comfortable. Thanks for the great service.'
    },
    {
      'name': 'Rosario Rojas',
      'rating': 4,
      'text': 'Rich text editor.' // como tu mockup
    },
  ];

  @override
  Widget build(BuildContext context) {
    final t = widget.trip;

    final filtered = _reviews.where((r) {
      if (_ratingFilter == 'All') return true;
      if (_ratingFilter == '5 stars') return r['rating'] == 5;
      if (_ratingFilter == '4+ stars') return (r['rating'] as int) >= 4;
      if (_ratingFilter == '3+ stars') return (r['rating'] as int) >= 3;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        foregroundColor: AppColors.secondaryText,
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title:
        const Text('Comments', style: TextStyle(fontWeight: FontWeight.w700)),
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
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.account_circle_outlined, color: Colors.black87),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.backgroundLight,
        currentIndex: 2,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.black54,
        onTap: (i) {
          if (i == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeView()),
                  (r) => false,
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.request_quote_outlined), label: 'quotes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'history'),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // header y estrellas
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
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
                        const Text('Rating',
                            style:
                            TextStyle(color: Colors.black54, fontSize: 13)),
                        Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            Icon(Icons.star_half,
                                color: Colors.amber, size: 18),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: DropdownButtonFormField<String>(
                      initialValue: _ratingFilter,
                      isDense: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      items: _ratings
                          .map((r) =>
                          DropdownMenuItem(value: r, child: Text(r)))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _ratingFilter = v ?? 'All'),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: const [
                  Text('23 reviews',
                      style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                  SizedBox(width: 8),
                  Text('5 completed trips',
                      style: TextStyle(color: Colors.black54, fontSize: 13)),
                ],
              ),
            ),

            const Divider(height: 1),

            // Lista comentarios
            Expanded(
              child: ListView.builder(
                padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final r = filtered[i];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(r['name'] as String,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              Row(
                                children: List.generate(
                                  5,
                                      (idx) => Icon(
                                    idx < (r['rating'] as int)
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            r['text'] as String,
                            style: const TextStyle(fontSize: 13.5),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // comentar c.c
            Container(
              padding:
              const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(0, 0, 0, 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border:
                      Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.format_bold, size: 18),
                            SizedBox(width: 8),
                            Icon(Icons.format_italic, size: 18),
                            SizedBox(width: 8),
                            Icon(Icons.format_list_bulleted, size: 18),
                            SizedBox(width: 8),
                            Icon(Icons.format_list_numbered, size: 18),
                          ],
                        ),
                        TextField(
                          controller: _controller,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'Write a comment...',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                      ),
                      onPressed: () {
                        if (_controller.text.trim().isEmpty) return;
                        // Aquí luego se va al backend; ahora solo limpiamos owO
                        _controller.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Comment sent')),
                        );
                      },
                      icon: const Icon(Icons.send, size: 18),
                      label: const Text('Send'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
