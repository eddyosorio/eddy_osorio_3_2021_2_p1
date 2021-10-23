import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:eddy_osorio_3_2021_2_p1/components/loader_component.dart';
import 'package:eddy_osorio_3_2021_2_p1/helpers/api_helper.dart';
import 'package:eddy_osorio_3_2021_2_p1/models/data_anime.dart';
import 'package:flutter/material.dart';
import 'package:eddy_osorio_3_2021_2_p1/models/response';

import 'anime_detail_screen.dart';

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
     return Scaffold(
         backgroundColor: Colors.black,
      appBar: AppBar(
                backgroundColor: Colors.grey[800],

        title: Text('Animes'),
        actions: <Widget>[
          _isFiltered
          ? IconButton(
              onPressed: _removeFilter, 
              icon: Icon(Icons.filter_none)
            )
          : IconButton(
              onPressed: _showFilter, 
              icon: Icon(Icons.filter_alt)
            )
        ],
      ),
      body: Center(
        child: _showLoader ? LoaderComponent(text: 'Por favor espere...') : _getContent(),
      ),
  
    );
  }



 void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getAnimes();
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
  


  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          _isFiltered
          ? 'No hay Animes con ese criterio de búsqueda.'
          : 'No hay Animes registrados.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
    Widget _getContent() {
    return _animes.length == 0 
      ? _noContent()
      : _getListView();
  }

Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getAnimes,
      child: GridView.count(
          crossAxisCount: 2,

        children: _animes.map((e) {
         
            return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 20,
      margin: EdgeInsets.all(15),
              child: InkWell(
              onTap: () => _goDetailAnime(e),
               child: Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: <Widget>[
             ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: e.animeImg,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                        height: 150,
                        width: 200,
                        placeholder: (context, url) => Image(
                          image: AssetImage('assets/sinimagenanime.png'),
                          height: 400,
                          width: 400,
                        ),
                      ),
                    ),
            Container(
            //  padding: EdgeInsets.all(20),
              child:  Text(
                                  e.animeName, 
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
            ),
          ],
        ),
          ),
            ),
      ));
        }).toList(),
      ),
    );
  }



    void _showFilter() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Filtrar Animes'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10,),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Criterio de búsqueda...',
                  labelText: 'Buscar',
                  suffixIcon: Icon(Icons.search)
                ),
                onChanged: (value) {
                  _search = value;
                },
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text('Cancelar')
            ),
            TextButton(
              onPressed: () => _filter(), 
              child: Text('Filtrar')
            ),
          ],
        );
      });
  }
void _filter() {
    if (_search.isEmpty) {
      return;
    }

    List<DataAnime> filteredList = [];
    for (var anime in _animes) {
      if (anime.animeName.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(anime);
      }
    }

    setState(() {
      _animes = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }
  
  void _goDetailAnime (DataAnime dataAnime) async{
   String? result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => AnimeDetailScreen(data: dataAnime,)
              )
    );
    if (result == 'yes') {
      _getAnimes();
    }
}
}

