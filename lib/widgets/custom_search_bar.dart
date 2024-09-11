// search_bar.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController textSearchController;
  final Function(String) performSearch;
  final VoidCallback startListening;
  final bool showBackButton;
  final VoidCallback? onBackButtonPressed;

  const CustomSearchBar({
    Key? key,
    required this.textSearchController,
    required this.performSearch,
    required this.startListening,
    this.showBackButton = false,
    this.onBackButtonPressed,
  }) : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  void initState() {
    super.initState();
    widget.textSearchController.addListener(_updateSuffixIcon);
  }

  @override
  void dispose() {
    widget.textSearchController.removeListener(_updateSuffixIcon);
    super.dispose();
  }

  void _updateSuffixIcon() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: widget.textSearchController,
        onSubmitted: (String query) {
          widget.performSearch(query);
        },
        decoration: InputDecoration(
          hintText: 'Tìm kiếm sản phẩm',
          hintStyle: GoogleFonts.roboto(color: black, fontSize: 17),
          contentPadding: const EdgeInsets.symmetric(),
          alignLabelWithHint: true,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: widget.showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: widget.onBackButtonPressed,
                )
              : const Icon(
                  Icons.search,
                  size: 20,
                ),
          suffixIcon: widget.textSearchController.text.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: whiteGrey,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: GestureDetector(
                      onTap: () {
                        widget.textSearchController.clear();
                        setState(() {});
                      },
                      child: const Icon(
                        Icons.close,
                        size: 10,
                      ),
                    )),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    widget.startListening();
                    setState(() {});
                  },
                  child: const Icon(
                    Icons.mic,
                    size: 20,
                  ),
                ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
