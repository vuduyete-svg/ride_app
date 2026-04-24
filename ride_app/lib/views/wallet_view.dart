import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/fake_database.dart';
import '../utils/currency_formatter.dart';

class WalletView extends StatefulWidget {
  @override
  _WalletViewState createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  double balance = FakeDatabase.walletBalance;

  void topUp() {
    showDialog(
      context: context,
      builder: (context) {
        double amount = 0;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Nạp tiền vào ví", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Số tiền (VND)",
                  hintText: "Ví dụ: 100000",
                  prefixIcon: Icon(Icons.add_card, color: Color(0xFF10B981)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (value) => amount = double.tryParse(value) ?? 0,
              ),
              SizedBox(height: 16),
              Text(
                "Tiền sẽ được cộng trực tiếp vào ví RidePay của bạn.",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Hủy", style: TextStyle(color: Colors.grey))),
            ElevatedButton(
              onPressed: () {
                if (amount > 0) {
                  setState(() {
                    FakeDatabase.walletBalance += amount;
                    balance = FakeDatabase.walletBalance;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Nạp tiền thành công!"), backgroundColor: Color(0xFF10B981)),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF10B981),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Xác nhận", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text("Ví RidePay", style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // CARD BALANCE
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF10B981).withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Số dư khả dụng", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                    Icon(Icons.contactless_outlined, color: Colors.white70),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  "${formatCurrency(balance)} VND",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("RIDE PASS", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    Text("**** **** **** 8888", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),

          // QUICK ACTIONS
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _actionButton(Icons.add_circle_outline, "Nạp tiền", topUp),
                SizedBox(width: 16),
                _actionButton(Icons.history, "Giao dịch", () {}),
                SizedBox(width: 16),
                _actionButton(Icons.security, "Bảo mật", () {}),
              ],
            ),
          ),

          SizedBox(height: 32),

          // RECENT TRANSACTIONS (MOCK)
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 24, left: 24, right: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Giao dịch gần đây", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        _transactionItem("Chuyến đi đến Hồ Gươm", "- 45,000 VND", "Hôm nay, 10:30", Colors.red),
                        _transactionItem("Nạp tiền từ ngân hàng", "+ 200,000 VND", "Hôm qua, 15:20", Colors.green),
                        _transactionItem("Chuyến đi đến Sân bay", "- 250,000 VND", "20 Th10, 08:00", Colors.red),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Icon(icon, color: Color(0xFF10B981)),
              SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _transactionItem(String title, String amount, String date, Color amountColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: amountColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              amountColor == Colors.green ? Icons.arrow_downward : Icons.arrow_upward,
              color: amountColor,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
                Text(date, style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Text(amount, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: amountColor)),
        ],
      ),
    );
  }
}
