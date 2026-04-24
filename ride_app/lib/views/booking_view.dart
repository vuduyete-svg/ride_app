import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/trip.dart';
import '../services/fake_api.dart';
import '../services/fake_database.dart';
import '../utils/currency_formatter.dart';

class BookingView extends StatefulWidget {
  final Trip trip;

  const BookingView({Key? key, required this.trip}) : super(key: key);

  @override
  _BookingViewState createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  String selectedPayment = "Tiền mặt";

  final List<Map<String, dynamic>> paymentMethods = [
    {"name": "Tiền mặt", "icon": Icons.payments, "color": Colors.green},
    {"name": "Ví RidePay", "icon": Icons.account_balance_wallet, "color": Colors.blue},
    {"name": "Thẻ Visa/Master", "icon": Icons.credit_card, "color": Colors.orange},
  ];

  void processBooking() async {
    // Nếu chọn Ví RidePay, kiểm tra số dư
    if (selectedPayment == "Ví RidePay") {
      if (FakeDatabase.walletBalance < widget.trip.price) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Số dư không đủ"),
            content: Text("Số dư ví RidePay của bạn không đủ để thực hiện chuyến đi này. Vui lòng nạp thêm tiền hoặc chọn phương thức khác."),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text("Đóng")),
            ],
          ),
        );
        return;
      }
    }

    // Hiển thị loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator(color: Color(0xFF10B981))),
    );

    // Giả lập xử lý thanh toán
    await Future.delayed(Duration(seconds: 1));

    // Thực hiện trừ tiền nếu là ví
    if (selectedPayment == "Ví RidePay") {
      FakeDatabase.walletBalance -= widget.trip.price;
    }

    // Tạo bản sao trip với phương thức thanh toán đã chọn
    final finalTrip = widget.trip.copyWith(
      paymentMethod: selectedPayment,
      status: "Completed",
    );

    // Giả lập gọi API lưu lịch sử
    await FakeAPI.createTrip(finalTrip);

    // Đóng loading
    Navigator.pop(context);

    // Hiển thị thành công và quay về Home
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF10B981).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle, color: Color(0xFF10B981), size: 64),
            ),
            SizedBox(height: 24),
            Text(
              "Đặt xe thành công!",
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              selectedPayment == "Ví RidePay" 
                ? "Đã thanh toán bằng ví RidePay." 
                : "Vui lòng thanh toán bằng tiền mặt cho tài xế.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Đóng bottom sheet
                  Navigator.pop(context, true); // Quay về Home với kết quả thành công
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF10B981),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Tuyệt vời", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text("Thanh toán", style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tóm tắt chuyến đi
            Text("Tóm tắt chuyến đi", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  _infoRow(Icons.my_location, "Từ:", widget.trip.from),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(indent: 30),
                  ),
                  _infoRow(Icons.location_on, "Đến:", widget.trip.to),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Loại xe: ${widget.trip.vehicle.name}", style: TextStyle(fontWeight: FontWeight.w500)),
                      Text("${widget.trip.distance.toStringAsFixed(1)} km", style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Chọn phương thức thanh toán
            Text("Chọn phương thức thanh toán", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
            SizedBox(height: 16),
            ...paymentMethods.map((method) => _paymentItem(method)).toList(),

            SizedBox(height: 32),

            // Tổng tiền & Nút xác nhận
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFF10B981).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tổng thanh toán", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                      Text(
                        "${formatCurrency(widget.trip.price)} VND",
                        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF10B981)),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: processBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF10B981),
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 4,
                        shadowColor: Color(0xFF10B981).withOpacity(0.4),
                      ),
                      child: Text(
                        "XÁC NHẬN & THANH TOÁN",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
                      ),
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

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Color(0xFF10B981)),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _paymentItem(Map<String, dynamic> method) {
    bool isSelected = selectedPayment == method["name"];
    bool isWallet = method["name"] == "Ví RidePay";
    
    return GestureDetector(
      onTap: () => setState(() => selectedPayment = method["name"]),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Color(0xFF10B981) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? Color(0xFF10B981).withOpacity(0.1) : Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: method["color"].withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(method["icon"], color: method["color"]),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method["name"],
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  if (isWallet)
                    Text(
                      "Số dư: ${formatCurrency(FakeDatabase.walletBalance)} VND",
                      style: TextStyle(fontSize: 11, color: FakeDatabase.walletBalance < widget.trip.price ? Colors.red : Colors.grey[600]),
                    ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Color(0xFF10B981))
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
