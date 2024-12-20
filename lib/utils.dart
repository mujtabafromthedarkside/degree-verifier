import 'package:intl/intl.dart';

String convertUni(String uni) {
  if (uni == "GIKI") return "Ghulam Ishaq Khan Institute of Engineering Sciences and Technology";
  return uni;
}

String convertDegreeType(String degree) {
  if (degree == "BS") return "Bachelor of Science";
  if (degree == "BA") return "Bachelor of Arts";
  if (degree == "MS") return "Master of Science";
  if (degree == "MA") return "Master of Arts";
  if (degree == "PhD") return "Doctor of Philosophy";
  return degree;
}

String convertMajor(String major) {
  if (major == "CS") return "Computer Science";
  if (major == "EE") return "Electrical Engineering";
  if (major == "ME") return "Mechanical Engineering";
  if (major == "CVE") return "Civil Engineering";
  if (major == "CME") return "Chemical Engineering";
  if (major == "CE") return "Computer Engineering";
  if (major == "SE") return "Software Engineering";
  if (major == "AI") return "Artificial Intelligence";
  if (major == "DS") return "Data Science";
  if (major == "CYS") return "Cyber Security";
  if (major == "ES") return "Engineering Sciences";
  if (major == "MGS") return "Management Sciences";
  return major;
}

String convertDateToFullText(String date) {
  // Ensure the input is valid (length = 6)
  if (date.length != 6) {
    throw FormatException("Invalid date format. Expected DDMMYY.");
  }

  // Extract DD, MM, YY from the input
  int day = int.parse(date.substring(0, 2));
  int month = int.parse(date.substring(2, 4));
  int year = int.parse(date.substring(4, 6));

  // Convert YY to YYYY (assuming 2000s for simplicity)
  year += (year >= 0 && year <= 99) ? 2000 : 1900;

  // Create a DateTime object
  DateTime parsedDate = DateTime(year, month, day);

  // Convert the day to words
  String dayInWords = _convertDayToWords(day);

  // Convert the year to words
  String yearInWords = _convertYearToWords(year);

  // Get the month name
  String monthName = DateFormat('MMMM').format(parsedDate);

  // Format the final result
  return "$monthName $dayInWords, Year $yearInWords";
}

// Helper function to convert the day to words
String _convertDayToWords(int day) {
  List<String> dayWords = [
    "Zero",
    "First",
    "Second",
    "Third",
    "Fourth",
    "Fifth",
    "Sixth",
    "Seventh",
    "Eighth",
    "Ninth",
    "Tenth",
    "Eleventh",
    "Twelfth",
    "Thirteenth",
    "Fourteenth",
    "Fifteenth",
    "Sixteenth",
    "Seventeenth",
    "Eighteenth",
    "Nineteenth",
    "Twentieth",
    "Twenty First",
    "Twenty Second",
    "Twenty Third",
    "Twenty Fourth",
    "Twenty Fifth",
    "Twenty Sixth",
    "Twenty Seventh",
    "Twenty Eighth",
    "Twenty Ninth",
    "Thirtieth",
    "Thirty First"
  ];
  return dayWords[day];
}

// Helper function to convert the year to words
String _convertYearToWords(int year) {
  // Split the year into two parts

  if (year < 2000) {
    int firstPart = year ~/ 100; // e.g., 20 from 2023
    int secondPart = year % 100; // e.g., 23 from 2023

    String firstPartInWords = _convertNumberToWords(firstPart);
    String secondPartInWords = _convertNumberToWords(secondPart);

    return "$firstPartInWords Hundred $secondPartInWords";
  } else {
    int firstPart = year ~/ 1000; // e.g., 20 from 2023
    int secondPart = year % 1000; // e.g., 23 from 2023

    String firstPartInWords = _convertNumberToWords(firstPart);
    String secondPartInWords = _convertNumberToWords(secondPart);

    return "$firstPartInWords Thousand $secondPartInWords";
  }
}

// Generic helper to convert numbers to words (1-99)
String _convertNumberToWords(int number) {
  List<String> belowTwenty = [
    "Zero",
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "Nine",
    "Ten",
    "Eleven",
    "Twelve",
    "Thirteen",
    "Fourteen",
    "Fifteen",
    "Sixteen",
    "Seventeen",
    "Eighteen",
    "Nineteen"
  ];
  List<String> tens = ["", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"];

  if (number < 20) {
    return belowTwenty[number];
  } else {
    int tenPart = number ~/ 10;
    int unitPart = number % 10;

    if (unitPart == 0) {
      return tens[tenPart];
    } else {
      return "${tens[tenPart]} ${belowTwenty[unitPart]}";
    }
  }
}
