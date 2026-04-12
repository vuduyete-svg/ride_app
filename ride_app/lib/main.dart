import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';

void main() {
  runApp(MyApp());
}

class AppTheme {
  static const primaryColor = Color(0xFF10B981);
  static const secondaryColor = Color(0xFF06B6D4);
  static const tertiaryColor = Color(0xFFF59E0B);
  static const backgroundColor = Color(0xFFF8FAFC);
  static const surfaceColor = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        surface: surfaceColor,
        background: backgroundColor,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  // Kiểm tra trạng thái login
  Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  // Lấy username và fullname từ SharedPreferences
  Future<Map<String, String>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username") ?? "User";
    String fullname = prefs.getString("fullname") ?? "Người dùng";
    return {"username": username, "fullname": fullname};
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: FutureBuilder<bool>(
        future: checkLogin(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // Chờ load dữ liệu
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data!) {
            // Nếu đã login, lấy thông tin user
            return FutureBuilder<Map<String, String>>(
              future: getUserInfo(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                final user = userSnapshot.data!;
                return HomeView(
                  username: user["username"]!,
                  fullname: user["fullname"]!,
                );
              },
            );
          } else {
            // Nếu chưa login
            return LoginView();
          }
        },
      ),
    );
  }
}