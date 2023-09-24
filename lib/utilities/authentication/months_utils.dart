class MonthsUtils {
  static const List<String> _monthNames = [
    "", // Placeholder for index 0
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  static String getMonthName(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }
    return _monthNames[month];
  }
}
