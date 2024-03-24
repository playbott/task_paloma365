const currentOrderIdStorageKey = 'currentOrderId';

String dateFormat(DateTime dateTime) {
  return "${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
}

String dateFormatHHmm(DateTime dateTime) {
  return "${dateTime.hour.toString()}:${dateTime.second.toString().padLeft(2, '0')}";
}