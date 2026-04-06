import '../models/trip.dart';

class TripStorage {
  static List<Trip> trips = [];

  static void addTrip(Trip trip) {
    trips.add(trip);
  }

  static List<Trip> getTrips() {
    return trips;
  }

  static double totalMoney() {
    return trips.fold(0, (sum, t) => sum + t.price);
  }
}