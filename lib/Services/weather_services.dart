import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  // Gets the user's city and coordinates from GPS
  static Future<Map<String, dynamic>> getCityFromGPS() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return {'error': 'Location disabled'};
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {'error': 'Permission denied'};
      }
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition();
    // Reverse geocode to get city name
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    String city = placemarks.first.locality ?? 'Unknown city';

    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'city': city,
    };
  }

  // Converts a UTC timestamp and timezone offset to a local time string (HH:mm)
  static String extractTime(int timestamp, int timezoneOffsetSeconds) {
    final utcDateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
      isUtc: true,
    );

    final localDateTime = utcDateTime.add(
      Duration(seconds: timezoneOffsetSeconds),
    );

    final hours = localDateTime.hour.toString().padLeft(2, '0');
    final minutes = localDateTime.minute.toString().padLeft(2, '0');

    return '$hours:$minutes';
  }

  // Maps weather conditions to Material icons
  static const Map<String, IconData> weatherIcons = {
    'Thunderstorm': Icons.flash_on,
    'Drizzle': Icons.grain,
    'Rain': Icons.water_drop_outlined,
    'Snow': Icons.ac_unit,
    'Mist': Icons.blur_on,
    'Smoke': Icons.cloud_queue,
    'Haze': Icons.filter_drama,
    'Dust': Icons.cloud_circle,
    'Fog': Icons.cloud_off,
    'Sand': Icons.filter_drama,
    'Ash': Icons.cloud_circle,
    'Squall': Icons.toys,
    'Tornado': Icons.warning,
    'Clear': Icons.wb_sunny,
    'Clouds': Icons.cloud,
  };

  // Fetches current weather and forecast data from OpenWeatherMap API
  static Future<Map<String, dynamic>> fetchWeatherData({
    required String apiKey,
  }) async {
    try {
      // Get location data (city, latitude, longitude)
      Map<String, dynamic> locationData = await getCityFromGPS();
      String cityName = locationData['city'];

      // Fetch current weather data
      final resultCurrent = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${locationData['latitude']}&lon=${locationData['longitude']}&appid=$apiKey',
        ),
      );
      final dataCurrent = jsonDecode(resultCurrent.body);
      if (dataCurrent['cod'].toString() != '200') {
        throw dataCurrent['message'] ?? 'Failed to fetch current weather';
      }

      // Fetch forecast data
      final resultForecast = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=${locationData['latitude']}&lon=${locationData['longitude']}&appid=$apiKey',
        ),
      );
      final dataForecast = jsonDecode(resultForecast.body);
      if (dataForecast['cod'].toString() != '200') {
        throw dataForecast['message'] ?? 'Failed to fetch forecast data';
      }

      // Return city name, current weather, and forecast
      return {
        'city': cityName,
        'current': dataCurrent,
        'forecast': dataForecast,
      };
    } catch (e) {
      // Rethrow error as string for easier handling
      throw e.toString();
    }
  }
}
