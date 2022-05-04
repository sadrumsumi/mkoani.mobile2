String parseDate(DateTime date) {
  int month = date.month;
  int day = date.day;
  String m = month.toString();
  String d = day.toString();
  if (month < 10) {
    m = '0' + date.month.toString();
  }
  if (day < 10) {
    d = '0' + date.day.toString();
  }
  return '$d-$m-${date.year}';
}
