import 'package:flutter/material.dart';
import '../services/trip_storage.dart';

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int totalTrips = TripStorage.getTrips().length;
    double totalMoney = TripStorage.totalMoney();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                dashboardCard("Số chuyến", "$totalTrips", Icons.directions_car, Colors.green),
                dashboardCard("Tổng tiền", "${totalMoney.toStringAsFixed(0)}", Icons.money, Colors.orange),
              ],
            ),
            SizedBox(height: 20),
            // Bạn có thể thêm card khác ở đây, ví dụ số chuyến Bike / Car, trung bình/km...
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}