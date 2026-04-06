// lib/services/fake_api.dart
import 'fake_database.dart';
import '../models/trip.dart';
import '../models/vehicle.dart';

class FakeAPI {
  // login user
  static Future<bool> login(String username, String password) async {
    await Future.delayed(Duration(milliseconds: 500)); // fake delay
    return FakeDatabase.users.any((u) =>
        u['username'] == username && u['password'] == password);
  }

  // lấy danh sách xe
  static List<Vehicle> getVehicles() => FakeDatabase.vehicles;

  // lấy lịch sử chuyến đi
  static Future<List<Trip>> getTrips() async {
    await Future.delayed(Duration(milliseconds: 500));
    return List.from(FakeDatabase.trips.reversed);
  }

  // tạo chuyến đi mới, nhận Trip object trực tiếp
  static Future<void> createTrip(Trip trip) async {
    await Future.delayed(Duration(milliseconds: 500));
    FakeDatabase.trips.add(trip);
  }
}