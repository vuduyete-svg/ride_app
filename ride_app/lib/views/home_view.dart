import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/location_point.dart';
import '../models/vehicle.dart';
import '../controllers/trip_controller.dart';
import '../services/fake_api.dart';
import '../utils/currency_formatter.dart';
import 'location_picker.dart';
import 'history_view.dart';
import 'login_view.dart';

class HomeView extends StatefulWidget {
  final String username;
  final String fullname;

  const HomeView({Key? key, required this.username, required this.fullname})
      : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  LocationPoint? from;
  LocationPoint? to;

  Vehicle selectedVehicle = Vehicle("Bike", 5000);
  final controller = TripController();

  double distance = 0;
  double price = 0;

  late String username;
  late String fullname;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    username = widget.username;
    fullname = widget.fullname;
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void calculateTrip() {
    if (from == null || to == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Vui lòng chọn điểm đi và điểm đến"),
          backgroundColor: Colors.red[400],
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    var trip = controller.createTrip(from!, to!, selectedVehicle);

    setState(() {
      distance = trip.distance;
      price = trip.price;
    });

    _animationController.forward(from: 0.0);
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
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: value != null ? Color(0xFF10B981) : Colors.grey[200]!,
            width: value != null ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.location_on, color: Color(0xFF10B981), size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    value?.name ?? "Chọn địa điểm",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
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
          margin: EdgeInsets.symmetric(horizontal: 6),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Color(0xFF10B981) : Colors.grey[200]!,
              width: isSelected ? 0 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Color(0xFF10B981).withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                blurRadius: isSelected ? 12 : 6,
                offset: Offset(0, isSelected ? 4 : 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 36, color: isSelected ? Colors.white : Color(0xFF10B981)),
              SizedBox(height: 10),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "${formatCurrency(pricePerKm)} VND/km",
                style: TextStyle(
                  color: isSelected ? Colors.white70 : Colors.grey[600],
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
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
        SnackBar(
          content: Text("Vui lòng chọn điểm đi và điểm đến"),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: EdgeInsets.symmetric(horizontal: 30),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Color(0xFF10B981), size: 44),
              SizedBox(height: 8),
              Text(
                "Xác nhận đặt xe",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Bạn có chắc muốn đặt chuyến này không?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Hủy", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 160,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          var trip = controller.createTrip(from!, to!, selectedVehicle);
                          await FakeAPI.createTrip(trip);
                          setState(() {
                          distance = trip.distance;
                          price = trip.price;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("🚗 Đặt xe thành công!"),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF10B981),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Đồng ý",
                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text("RideApp", style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        backgroundColor: Color(0xFF10B981),
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Icon(Icons.notifications, color: Colors.white),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(20))),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: UserAccountsDrawerHeader(
                accountName: Text(
                  fullname,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                accountEmail: Text(
                  "$username@rideapp.com",
                  style: TextStyle(fontSize: 13),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Color(0xFF10B981)),
                ),
                decoration: BoxDecoration(color: Colors.transparent),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Color(0xFF10B981)),
              title: Text("Trang chủ"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.history, color: Color(0xFF10B981)),
              title: Text("Lịch sử chuyến đi"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HistoryView()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.wallet, color: Color(0xFF10B981)),
              title: Text("Ví thanh toán"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Color(0xFF10B981)),
              title: Text("Cài đặt"),
              onTap: () {},
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 0),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Đăng xuất", style: TextStyle(color: Colors.red)),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER SECTION
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 24, bottom: 32, left: 24, right: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Xin chào, $fullname! 👋",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Bạn muốn đi đâu hôm nay?",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // MAIN CONTENT
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // LOCATION SECTION
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Chọn vị trí",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 16),
                        locationBox("Điểm đi", from, (val) => setState(() => from = val)),
                        locationBox("Điểm đến", to, (val) => setState(() => to = val)),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // VEHICLE SELECTION
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Chọn loại xe",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            vehicleItem("Bike", 5000, Icons.two_wheeler),
                            vehicleItem("Car", 10000, Icons.directions_car),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // CALCULATE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: calculateTrip,
                      icon: Icon(Icons.calculate),
                      label: Text(
                        "Tính giá cước",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // RESULT SECTION
                  if (distance > 0)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF10B981).withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Khoảng cách",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "${distance.toStringAsFixed(2)} km",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Loại xe",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    selectedVehicle.name,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 1,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Tổng cước",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "${formatCurrency(price)} VND",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: confirmBooking,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Color(0xFF10B981),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Xác nhận đặt xe",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}