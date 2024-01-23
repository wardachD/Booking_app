import 'package:findovio/models/findovio_advertisement_model.dart';
import 'package:flutter/material.dart';

class CustomAdvertisement extends StatelessWidget {
  final FindovioAdvertisement advertisement;

  CustomAdvertisement({required this.advertisement});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0, 10),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  advertisement.url,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Center(
                      child: Text('Nie można załadować obrazka.'),
                    );
                  },
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                advertisement.title,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                advertisement.content,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Zamknij'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
