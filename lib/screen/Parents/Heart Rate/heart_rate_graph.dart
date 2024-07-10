import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:ionicons/ionicons.dart';
import 'package:intl/intl.dart';

class HeartRateGraph extends StatefulWidget {
  @override
  _HeartRateGraphState createState() => _HeartRateGraphState();
}

class _HeartRateGraphState extends State<HeartRateGraph> {
  List<FlSpot> _heartRateData = [];
  List<String> _dates = [];
  int _selectedField = 1; // Default to field1

  // Map to store field number to corresponding label
  final Map<int, String> fieldLabels = {
    1: 'Heart Rate',
    // Add more field labels as needed
  };

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final String apiUrl =
        'https://api.thingspeak.com/channels/2571203/feeds.json?api_key=JRTJD7QMCFRHBY5B&results=10';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> feeds = data['feeds'];

      setState(() {
        _heartRateData = feeds
            .asMap()
            .entries
            .map((entry) {
          int index = entry.key;
          var feed = entry.value;
          String date = feed['created_at'];
          // Format the date to a short form
          String formattedDate = DateFormat('MM/dd').format(DateTime.parse(date));
          _dates.add(formattedDate); // Save the formatted date
          return FlSpot(index.toDouble(), double.tryParse(feed['field$_selectedField']) ?? 0);
        })
            .toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Set background color to dark
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.chevron_back_outline),
        ),
        title: Text(
          'Heart Rate',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE040FB),
                Color(0xFF7C4DFF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 40),
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.5,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey[800]!,
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.grey[800]!,
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                leftTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (context, value) => const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  getTitles: (value) {
                    return '${value.toInt()} bpm'; // Y-axis label
                  },
                ),
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (context, value) => const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  getTitles: (value) {
                    int index = value.toInt();
                    if (index >= 0 && index < _dates.length) {
                      return _dates[index]; // X-axis label with short form date
                    }
                    return '';
                  },
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.white, width: 1),
              ),
              minX: 0,
              maxX: _heartRateData.length - 1.toDouble(), // Adjust the max X value based on your data length
              minY: 0,
              maxY: 200, // Adjust the max Y value based on your data
              lineBarsData: [
                LineChartBarData(
                  spots: _heartRateData,
                  isCurved: true,
                  colors: [Colors.orange, Colors.red],
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    colors: [Colors.orange.withOpacity(0.3), Colors.red.withOpacity(0.3)],
                    gradientFrom: const Offset(0, 0),
                    gradientTo: const Offset(0, 1),
                    gradientColorStops: [0.5, 1.0],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

