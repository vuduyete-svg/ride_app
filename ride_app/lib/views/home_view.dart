import 'package:flutter/material.dart';
import '../models/location_point.dart';
import '../models/vehicle.dart';
import '../controllers/trip_controller.dart';
import '../services/fake_api.dart';

import 'location_picker.dart';
import 'dashboard_view.dart';
import 'history_view.dart';
import 'login_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  LocationPoint? from;
  LocationPoint? to;

  Vehicle selectedVehicle = Vehicle("Bike", 5000);
  final controller = TripController();

  double distance = 0;
  double price = 0;

  String username = "User";

  void calculateTrip() {
    if (from == null || to == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng chọn điểm đi và điểm đến")),
      );
      return;
    }

    var trip = controller.createTrip(from!, to!, selectedVehicle);

    setState(() {
      distance = trip.distance;
      price = trip.price;
    });
  }

  Widget locationBox(String title, LocationPoint? value, Function(LocationPoint) onTap) {
    return GestureDetector(
      onTap: () async {
        var result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LocationPicker()),
        );

        if (result != null) onTap(result);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.location_on, color: Colors.green),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                value?.name ?? title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget vehicleItem(String name, double pricePerKm, IconData icon) {
    bool isSelected = selectedVehicle.name == name;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedVehicle = Vehicle(name, pricePerKm);
            calculateTrip();
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? Colors.green : Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: isSelected ? Colors.white : Colors.green),
              SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "${pricePerKm.toStringAsFixed(0)} VND/km",
                style: TextStyle(
                  color: isSelected ? Colors.white70 : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void confirmBooking() {
    if (from == null || to == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng chọn điểm đi và điểm đến")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Xác nhận đặt xe"),
        content: Text("Bạn có chắc muốn đặt chuyến này không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Hủy"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              var trip = controller.createTrip(from!, to!, selectedVehicle);
              await FakeAPI.createTrip(trip);
              setState(() {
                distance = trip.distance;
                price = trip.price;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Đặt xe thành công!")),
              );
            },
            child: Text("Đồng ý"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Ride App"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(username),
              accountEmail: Text("$username@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40),
              ),
              decoration: BoxDecoration(color: Colors.green),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Trang chủ"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text("Dashboard"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DashboardView()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text("Lịch sử"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HistoryView()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Đăng xuất"),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginView()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 40, bottom: 24, left: 24, right: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.greenAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
              ],
            ),
            child: Text(
              "Bạn muốn đi đâu?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // LOCATION PICKER
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              children: [
                locationBox("Chọn điểm đi", from, (val) => setState(() => from = val)),
                locationBox("Chọn điểm đến", to, (val) => setState(() => to = val)),
              ],
            ),
          ),

          // VEHICLE SELECTION
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                vehicleItem("Bike", 5000, Icons.motorcycle),
                vehicleItem("Car", 10000, Icons.directions_car),
              ],
            ),
          ),

          Spacer(),

          // RESULT BOTTOM CARD
          if (distance > 0)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Khoảng cách: ${distance.toStringAsFixed(2)} km",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 6),
                  Text(
                    "${price.toStringAsFixed(0)} VND",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: confirmBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Xác nhận đặt xe",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}