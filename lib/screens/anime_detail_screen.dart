import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:eddy_osorio_3_2021_2_p1/components/loader_component.dart';
import 'package:eddy_osorio_3_2021_2_p1/helpers/api_helper.dart';
import 'package:eddy_osorio_3_2021_2_p1/models/data_anime.dart';
import 'package:eddy_osorio_3_2021_2_p1/models/data_detail.dart';
import 'package:eddy_osorio_3_2021_2_p1/models/detail_generated.dart';
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
   late DetailGenerated _detail ;

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
 Widget _getContent() {
     return _detail.details.length == 0 
      ? _noContent()
      : _getListView();
  }
Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getDetailAnime,
    
      child: ListView(
     
        children: _detail.details.map((e) {
          return Card(
            child: InkWell(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  e.fact,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                             
                              ],
                            ),
                          ],
                        ),
                      )
                    ),
                    Icon(Icons.arrow_forward_ios, size: 40,)
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ), 
    );
  }
    Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          'No se encontraron detalles para el anime',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
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