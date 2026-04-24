// lib/services/fake_database.dart
import '../models/trip.dart';
import '../models/vehicle.dart';

class FakeDatabase {
  // Số dư ví giả lập
  static double walletBalance = 10000; // Mặc định có 500k

  // Người dùng (login)
  static final List<Map<String, String>> users = [
  {"username": "1", "password": "1", "fullname": "Vũ Duyệt"},
  {"username": "2", "password": "1", "fullname": "Đào Diệu Đạt"},
  {"username": "3", "password": "1", "fullname": "Phan Anh"},
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