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
               
     return 
     
     Scaffold(
                backgroundColor: Colors.grey[300],

      appBar: AppBar(
        title: Text(_anime.animeName),
                        backgroundColor: Colors.grey[800],

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

  String _getDetailsFac(){
    var textone="";
       for(int i = 0; i < _detail.details.length; i++){
               textone=textone +"\n\n" +_detail.details[i].fact;
       }
                  return textone;
  }
Widget _getListView() {
    return 
      RefreshIndicator(
      onRefresh: _getDetailAnime,
    child: Column(
      children: <Widget>[
          ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: _anime.animeImg,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                        height: 400,
                        width: 300,
                        placeholder: (context, url) => Image(
                          image: AssetImage('assets/sinimagenanime.png'),
                          height: 400,
                          width: 400,
                        ),
                      ),
                    ),
                    Container(
                                      padding: EdgeInsets.all(15),

                    child:Text("Información de interés", style: TextStyle(
                            fontSize: 15,fontWeight: FontWeight.bold
                          ),),),
 Expanded(
                   child: ListView(
        children: _detail.details.map((e) {
          return Card(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded( child:Text(
                          e.fact, 
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),),
                      ],
                    ),
                  
                  ],
                ),
              ),
          );
        }).toList(),
      ),
 ),
         /* Expanded(    
      child:SingleChildScrollView(
              child: Container(
              
                child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              Expanded(

                  child: Text(_getDetailsFac(),style: TextStyle(fontSize: 15.0, color: Colors.black))),
            ],
          ),
                ),
              ),
          ),*/
      ],
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