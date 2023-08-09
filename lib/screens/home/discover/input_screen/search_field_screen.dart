import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchParameters {
  final String? keywords;
  final String? address;
  final String? radius;

  SearchParameters({this.keywords, this.address, this.radius});
}

class SearchFieldScreen extends StatefulWidget {
  final bool isKeywordSearch;

  const SearchFieldScreen({super.key, required this.isKeywordSearch});

  @override
  _SearchFieldScreenState createState() => _SearchFieldScreenState();
}

class _SearchFieldScreenState extends State<SearchFieldScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _showKeyboard();
  }

  void _showKeyboard() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_textFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isKeywordSearch ? 'Search Keywords' : 'Enter Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _textController,
                focusNode: _textFocusNode,
                decoration: InputDecoration(
                  hintText: widget.isKeywordSearch
                      ? 'Enter your search keywords...'
                      : 'Enter your address...',
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  _search(context);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _search(context);
                },
                child: const Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _search(BuildContext context) {
    final searchText = _textController.text;
    Get.back(
      result: SearchParameters(
        keywords: widget.isKeywordSearch ? searchText : null,
        address: widget.isKeywordSearch ? null : searchText,
        radius: widget.isKeywordSearch ? null : '10',
      ),
    );
  }
}
