// import 'dart:async';
// import 'dart:io' show Platform;

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

// class GeolocatorWidget extends StatefulWidget {
//   const GeolocatorWidget({Key? key}) : super(key: key);

//   @override
//   _GeolocatorWidgetState createState() => _GeolocatorWidgetState();
// }

// class _GeolocatorWidgetState extends State<GeolocatorWidget> {
//   static const String _kLocationServicesDisabledMessage = 'Location services are disabled.';
//   static const String _kPermissionDeniedMessage = 'Permission denied.';
//   static const String _kPermissionDeniedForeverMessage = 'Permission denied forever.';
//   static const String _kPermissionGrantedMessage = 'Permission granted.';

//   final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
//   final List<_PositionItem> _positionItems = <_PositionItem>[];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: ListView.builder(
//         itemCount: _positionItems.length,
//         itemBuilder: (context, index) {
//           final positionItem = _positionItems[index];

//           if (positionItem.type == _PositionItemType.log) {
//             return ListTile(
//               title: GestureDetector(
//                 onTap: () {
//                   if (positionItem.displayValue == _kPermissionDeniedForeverMessage) {
//                     _openLocationSettings();
//                   }
//                 },
//                 child: Text(
//                   positionItem.displayValue,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),
//             );
//           } else {
//             return Card(
//               child: ListTile(
//                 title: Text(
//                   positionItem.displayValue,
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.my_location),
//         onPressed: _getCurrentPosition,
//       ),
//     );
//   }

//   Future<void> _getCurrentPosition() async {
//     final hasPermission = await _handlePermission();
//     if (!hasPermission) {
//       return;
//     }

//     final position = await _geolocatorPlatform.getCurrentPosition();
//     _updatePositionList(
//       _PositionItemType.position,
//       position.toString(),
//     );
//   }

//   Future<bool> _handlePermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//     serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       _updatePositionList(
//         _PositionItemType.log,
//         _kLocationServicesDisabledMessage,
//       );
//       return false;
//     }

//     permission = await _geolocatorPlatform.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await _geolocatorPlatform.requestPermission();
//       if (permission == LocationPermission.denied) {
//         _updatePositionList(
//           _PositionItemType.log,
//           _kPermissionDeniedMessage,
//         );
//         return false;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       _updatePositionList(
//         _PositionItemType.log,
//         _kPermissionDeniedForeverMessage,
//       );
//       return false;
//     }

//     _updatePositionList(
//       _PositionItemType.log,
//       _kPermissionGrantedMessage,
//     );
//     return true;
//   }

//   void _updatePositionList(_PositionItemType type, String displayValue) {
//     _positionItems.add(_PositionItem(type, displayValue));
//     setState(() {});
//   }

//   // void _openAppSettings() async {
//   //   final opened = await _geolocatorPlatform.openAppSettings();
//   //   String displayValue;

//   //   if (opened) {
//   //     displayValue = 'Opened Application Settings.';
//   //   } else {
//   //     displayValue = 'Error opening Application Settings.';
//   //   }

//   //   _updatePositionList(
//   //     _PositionItemType.log,
//   //     displayValue,
//   //   );
//   // }

//   void _openLocationSettings() async {
//     final opened = await _geolocatorPlatform.openLocationSettings();
//     String displayValue;

//     if (opened) {
//       displayValue = 'Opened Location Settings';
//     } else {
//       displayValue = 'Error opening Location Settings';
//     }

//     _updatePositionList(
//       _PositionItemType.log,
//       displayValue,
//     );
//   }
// }

// enum _PositionItemType {
//   log,
//   position,
// }

// class _PositionItem {
//   _PositionItem(this.type, this.displayValue);

//   final _PositionItemType type;
//   final String displayValue;
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeolocatorWidget extends StatefulWidget {
  const GeolocatorWidget({Key? key}) : super(key: key);

  @override
  _GeolocatorWidgetState createState() => _GeolocatorWidgetState();
}

class _GeolocatorWidgetState extends State<GeolocatorWidget> {
  static const String _kLocationServicesDisabledMessage = 'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied. Click here to open Location Settings.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  String _displayValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () async {
                  final opened = await _geolocatorPlatform.openLocationSettings();
                  String displayValue;

                  if (opened) {
                    displayValue = 'Opened Location Settings';
                  } else {
                    displayValue = 'Error opening Location Settings';
                  }

                  setState(() {
                    _displayValue = displayValue;
                  });
                },
                child: Text(
                  _displayValue,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Colors.blue, // Change color as needed
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.my_location),
        onPressed: _getCurrentPosition,
      ),
    );
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) {
      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    setState(() {
      _displayValue = 'Longitude: ${position.longitude}, Latitude: ${position.latitude}';
    });
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _displayValue = _kLocationServicesDisabledMessage;
      });
      return false;
    }

    // Request permission directly without checking the previous state
    permission = await _geolocatorPlatform.requestPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      setState(() {
        _displayValue = _kPermissionGrantedMessage;
      });
      return true;
    } else {
      setState(() {
        _displayValue = _kPermissionDeniedMessage;
      });
      return false;
    }
  }
}
