import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Fullscreenmap extends StatefulWidget {
  const Fullscreenmap({Key? key}) : super(key: key);

  @override
  State<Fullscreenmap> createState() => _FullscreenmapState();
}

class _FullscreenmapState extends State<Fullscreenmap> {
  //-------------------------- Variables y constantes ---------------------------
  String _selectedStyle = 'mapbox://styles/luiscba2/cl66zp9yp005414m8kkg6xzey';
  final oscuroStyle = 'mapbox://styles/luiscba2/cl1nm1d4y002b15p0dzxryoul';
  final streetStyle = 'mapbox://styles/luiscba2/cl1nm4ozx002c15p0u1n97fsu';
  final sateliteStyle = 'mapbox://styles/luiscba2/cl66zp9yp005414m8kkg6xzey';
  final nuevoStyle = 'mapbox://styles/luiscba2/clgo7pq5w007s01qnf62k3i0e';
  LatLng center = const LatLng(-31.43332, -64.226744);

//-------------------------- Pantalla -----------------------------------------
  MapboxMapController? mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        styleString: _selectedStyle,
        accessToken:
            'sk.eyJ1IjoibHVpc2NiYTIiLCJhIjoiY2xnbzZuemVuMG1zZTNkbnRiOWI3cDh0ZiJ9.5RlAg-Ipk1MiEIyeAJ-Pug',
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
            target: LatLng(-31.43332, -64.226744), zoom: 16),
      ),
      floatingActionButton: botonesFlotantes(),
    );
  }

  //-------------------------- Función _onMapCreated ---------------------------
  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }

  //-------------------------- Función _onStyleLoaded --------------------------
  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl("networkImage", "https://via.placeholder.com/50");
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController?.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, String url) async {
    var response = await http.get(Uri.parse(url));
    return mapController?.addImage(name, response.bodyBytes);
  }

  //-------------------------- botonesFlotantes ---------------------------------
  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Símbolos
        FloatingActionButton(
            child: const Icon(
              Icons.where_to_vote,
              size: 40,
            ),
            onPressed: () {
              mapController?.addSymbol(SymbolOptions(
                  geometry: center,
                  //iconImage: 'toilet-15',
                  iconImage: 'networkImage',
                  //iconSize: 2,
                  textOffset: const Offset(0, 2),
                  textField: 'Montaña creada aquí',
                  textColor: '#FF0000'));
              setState(() {});
            }),
        const SizedBox(
          height: 5,
        ),
        // ZoomIn
        FloatingActionButton(
            child: const Icon(
              Icons.zoom_in,
              size: 40,
            ),
            onPressed: () {
              mapController?.animateCamera(CameraUpdate.zoomIn());
              setState(() {});
            }),
        const SizedBox(
          height: 5,
        ),
        //ZoomOut
        FloatingActionButton(
            child: const Icon(
              Icons.zoom_out,
              size: 40,
            ),
            onPressed: () {
              mapController?.animateCamera(CameraUpdate.zoomOut());
              setState(() {});
            }),
        const SizedBox(
          height: 5,
        ),
        //Cambiar estilo
        FloatingActionButton(
            child: const Icon(
              Icons.map,
              size: 40,
            ),
            onPressed: () {
              if (_selectedStyle == oscuroStyle) {
                _selectedStyle = streetStyle;
              } else if (_selectedStyle == streetStyle) {
                _selectedStyle = sateliteStyle;
              } else if (_selectedStyle == sateliteStyle) {
                _selectedStyle = nuevoStyle;
              } else {
                _selectedStyle = oscuroStyle;
              }
              _onStyleLoaded();
              setState(() {});
            }),
      ],
    );
  }
}
