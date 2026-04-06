import 'vehicle.dart';

class Trip {
  final String from;     // điểm đi
  final String to;       // điểm đến
  final double distance; // km
  final double price;    // giá VND
  final Vehicle vehicle; // xe sử dụng

  Trip({
    required this.from,
    required this.to,
    required this.distance,
    required this.price,
    required this.vehicle,
  });
}