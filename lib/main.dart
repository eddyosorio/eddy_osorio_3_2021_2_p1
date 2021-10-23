import 'package:eddy_osorio_3_2021_2_p1/screens/animes.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget{
  @override
    Widget build(BuildContext context) {
    return MaterialApp(
            debugShowCheckedModeBanner: false,

        title: 'AnimesApp',
      home: AnimeScreen() 
      );
    }
}
