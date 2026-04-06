import 'package:flutter/material.dart';
import '../services/fake_api.dart';
import '../services/trip_storage.dart';
import '../models/trip.dart';

class HistoryView extends StatefulWidget {
  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  List<Trip> trips = [];

  @override
  void initState() {
    super.initState();
    loadTrips();
  }

  void loadTrips() async {
    var data = await FakeAPI.getTrips();
    setState(() {
      trips = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalTrips = trips.length;
    double totalMoney = trips.fold(0, (sum, t) => sum + t.price);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Lịch sử"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: trips.isEmpty
          ? Center(
              child: Text(
                "Chưa có chuyến nào",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView(
              padding: EdgeInsets.all(16),
              children: [
                // ⭐ Thống kê gộp Dashboard
                Row(
                  children: [
                    statisticCard("Số chuyến", "$totalTrips", Icons.directions_car, Colors.green),
                    statisticCard("Tổng tiền", "${totalMoney.toStringAsFixed(0)} VND", Icons.money, Colors.orange),
                  ],
                ),
                SizedBox(height: 16),

                // ⭐ Danh sách chuyến đi
                ...trips.map((t) => tripCard(t)).toList(),
              ],
            ),
    );
  }

  Widget statisticCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            SizedBox(height: 10),
            Text(title, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
            SizedBox(height: 4),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget tripCard(Trip t) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: Colors.green.withOpacity(0.2),
          child: Icon(
            t.vehicle.name.toLowerCase() == "bike" ? Icons.motorcycle : Icons.directions_car,
            color: Colors.green,
          ),
        ),
        title: Text("${t.from} → ${t.to}", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(t.vehicle.name, style: TextStyle(color: Colors.grey[700])),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${t.price.toStringAsFixed(0)} VND", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text("${t.distance.toStringAsFixed(2)} km", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}