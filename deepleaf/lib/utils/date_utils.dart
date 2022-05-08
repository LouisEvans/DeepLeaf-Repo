class MyDateUtils {
  // Parse date to readable format
  static String parseDate(String date) {
    DateTime? d = DateTime.tryParse(date);

    String returnedDate = "";

    if (d != null) {
      String zero1 = "";
      String zero2 = "";
      if (d.hour < 10) {
        zero1 = "0";
      }
      if (d.minute < 10) {
        zero2 = "0";
      }
      returnedDate = d.day.toString() +
          "-" +
          d.month.toString() +
          "-" +
          d.year.toString() +
          ", " +
          zero1 +
          d.hour.toString() +
          ":" +
          zero2 +
          d.minute.toString();
    }
    return returnedDate;
  }
}
