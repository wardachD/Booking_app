import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Screen'),
      ),
      body: const Center(
        child: Text(
          'Witaj, to jest zawartość mojej strony!',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
