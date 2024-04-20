import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/screens/app/result_search_product_product_with_keyword_page.dart';
import 'package:highlandcoffeeapp/models/products.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/utils/mic/language_translator.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MicForm extends StatefulWidget {
  @override
  State<MicForm> createState() => _MicFormState();
}

class _MicFormState extends State<MicForm> {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';
  LanguageTranslator _translator = LanguageTranslator();
  List<Products> searchResults = [];

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('status: $status');
        },
        onError: (errorNotification) {
          print('error: $errorNotification');
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
        });

        _speech.listen(
          onResult: (result) {
            String voiceQuery = _translator.translate(result.recognizedWords);
            setState(() {
              _text = voiceQuery;
            });
            _performSearch(voiceQuery);
          },
          listenFor: Duration(seconds: 10),
          pauseFor: Duration(seconds: 5),
          onSoundLevelChange: (level) {
            print('sound level: $level');
          },
        );
      } else {
        print('The user has denied the use of speech recognition.');
      }
    }
  }

  //
  void _performSearch(String query) {
  FirebaseFirestore.instance
      .collection('Danh sách sản phẩm')
      .where('name', isGreaterThanOrEqualTo: query)
      .where('name', isLessThan: query + 'z')
      .get()
      .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
    List<Products> newSearchResults = querySnapshot.docs
        .where((doc) => doc['name'] != null && doc['name'] is String)
        .map((doc) => Products(
              // Tạo đối tượng Products từ dữ liệu Firestore
              imagePath: doc['imagePath'],
              name: doc['name'],
              oldPrice: doc['oldPrice'],
              newPrice: doc['newPrice'],
              id: doc['id'],
              description: doc['description'],
              rating: doc['rating'],
              imageDetailPath: doc['imageDetailPath'],
              category: doc['category'],
            ))
        .toList();

    // Nếu không có kết quả, thử tìm kiếm theo tên không dấu và so sánh
    if (newSearchResults.isEmpty) {
      String normalizedQuery = removeDiacritics(query.toLowerCase());
      newSearchResults = querySnapshot.docs
          .where((doc) =>
              doc['normalized_name'] != null &&
              doc['normalized_name'] is String &&
              doc['normalized_name'].contains(normalizedQuery))
          .map((doc) => Products(
                // Tạo đối tượng Products từ dữ liệu Firestore
                imagePath: doc['imagePath'],
                name: doc['name'],
                oldPrice: doc['oldPrice'],
                newPrice: doc['newPrice'],
                id: doc['id'],
                description: doc['description'],
                rating: doc['rating'],
                imageDetailPath: doc['imageDetailPath'],
                category: doc['category'],
              ))
          .toList();
    }

    setState(() {
      searchResults = newSearchResults;
      _text = ''; // Clear the text after the search
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultSearchProductWithKeyword(
          searchResults: newSearchResults,
          voiceQuery: query,
        ),
      ),
    );

    // In ra danh sách sản phẩm
    print('Search results: $newSearchResults');
  }).catchError((error) {
    print('Error searching products: $error');
  });
}


  String removeDiacritics(String input) {
    return input
        .replaceAll('ă', 'a')
        .replaceAll('â', 'a')
        .replaceAll('đ', 'd')
        .replaceAll('ê', 'e')
        .replaceAll('ô', 'o')
        .replaceAll('ơ', 'o')
        .replaceAll('ư', 'u')
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('ả', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('ạ', 'a')
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ẻ', 'e')
        .replaceAll('ẽ', 'e')
        .replaceAll('ẹ', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ì', 'i')
        .replaceAll('ỉ', 'i')
        .replaceAll('ĩ', 'i')
        .replaceAll('ị', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ò', 'o')
        .replaceAll('ỏ', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ọ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ù', 'u')
        .replaceAll('ủ', 'u')
        .replaceAll('ũ', 'u')
        .replaceAll('ụ', 'u')
        .replaceAll('ý', 'y')
        .replaceAll('ỳ', 'y')
        .replaceAll('ỷ', 'y')
        .replaceAll('ỹ', 'y')
        .replaceAll('ỵ', 'y');
  }

//   void _navigateToSearchResult(String query) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => SearchResultPage(searchResults: [], voiceQuery: query),
//     ),
//   );
// }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 30, top: 70, right: 30, bottom: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.clear),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _isListening
                          ? 'Đang nghe...'
                          : 'Mi-crô đang tắt. Mời bạn nói lại.',
                      style: TextStyle(
                          fontSize: 16,
                          color: black,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
              ],
            ),
            // AvatarGlow widget here
            Column(
              children: [
                Container(
                  child: AvatarGlow(
                    glowColor: primaryColors,
                    endRadius: 80.0,
                    animate: _isListening,
                    duration: Duration(milliseconds: 2000),
                    repeatPauseDuration: Duration(milliseconds: 100),
                    repeat: true,
                    showTwoGlows: true,
                    child: GestureDetector(
                      onTap: () {
                        _startListening();
                      },
                      child: CircleAvatar(
                        backgroundColor: primaryColors,
                        radius: 40.0,
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          color: white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  _isListening ? '' : 'Nhấn vào micrô để thử lại',
                  style: TextStyle(
                      fontSize: 16,
                      color: black,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none),
                )
              ],
            ),
            Text(_text), // Hiển thị văn bản nhận dạng được
          ],
        ),
      ),
    );
  }
}
