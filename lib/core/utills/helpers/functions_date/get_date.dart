import 'package:hijri/hijri_calendar.dart';

class GetDate {
  static String getTodayDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  static String getNextDay() {
    final now = DateTime.now().add(const Duration(days: 1));
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  static String getNextNextDay() {
    final now = DateTime.now().add(const Duration(days: 2));
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  static String getNextNext1Day() {
    final now = DateTime.now().add(const Duration(days: 3));
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
  static String getNextNext2Day() {
    final now = DateTime.now().add(const Duration(days: 4));
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
  static String getNextNext3Day() {
    final now = DateTime.now().add(const Duration(days: 5));
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
  static String getNextNext4Day() {
    final now = DateTime.now().add(const Duration(days: 6));
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }


  static String getNextDayDateH() {
    final now = DateTime.now();
    final nextDay = now.add(const Duration(days: 1));
    return '${nextDay.year}-${nextDay.month.toString().padLeft(2, '0')}-${nextDay.day.toString().padLeft(2, '0')}';
  }

  static String getNextNextDayH() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Calculate the day of the week for two days ahead
    DateTime nextNextDay = now.add(Duration(days: 2));
    int nextNextDayOfWeek = nextNextDay.weekday;

    // Convert the next-next day's weekday number to a readable string
    String dayName;
    switch (nextNextDayOfWeek) {
      case DateTime.monday:
        dayName = 'الأثنين';
        break;
      case DateTime.tuesday:
        dayName = 'الثلاثاء';
        break;
      case DateTime.wednesday:
        dayName = 'الأربعاء';
        break;
      case DateTime.thursday:
        dayName = 'الخميس';
        break;
      case DateTime.friday:
        dayName = 'الجمعة';
        break;
      case DateTime.saturday:
        dayName = 'السبت';
        break;
      case DateTime.sunday:
        dayName = 'الأحد';
        break;
      default:
        dayName = 'Unknown';
    }

    return dayName;
  }

  static String getNextNext1DayH() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Calculate the day of the week for two days ahead
    DateTime nextNextDay = now.add(Duration(days: 3));
    int nextNextDayOfWeek = nextNextDay.weekday;

    // Convert the next-next day's weekday number to a readable string
    String dayName;
    switch (nextNextDayOfWeek) {
      case DateTime.monday:
        dayName = 'الأثنين';
        break;
      case DateTime.tuesday:
        dayName = 'الثلاثاء';
        break;
      case DateTime.wednesday:
        dayName = 'الأربعاء';
        break;
      case DateTime.thursday:
        dayName = 'الخميس';
        break;
      case DateTime.friday:
        dayName = 'الجمعة';
        break;
      case DateTime.saturday:
        dayName = 'السبت';
        break;
      case DateTime.sunday:
        dayName = 'الأحد';
        break;
      default:
        dayName = 'Unknown';
    }

    return dayName;
  }
  static String getNextNext2DayH() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Calculate the day of the week for two days ahead
    DateTime nextNextDay = now.add(Duration(days: 4));
    int nextNextDayOfWeek = nextNextDay.weekday;

    // Convert the next-next day's weekday number to a readable string
    String dayName;
    switch (nextNextDayOfWeek) {
      case DateTime.monday:
        dayName = 'الأثنين';
        break;
      case DateTime.tuesday:
        dayName = 'الثلاثاء';
        break;
      case DateTime.wednesday:
        dayName = 'الأربعاء';
        break;
      case DateTime.thursday:
        dayName = 'الخميس';
        break;
      case DateTime.friday:
        dayName = 'الجمعة';
        break;
      case DateTime.saturday:
        dayName = 'السبت';
        break;
      case DateTime.sunday:
        dayName = 'الأحد';
        break;
      default:
        dayName = 'Unknown';
    }

    return dayName;
  }
  static String getNextNext3DayH() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Calculate the day of the week for two days ahead
    DateTime nextNextDay = now.add(Duration(days: 5));
    int nextNextDayOfWeek = nextNextDay.weekday;

    // Convert the next-next day's weekday number to a readable string
    String dayName;
    switch (nextNextDayOfWeek) {
      case DateTime.monday:
        dayName = 'الأثنين';
        break;
      case DateTime.tuesday:
        dayName = 'الثلاثاء';
        break;
      case DateTime.wednesday:
        dayName = 'الأربعاء';
        break;
      case DateTime.thursday:
        dayName = 'الخميس';
        break;
      case DateTime.friday:
        dayName = 'الجمعة';
        break;
      case DateTime.saturday:
        dayName = 'السبت';
        break;
      case DateTime.sunday:
        dayName = 'الأحد';
        break;
      default:
        dayName = 'Unknown';
    }

    return dayName;
  }
  static String getNextNext4DayH() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Calculate the day of the week for two days ahead
    DateTime nextNextDay = now.add(Duration(days: 6));
    int nextNextDayOfWeek = nextNextDay.weekday;

    // Convert the next-next day's weekday number to a readable string
    String dayName;
    switch (nextNextDayOfWeek) {
      case DateTime.monday:
        dayName = 'الأثنين';
        break;
      case DateTime.tuesday:
        dayName = 'الثلاثاء';
        break;
      case DateTime.wednesday:
        dayName = 'الأربعاء';
        break;
      case DateTime.thursday:
        dayName = 'الخميس';
        break;
      case DateTime.friday:
        dayName = 'الجمعة';
        break;
      case DateTime.saturday:
        dayName = 'السبت';
        break;
      case DateTime.sunday:
        dayName = 'الأحد';
        break;
      default:
        dayName = 'Unknown';
    }

    return dayName;
  }

  static String getNextDayH() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Get the day of the week as an integer (1 = Monday, 2 = Tuesday, ..., 7 = Sunday)
    int dayOfWeek = now.weekday;

    // Calculate the next day's weekday number (with wrap-around to the beginning of the week)
    int nextDayOfWeek = (dayOfWeek % 7) + 1;

    // Convert the next day's weekday number to a readable string
    String dayName;
    switch (nextDayOfWeek) {
      case 1:
        dayName = 'الأثنين';
        break;
      case 2:
        dayName = 'الثلاثاء';
        break;
      case 3:
        dayName = 'الأربعاء';
        break;
      case 4:
        dayName = 'الخميس';
        break;
      case 5:
        dayName = 'الجمعة';
        break;
      case 6:
        dayName = 'السبت';
        break;
      case 7:
        dayName = 'الأحد';
        break;
      default:
        dayName = 'Unknown';
    }

    return dayName;
  }

  static String getDayH(){
    // Get the current date and time
    DateTime now = DateTime.now();

    // Get the day of the week as an integer (0 = Monday, 1 = Tuesday, ..., 6 = Sunday)
    int dayOfWeek = now.weekday;

    // Convert the day of the week integer to a readable string
    String dayName;
    switch (dayOfWeek) {
      case DateTime.monday:
        dayName = 'الأثنين';
        break;
      case DateTime.tuesday:
        dayName = 'الثلاثاء';
        break;
      case DateTime.wednesday:
        dayName = 'الأربعاء';
        break;
      case DateTime.thursday:
        dayName = 'الخميس';
        break;
      case DateTime.friday:
        dayName = 'الجمعة';
        break;
      case DateTime.saturday:
        dayName = 'السبت';
        break;
      case DateTime.sunday:
        dayName = 'الأحد';
        break;
      default:
        dayName = 'Unknown';
    }

    return dayName;
  }

  static String getMonthH(){
    // Get the current Gregorian date
    DateTime now = DateTime.now();

    // Convert the Gregorian date to Hijri date
    HijriCalendar hijriDate = HijriCalendar.fromDate(now);

    // Get the current month in Hijri
    int hijriMonth = hijriDate.hMonth;
    String hijriMonthName;

    // Map Hijri month number to month name
    switch (hijriMonth) {
      case 1:
        hijriMonthName = 'مُحرَّم';
        break;
      case 2:
        hijriMonthName = 'صفر';
        break;
      case 3:
        hijriMonthName = 'ربيع الأول';
        break;
      case 4:
        hijriMonthName = 'ربيع الآخر';
        break;
      case 5:
        hijriMonthName = 'جمادى الأولى';
        break;
      case 6:
        hijriMonthName = 'جمادى الآخرة';
        break;
      case 7:
        hijriMonthName = 'رجب';
        break;
      case 8:
        hijriMonthName = 'شعبان';
        break;
      case 9:
        hijriMonthName = 'رمضان';
        break;
      case 10:
        hijriMonthName = 'شوّال';
        break;
      case 11:
        hijriMonthName = 'ذو القعدة';
        break;
      case 12:
        hijriMonthName = 'ذو الحجة';
        break;
      default:
        hijriMonthName = 'غير معروف';
    }

    // Print the current Hijri month
    return hijriMonthName;
  }

  static String getYearH(){
    // Get the current Gregorian date
    DateTime now = DateTime.now();

    // Convert the Gregorian date to Hijri date
    HijriCalendar hijriDate = HijriCalendar.fromDate(now);

    int hijriYear = hijriDate.hYear;
    // Print the current Hijri month
    return hijriYear.toString();
  }

}
