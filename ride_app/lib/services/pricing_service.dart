import '../models/vehicle.dart';

class PricingService {
  static double calculate(double distance, Vehicle vehicle) {
    const baseFare = 10000;
    return baseFare + (distance * vehicle.pricePerKm);
  }
}