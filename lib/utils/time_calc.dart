import 'package:intl/intl.dart';

class TimeCalc {
  DateTime currentDateTime = DateTime.now();
  DateFormat dateFormatter = DateFormat("MM/dd/yyyy");
  DateFormat timeFormatter = DateFormat("h:mm a");
  DateFormat dateTimeFormatter = DateFormat("MM/dd/yyyy h:mm a");
  DateFormat formatter = DateFormat('MMM dd, yyyy');

  String getStringFromDate(DateTime data) {
    String dateTime = formatter.format(data);
    print(dateTime);
    return dateTime;
  }

  DateTime getDateTimeFromString(String data) {
    DateTime dateTime = formatter.parse(data);
    print(dateTime);
    return dateTime;
  }

  getTimeDifferenceInMinutes(String endTime) {
    String difference = "1 hour";
    String formattedTime = timeFormatter.format(currentDateTime);
    int time1 = timeFormatter.parse(formattedTime).millisecondsSinceEpoch;
    int time2 = timeFormatter.parse(endTime).millisecondsSinceEpoch;
    int timeDifference = ((time2 - time1) / 600000).round();

    if (timeDifference > 59) {
      int hours = (timeDifference / 60).round();
      int remainingMinutes = timeDifference - (hours * 60);
      difference = "$hours hour(s) $remainingMinutes";
    } else {
      difference = "$timeDifference";
    }

    return difference;
  }

  String getPastTimeFromMilliseconds(int milliseconds) {
    String timeDetail;
    int hours = 0;
    DateTime givenTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    int timeDifferenceInMinutes = currentDateTime.difference(givenTime).inMinutes;
    if (timeDifferenceInMinutes >= 60) {
      hours = (timeDifferenceInMinutes / 60).round();
    }
    if (hours >= 1) {
      if (hours >= 24 && hours < 48) {
        timeDetail = "yesterday";
      } else if (hours >= 48) {
        int days = (hours / 24).round();
        timeDetail = "$days days ago";
        if (days > 3) {
          timeDetail = DateFormat('MMM dd, h:mm a').format(givenTime);
        }
      } else {
        timeDetail = "$hours hours ago";
      }
    } else {
      timeDetail = "$timeDifferenceInMinutes minutes ago";
    }
    return timeDetail;
  }

  DateTime getDateTimeFromMilliseconds(int milliseconds) {
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(milliseconds);
    return dateTime;
  }
}
