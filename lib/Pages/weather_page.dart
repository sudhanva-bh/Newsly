import 'package:flutter/material.dart';

class WeatherPage extends StatefulWidget {
  final dynamic weatherData;
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

  const WeatherPage({super.key, required this.weatherData});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String extractTime(int timestamp, int timezoneOffsetSeconds) {
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

  @override
  Widget build(BuildContext context) {
    final data = widget.weatherData;
    final timeZone = data['current']['timezone'];
    final currentTemp = data['current']['main']['temp'] - 273.15;
    final currentCondition = data['current']['weather'][0]['main'];
    final humidity = data['current']['main']['humidity'];
    final windSpeed = data['current']['wind']['speed'];
    final pressure = data['current']['main']['pressure'];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 39, 147, 255),
            Color.fromARGB(255, 142, 208, 255),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Current Weather",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Weather Card
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.white.withValues(alpha: .85),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "${currentTemp.toStringAsFixed(2)} °C",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Icon(
                          WeatherPage.weatherIcons[currentCondition],
                          size: 72,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          currentCondition,
                          style: const TextStyle(fontSize: 23),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 15),

              // Forecast Section
              const Text(
                "Weather Forecast",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 180,
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < 39; i++)
                        WeatherCard(
                          time: extractTime(
                            data['forecast']['list'][i]['dt'],
                            timeZone,
                          ),
                          icon:
                              WeatherPage
                                  .weatherIcons[data['forecast']['list'][i]['weather'][0]['main']]!,
                          temperature:
                              (data['forecast']['list'][i]['main']['temp'] -
                                      273.15)
                                  .toStringAsFixed(2),
                        ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(height: 15),

              // Additional Info Section
              const Text(
                "Additional Information",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 150,
                child: Card(
                  color: Colors.white.withValues(alpha: .85),
                  elevation: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AdditionalCard(
                        parameter: "Humidity",
                        value: "$humidity%",
                        icon: Icons.water_drop,
                      ),
                      AdditionalCard(
                        parameter: "Wind",
                        value: "${windSpeed}m/s",
                        icon: Icons.air,
                      ),
                      AdditionalCard(
                        parameter: "Pressure",
                        value: "$pressure hPa",
                        icon: Icons.speed,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;

  const WeatherCard({
    super.key,
    required this.time,
    required this.icon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Card(
        color: Colors.white.withValues(alpha: .85),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 5,
        child: SizedBox(
          height: 150,
          width: 150,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Icon(icon, size: 32, color: Colors.blue),
                const SizedBox(height: 10),
                Text("$temperature °C", style: const TextStyle(fontSize: 22)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdditionalCard extends StatelessWidget {
  final String parameter;
  final String value;
  final IconData icon;

  const AdditionalCard({
    super.key,
    required this.parameter,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 35, color: Colors.blueAccent),
        const SizedBox(height: 5),
        Text(parameter, style: const TextStyle(fontSize: 18)),
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
