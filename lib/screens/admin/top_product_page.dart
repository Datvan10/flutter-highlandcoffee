import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:intl/intl.dart';

class TopProductPage extends StatefulWidget {
  static const String routeName = '/top_product_page';

  const TopProductPage({Key? key}) : super(key: key);

  @override
  _TopProductPageState createState() => _TopProductPageState();
}

class _TopProductPageState extends State<TopProductPage> {
  List<Map<String, dynamic>> _topProducts = [];
  final TextEditingController _dateController = TextEditingController();
  SystemApi systemApi = SystemApi();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    _fetchTopProducts(_selectedDate!);
  }

  Future<void> _fetchTopProducts(DateTime date) async {
    try {
      final topProducts = await systemApi.fetchTopProducts(date);
      setState(() {
        _topProducts = topProducts;
      });
    } catch (e) {
      setState(() {
        _topProducts = [];
      });
      throw Exception('Failed to load top products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Padding(
        padding: const EdgeInsets.only(
            left: 18.0, top: 18.0, right: 18.0, bottom: 25),
        child: Column(
          children: [
            Text(
              'Thống kê sản phẩm bán chạy nhất trong ngày',
              style: GoogleFonts.arsenal(
                  fontSize: 30, fontWeight: FontWeight.bold, color: brown),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Chọn thời gian lọc (yyyy-mm-dd)',
                labelStyle: GoogleFonts.roboto(color: black, fontSize: 20),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today, color: primaryColors),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                        _dateController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                ),
              ),
              keyboardType: TextInputType.datetime,
            ),
            Expanded(
              child: _topProducts.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AspectRatio(
                                aspectRatio: 1.4,
                                child: PieChart(
                                  PieChartData(
                                    sections: _generatePieChartSections(),
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 50,
                                    pieTouchData: PieTouchData(enabled: false),
                                  ),
                                  swapAnimationDuration:
                                      Duration(milliseconds: 500),
                                ),
                              ),
                              Center(
                                child: Text(
                                  'Biểu đồ thống kê sản phẩm bán ngày' +
                                      ' ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                                  style: GoogleFonts.roboto(fontSize: 16, color : brown),
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text('Chú thích: ',
                                      style: GoogleFonts.roboto(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  Text('tên sản phẩm (số lượng bán)',
                                      style: GoogleFonts.roboto())
                                ],
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    spacing: 20,
                                    runSpacing: 15,
                                    children: _buildLegend(),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text('Tổng số sản phẩm bán được: ',
                                      style: GoogleFonts.roboto(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      '${_topProducts.fold(0, (sum, product) => sum + product['quantitysold'] as int)}', style: GoogleFonts.roboto(fontSize : 15, color : red),)
                                ],
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Sản phẩm bán chạy nhất: ',
                                        style: GoogleFonts.roboto(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        '${_topProducts[0]['productname']} \n(${_topProducts[0]['quantitysold']})', style: GoogleFonts.roboto(fontSize : 15, color : red))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            MyButton(
              text: 'Xem kết quả',
              onTap: () {
                if (_selectedDate != null) {
                  _fetchTopProducts(_selectedDate!);
                }
              },
              buttonColor: green,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _generatePieChartSections() {
    List<PieChartSectionData> sections = [];
    if (_topProducts.isNotEmpty) {
      int totalQuantity = _topProducts.fold(
          0, (sum, product) => sum + product['quantitysold'] as int);
      int index = 0;
      for (var product in _topProducts) {
        double percentage = (product['quantitysold'] / totalQuantity) * 100;
        sections.add(
          PieChartSectionData(
            color: _getColor(index),
            value: percentage,
            title: '${percentage.toStringAsFixed(1)}%',
            radius: 80,
            titleStyle: GoogleFonts.roboto(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
        index++;
      }
    } else {
      sections.add(
        PieChartSectionData(
          color: Colors.grey,
          value: 100,
          title: '0%',
          radius: 80,
          titleStyle: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    }
    return sections;
  }

  List<Widget> _buildLegend() {
    List<Widget> legendWidgets = [];
    int index = 0;
    for (var product in _topProducts) {
      legendWidgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 20,
              color: _getColor(index),
            ),
            SizedBox(width: 4),
            Text(
              '${product['productname']} (${(product['quantitysold'] as int).toString()})',
              style: GoogleFonts.roboto(fontSize: 12),
            ),
          ],
        ),
      );
      index++;
    }
    return legendWidgets;
  }

  Color _getColor(int index) {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.amber,
      Colors.deepOrange,
      Colors.indigo,
      Colors.pink,
    ];
    return colors[index % colors.length];
  }
}
