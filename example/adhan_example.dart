import 'dart:math';

import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

void main() {

  final myCoordinates =
      Coordinates(34.006962,71.533058); // Replace with your own location lat, lng.
  final nyUtcOffset = Duration(hours: 5);
  final params = CalculationMethod.karachi.getParameters();
  params.madhab = Madhab.hanafi;
  final prayerTimes = PrayerTimes.today(myCoordinates, params,utcOffset: DateTime.now().timeZoneOffset);

  print(
      "---Today's Prayer Times in Your Local Timezone(${prayerTimes.fajr!.timeZoneName})---");
  print(DateFormat.jm().format(prayerTimes.fajr!));
  print(DateFormat.jm().format(prayerTimes.sunrise!));
  print(DateFormat.jm().format(prayerTimes.dhuhr!));
  print(DateFormat.jm().format(prayerTimes.asr!));
  print(DateFormat.jm().format(prayerTimes.maghrib!));
  print(DateFormat.jm().format(prayerTimes.isha!));

  print('---');

  // // Custom Timezone Usage. (Most of you won't need this).
  // print('NewYork Prayer Times');
  // final newYork = Coordinates(35.7750, -78.6336);
  // final nyUtcOffset = Duration(hours: -4);
  // final nyDate = DateComponents(2015, 7, 12);
  // final nyParams = CalculationMethod.north_america.getParameters();
  // nyParams.madhab = Madhab.hanafi;
  // final nyPrayerTimes =
  //     PrayerTimes(newYork, nyDate, nyParams, utcOffset: nyUtcOffset);
  //
  // print(nyPrayerTimes.fajr.timeZoneName);
  // print(DateFormat.jm().format(nyPrayerTimes.fajr));
  // print(DateFormat.jm().format(nyPrayerTimes.sunrise));
  // print(DateFormat.jm().format(nyPrayerTimes.dhuhr));
  // print(DateFormat.jm().format(nyPrayerTimes.asr));
  // print(DateFormat.jm().format(nyPrayerTimes.maghrib));
  // print(DateFormat.jm().format(nyPrayerTimes.isha));


}
DateTime calculateSolarTime(DateTime dateTime, double latitude, double longitude) {
  // Calculate the number of days since the start of the year
  final daysSinceStartOfYear = dateTime.difference(DateTime(dateTime.year, 1, 1)).inDays;

  // Calculate the solar declination angle (the angle between the sun's rays and the Earth's surface)
  final solarDeclination = 0.409 * sin(2 * pi * (daysSinceStartOfYear - 80) / 365.25);

  // Calculate the solar hour angle (the angle between the sun and the meridian at a given location)
  final solarHourAngle = pi / 12 * (dateTime.hour + dateTime.minute / 60 + dateTime.second / 3600 - 12);

  // Calculate the solar time (the time of the day when the sun is at its highest point in the sky)
  final solarTime = 12 + (longitude - 15 * dateTime.timeZoneOffset.inHours) / 15 - solarHourAngle * cos(solarDeclination) / pi;

  // Return the solar time as a DateTime object
  return DateTime.utc(dateTime.year, dateTime.month, dateTime.day, solarTime.floor(), ((solarTime - solarTime.floor()) * 60).toInt()).toLocal();
}