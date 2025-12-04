
import 'package:flutter/material.dart';

// Data class for trip information
class TripCardData {
  final String start, dest, driver, type;
  final DateTime dateTime;
  final int price;
  final String carBrand;
  final String licensePlate;
  final int seatsAvailable;

  TripCardData({
    required this.start,
    required this.dest,
    required this.driver,
    required this.dateTime,
    required this.price,
    this.type = 'Student', // Default value
    required this.carBrand,
    required this.licensePlate,
    required this.seatsAvailable,
  });
}

// Service to manage trip history
class TripHistoryService {
  // Singleton pattern to ensure only one instance of the service
  static final TripHistoryService _instance = TripHistoryService._internal();
  factory TripHistoryService() {
    return _instance;
  }
  TripHistoryService._internal();

  final List<TripCardData> _trips = [
    // Pre-populating with initial data from history_2_passenger
    TripCardData(
      start: 'Mercado Unicachi, Los Olivos',
      dest: 'Universidad Nacional de Ingeniería (UNI), Rímac',
      driver: 'Junior Castillo',
      dateTime: DateTime(2025, 5, 24, 13, 30),
      price: 6,
      type: 'Student',
      carBrand: 'Toyota Yaris',
      licensePlate: 'ABC-123',
      seatsAvailable: 2,
    ),
    TripCardData(
      start: 'Mercado Unicachi, Los Olivos',
      dest: 'Universidad Nacional de Ingeniería (UNI), Rímac',
      driver: 'Luciana Contreras',
      dateTime: DateTime(2025, 5, 24, 13, 30),
      price: 18,
      type: 'Family',
      carBrand: 'Hyundai Accent',
      licensePlate: 'DEF-456',
      seatsAvailable: 3,
    ),
  ];

  // Getter to access the list of trips
  List<TripCardData> get trips => _trips;

  // Method to add a new trip to the history
  void addTrip(TripCardData trip) {
    _trips.add(trip);
  }
}
