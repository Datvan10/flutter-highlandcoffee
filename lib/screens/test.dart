import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Popular {
  final int id;
  final String categoryName;
  final String productName;
  final String description;
  final int sizeSPrice;
  final int sizeMPrice;
  final int sizeLPrice;
  final String unit;
  String image;
  String imageDetail;
  final int quantity;

  Popular({
    required this.id,
    required this.categoryName,
    required this.productName,
    required this.description,
    required this.sizeSPrice,
    required this.sizeMPrice,
    required this.sizeLPrice,
    required this.unit,
    required this.image,
    required this.imageDetail,
    required this.quantity,
  });

  factory Popular.fromJson(Map<String, dynamic> json) {
    return Popular(
      id: json['id'],
      categoryName: json['category_name'],
      productName: json['product_name'],
      description: json['description'],
      sizeSPrice: json['size_s_price'],
      sizeMPrice: json['size_m_price'],
      sizeLPrice: json['size_l_price'],
      unit: json['unit'],
      image: json['image'],
      imageDetail: json['image_detail'],
      quantity: json['quantity'],
    );
  }
}

class PopularApi {
  final String popularUrl = "http://localhost:5194/api/populars";

  Future<List<Popular>> getPopulars() async {
    try {
      final response = await http.get(Uri.parse(popularUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Popular> populars = [];
        for (var item in jsonData) {
          Popular popular = Popular.fromJson(item);
          // Decode image and image detail
          Uint8List decodedImage = base64Decode(popular.image);
          Uint8List decodedImageDetail = base64Decode(popular.imageDetail);
          final image = MemoryImage(decodedImage);
          final imageDetail = MemoryImage(decodedImageDetail);

          populars.add(popular);
        }
        return populars;
      } else {
        throw Exception('Failed to load popular products');
      }
    } catch (e) {
      throw Exception('Failed to load popular products');
    }
  }
}

class PopularListScreen extends StatefulWidget {
  @override
  _PopularListScreenState createState() => _PopularListScreenState();
}

class _PopularListScreenState extends State<PopularListScreen> {
  late Future<List<Popular>> popularsFuture;
  late PopularApi popularApi;

  @override
  void initState() {
    super.initState();
    popularApi = PopularApi();
    popularsFuture = popularApi.getPopulars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Products'),
      ),
      body: FutureBuilder<List<Popular>>(
        future: popularsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Popular>? populars = snapshot.data;
            return ListView.builder(
              itemCount: populars!.length,
              itemBuilder: (context, index) {
                Popular popular = populars[index];
                return ListTile(
                  title: Text(popular.productName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category: ${popular.categoryName}'),
                      Text('Description: ${popular.description}'),
                      Text('Size S Price: ${popular.sizeSPrice}'),
                      Text('Size M Price: ${popular.sizeMPrice}'),
                      Text('Unit: ${popular.unit}'),
                    ],
                  ),
                  leading: Container(
                    width: 200,
                    height: 500,
                    child: Image.memory(
                      base64Decode(popular.image),
                      fit: BoxFit.cover,
                    )
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
