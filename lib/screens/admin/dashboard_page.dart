import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/dashboard_page';

  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final SystemApi systemApi = SystemApi();
  List<DailyRevenue> _dailyRevenues = [];
  bool _isLoading = false;
  int? _touchedIndex;
  DateTime _currentStartDate = DateTime.now().subtract(Duration(days: 6));

  @override
  void initState() {
    super.initState();
    _fetchDailyRevenues();
  }

  Future<void> _fetchDailyRevenues() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _dailyRevenues.clear(); // Clear previous data
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      for (int i = 0; i < 7; i++) {
        String formattedDate =
            formatter.format(_currentStartDate.add(Duration(days: i)));
        final dailyRevenue =
            await systemApi.fetchDailyRevenue(DateTime.parse(formattedDate));
        _dailyRevenues
            .add(DailyRevenue(date: formattedDate, revenue: dailyRevenue));
      }
      _dailyRevenues.sort((a, b) => a.date.compareTo(b.date));
    } catch (e) {
      print('Error fetching daily revenues: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadPreviousWeek() {
    setState(() {
      _currentStartDate = _currentStartDate.subtract(Duration(days: 7));
    });
    _fetchDailyRevenues();
  }

  void _loadNextWeek() {
    if (_currentStartDate.add(Duration(days: 7)).isBefore(DateTime.now())) {
      setState(() {
        _currentStartDate = _currentStartDate.add(Duration(days: 7));
      });
      _fetchDailyRevenues();
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime endDate = _currentStartDate.add(Duration(days: 6));
    String startDateStr = DateFormat('dd-MM').format(_currentStartDate);
    String endDateStr = DateFormat('dd-MM').format(endDate);

    return Scaffold(
      backgroundColor: background,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(
                  top: 18.0, left: 18.0, right: 18.0, bottom: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Tổng quan doanh thu 7 ngày',
                    style: GoogleFonts.arsenal(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: brown),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              _loadPreviousWeek();
                            },
                            icon: Icon(Icons.chevron_left, size: 30,color: brown,),
                          ),
                          Text(
                            'Trước',
                            style:
                                GoogleFonts.roboto(fontSize: 15, color: black),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              _loadNextWeek();
                            },
                            icon: Icon(
                              Icons.chevron_right,
                              size: 30,
                              color: brown,
                            ),
                          ),
                          Text(
                            'Sau',
                            style:
                                GoogleFonts.roboto(fontSize: 15, color: black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 10000,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              String date = _dailyRevenues[groupIndex].date;
                              return BarTooltipItem(
                                '$date\n',
                                TextStyle(
                                  color: white,
                                ),
                                children: [
                                  TextSpan(
                                    text: formatCurrency(rod.toY),
                                    style: TextStyle(
                                      color: white,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          touchCallback:
                              (FlTouchEvent event, barTouchResponse) {
                            setState(() {
                              if (barTouchResponse != null &&
                                  barTouchResponse.spot != null) {
                                _touchedIndex =
                                    barTouchResponse.spot!.touchedBarGroupIndex;
                              } else {
                                _touchedIndex = -1;
                              }
                            });
                          },
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                DateTime date = DateTime.parse(
                                    _dailyRevenues[value.toInt()].date);
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    DateFormat('dd-MM').format(date),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              },
                              interval: 1,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if ([100, 500, 1000, 2000, 5000, 10000]
                                    .contains(value)) {
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                              interval: 1,
                              reservedSize: 40,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade300, width: 1),
                            left: BorderSide(
                                color: Colors.grey.shade300, width: 1),
                            right: BorderSide(color: Colors.transparent),
                            top: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        barGroups: _buildBarGroups(),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      'Biểu đồ doanh thu từ $startDateStr đến $endDateStr',
                      style: GoogleFonts.roboto(fontSize: 16, color: brown),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String formatCurrency(double value) {
    final format = NumberFormat.currency(locale: 'vi', symbol: 'VND');
    return format.format(value);
  }

  List<BarChartGroupData> _buildBarGroups() {
    List<BarChartGroupData> bars = [];
    for (int i = 0; i < _dailyRevenues.length; i++) {
      bars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: _dailyRevenues[i].revenue.toDouble(),
              color: _touchedIndex == i ? green : blue,
            ),
          ],
          showingTooltipIndicators: _touchedIndex == i ? [0] : [],
        ),
      );
    }
    return bars;
  }
}
