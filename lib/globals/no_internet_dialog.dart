import 'package:flutter/material.dart';

class NoInternetDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning, color: Colors.red),
          SizedBox(width: 10),
          Text('Brak połączenia z internetem'),
        ],
      ),
      content: Text(
          'Nie można nawiązać połączenia z internetem. Sprawdź swoje połączenie i spróbuj ponownie.'),
      actions: <Widget>[
        TextButton(
          child: Text('Zamknij'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Text('Zrestartuj aplikację'),
      ],
    );
  }
}

// showDialog(context: context, builder: (BuildContext context) => NoInternetDialog());
