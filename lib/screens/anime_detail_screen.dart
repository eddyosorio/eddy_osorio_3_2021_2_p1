import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:eddy_osorio_3_2021_2_p1/components/loader_component.dart';
import 'package:eddy_osorio_3_2021_2_p1/helpers/api_helper.dart';
import 'package:eddy_osorio_3_2021_2_p1/models/data_anime.dart';
import 'package:flutter/material.dart';
import 'package:eddy_osorio_3_2021_2_p1/models/response';

class AnimeDetailScreen extends StatefulWidget {
 final DataAnime data;

  AnimeDetailScreen({ required this.data});
  @override
  _AnimeDetailScreenState createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
bool _showLoader = false;
   List<DataAnime> _detail = [];

  late DataAnime _anime;
@override
  void initState() {
    super.initState();
    _anime = widget.data;
    _getDetailAnime();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text(_anime.animeName),
      ),
      body: Center(
        child: _showLoader 
          ? LoaderComponent(text: 'Un momento...',) 
          : _getContent(),
      ),
    
    );
  }

  Future<Null> _getDetailAnime() async {
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
     Response response = await ApiHelper.getDetailAnime(_anime.animeName);

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
      _detail = response.result;
    });
}
}