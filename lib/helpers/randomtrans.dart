import 'dart:core';
import 'dart:math';

const chars = "ABCDEFGHIJKLMNIVQRSTUPWYZ0123456789";
const charsotp = "0123456789";

String randomTransId(int strlen) {
  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  DateTime today = new DateTime.now();
  for (var i = 0; i < strlen; i++) {
    result += chars[rnd.nextInt(chars.length)];
  }
  return 'JA${today.year}${today.month}${today.day}$result${today.hour}${today.minute}';
}

String randomPulsaId(int strlen) {
  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  DateTime today = new DateTime.now();
  for (var i = 0; i < strlen; i++) {
    result += chars[rnd.nextInt(chars.length)];
  }
  return 'PL${today.year}${today.month}${today.day}$result${today.hour}${today.minute}';
}

String randomBooking(int strlen, customerid) {
  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  DateTime today = new DateTime.now();
  for (var i = 0; i < strlen; i++) {
    result += chars[rnd.nextInt(chars.length)];
  }
  return 'BO$customerid${today.year}${today.month}${today.day}$result${today.hour}${today.minute}';
}

String randomOTP(int strlen) {
  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  for (var i = 0; i < strlen; i++) {
    result += charsotp[rnd.nextInt(charsotp.length)];
  }
  return '$result';
}
