// lib/services/fake_api.dart
import 'fake_database.dart';
import '../models/trip.dart';
import '../models/vehicle.dart';
import 'api_service.dart';

class FakeAPI {
  // login user
static Future<Map<String, dynamic>?> login(String email, String password) async {
  final response = await ApiService.login(email, password);

  if (response != null && response['status'] == true) {
    return response['user'];
  }

  return null;
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