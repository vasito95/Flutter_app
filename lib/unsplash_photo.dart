import 'package:flutter/material.dart';

class UnsplashPhoto extends StatelessWidget {
  static const routeName = '/passArguments';

  @override
  Widget build(BuildContext context) {
    final String arg = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Picture page'),
      ),
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Image.network(arg, fit: BoxFit.contain),
      )
    );
  }
}