import '../utill/images.dart';
import 'package:intl/intl.dart';

String getGreetingMessage() {
  var now = DateTime.now();
  var formatter = DateFormat.Hm('en_US');
  var formattedTime = formatter.format(now);

  var timeNow = int.parse(formattedTime.split(':')[0]);

  if (timeNow <= 12) {
    return 'Good morning';
  } else if ((timeNow > 12) && (timeNow <= 16)) {
    return 'Good afternoon';
  } else if ((timeNow > 16) && (timeNow < 20)) {
    return 'Good evening';
  } else {
    return 'Good night';
  }
}
String getGreetingIcons() {
  var now = DateTime.now();
  var formatter = DateFormat.Hm('en_US');
  var formattedTime = formatter.format(now);

  var timeNow = int.parse(formattedTime.split(':')[0]);

  if (timeNow <= 12) {
    return Images.morning;
  } else if ((timeNow > 12) && (timeNow <= 16)) {
    return Images.day;
  } else if ((timeNow > 16) && (timeNow < 20)) {
    return Images.evening;
  } else {
    return Images.evening;
  }
}