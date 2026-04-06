// lib/services/fake_database.dart
import '../models/trip.dart';
import '../models/vehicle.dart';

class FakeDatabase {
  // Người dùng (login)
  static final List<Map<String, String>> users = [
    {"username": "vuduyet", "password": "1"},
    {"username": "daodat", "password": "1"},
    {"username": "phananh", "password": "1"},
  ];

  // Xe có sẵn
  static final List<Vehicle> vehicles = [
    Vehicle("Bike", 5000),
    Vehicle("Car", 10000),
    Vehicle("SUV", 15000),
  ];

  // Chuyến đi mẫu
  static final List<Trip> trips = [
    Trip(from: "Hà Nội", to: "Hải Phòng", vehicle: Vehicle("Car", 10000), distance: 120, price: 1200000),
    Trip(from: "Hà Nội", to: "Nam Định", vehicle: Vehicle("Bike", 5000), distance: 90, price: 450000),
    Trip(from: "Hà Nội", to: "Thái Bình", vehicle: Vehicle("SUV", 15000), distance: 150, price: 2250000),
  ];
}