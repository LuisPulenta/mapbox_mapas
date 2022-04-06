import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;

class FullScreenMap extends StatefulWidget {
  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  MapboxMapController? mapController;

  String _selectedStyle = 'mapbox://styles/luiscba2/cl1nm4ozx002c15p0u1n97fsu';
  final oscuroStyle = 'mapbox://styles/luiscba2/cl1nm1d4y002b15p0dzxryoul';
  final streetStyle = 'mapbox://styles/luiscba2/cl1nm4ozx002c15p0u1n97fsu';
  LatLng center = const LatLng(37.810575, -122.477174);

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }

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

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        styleString: _selectedStyle,
        accessToken:
            'sk.eyJ1IjoibHVpc2NiYTIiLCJhIjoiY2wxbmw1cHo1MDM4dDNkcXBwbTRwbGIyciJ9.j142IdXVQmM14o3rxF7ZQg',
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
            target: LatLng(37.810575, -122.477174), zoom: 14),
      ),
      floatingActionButton: botonesFlotantes(),
    );
  }

  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Símbolos
        FloatingActionButton(
            child: Icon(Icons.where_to_vote),
            onPressed: () {
              mapController?.addSymbol(SymbolOptions(
                  geometry: center,
                  //iconImage: 'toilet-15',
                  iconImage: 'networkImage',
                  //iconSize: 3,
                  textOffset: Offset(0, 2),
                  textField: 'Montaña creada aquí',
                  textColor: '#FF0000'));
              setState(() {});
            }),
        // ZoomIn
        FloatingActionButton(
            child: Icon(Icons.zoom_in),
            onPressed: () {
              mapController?.animateCamera(CameraUpdate.zoomIn());
              setState(() {});
            }),

        //ZoomOut
        FloatingActionButton(
            child: Icon(Icons.zoom_out),
            onPressed: () {
              mapController?.animateCamera(CameraUpdate.zoomOut());
              setState(() {});
            }),

        //Cambiar estilo
        FloatingActionButton(
            child: Icon(Icons.map),
            onPressed: () {
              if (_selectedStyle == oscuroStyle) {
                _selectedStyle = streetStyle;
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
