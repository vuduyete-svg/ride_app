import '../models/location_point.dart';
import '../models/vehicle.dart';
import '../models/trip.dart';
import '../services/distance_service.dart';
import '../services/pricing_service.dart';

class TripController {
  Trip createTrip(LocationPoint from, LocationPoint to, Vehicle vehicle) {
    // tính khoảng cách
    double distance = DistanceService.calculate(from.lat, from.lng, to.lat, to.lng);

    // tính giá
    double price = PricingService.calculate(distance, vehicle);

    // tạo Trip
    Trip trip = Trip(
      from: from.name,      
      to: to.name,          
      distance: distance,
      price: price,
      vehicle: vehicle,
    );

    return trip;
  }
}