import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:eddy_osorio_3_2021_2_p1/components/loader_component.dart';
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
     return Scaffold(
         backgroundColor: Colors.black,
      appBar: AppBar(
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
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
          /*return Card(
            child: InkWell(
              onTap: () => (){},
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Row(
                  children: [
                    ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: e.animeImg,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                        height: 120,
                        width: 80,
                        placeholder: (context, url) => Image(
                          image: AssetImage('assets/sinimagenanime.png'),
                          height: 120,
                          width: 80,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Text(
                                  e.animeName, 
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                                              
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          );*/
            return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsets.all(15),
      elevation: 10,

      // Dentro de esta propiedad usamos ClipRRect
      child: ClipRRect(

        // Los bordes del contenido del card se cortan usando BorderRadius
        borderRadius: BorderRadius.circular(30),

        // EL widget hijo que será recortado segun la propiedad anterior
        child: Column(
          children: <Widget>[

            // Usamos el widget Image para mostrar una imagen
             ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: e.animeImg,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                        height: 120,
                        width: 80,
                        placeholder: (context, url) => Image(
                          image: AssetImage('assets/sinimagenanime.png'),
                          height: 120,
                          width: 80,
                        ),
                      ),
                    ),

            // Usamos Container para el contenedor de la descripción
            Container(
              padding: EdgeInsets.all(10),
              child:  Text(
                                  e.animeName, 
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
            ),
          ],
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
              Text('Escriba las primeras letras del procedimiento'),
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
}