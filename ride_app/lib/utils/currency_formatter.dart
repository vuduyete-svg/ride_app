// Format tiền với dấu phẩy
String formatCurrency(double amount) {
  return amount.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (Match m) => ',',
  );
}
