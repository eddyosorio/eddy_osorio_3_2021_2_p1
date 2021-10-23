import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:eddy_osorio_3_2021_2_p1/helpers/api_helper.dart';
import 'package:eddy_osorio_3_2021_2_p1/models/data_anime.dart';
import 'package:flutter/material.dart';
import 'package:eddy_osorio_3_2021_2_p1/models/response';

class AnimeScreen extends StatefulWidget {

  @override
  _AnimeScreenState createState() => _AnimeScreenState();
}

class _AnimeScreenState extends State<AnimeScreen> {

   List<DataAnime> _animes = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';

    @override
  void initState() {
    super.initState();
    _getAnimes();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }

   Future<Null> _getAnimes() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: 'Verifica tu conexión a internet.',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }
     Response response = await ApiHelper.getAnimes();

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    setState(() {
      _animes = response.result;
    });
}
}