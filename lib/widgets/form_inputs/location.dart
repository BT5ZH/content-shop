import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as geoloc;
import '../../models/location_data.dart';
import '../../models/content.dart';
import '../../global/global_config.dart';

class LocationInput extends StatefulWidget {
  final Function setLocation;
  final Content content;
  LocationInput(this.setLocation, this.content);
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  Uri _staticMapUri;
  LocationDataModel _locationData;
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressControl = TextEditingController();

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    if (widget.content != null) {
      _getStaticMap(widget.content.location.address, geocode: false);
    }
    // getStaticMap();
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void _getStaticMap(String address,
      {bool geocode = true, double lat, double lng}) async {
    print(address);
    if (address.isEmpty) {
      setState(() {
        _staticMapUri = null;
      });
      widget.setLocation(null);
      return;
    }
    if (geocode) {
      final Uri uir = Uri.https(
          'maps.googleapis.com', 'maps/api/geocode/json', {
        'address': address,
        'key': apiKey
      });
      final http.Response response = await http.get(uir);
      final decodedRes = json.decode(response.body);
      print(decodedRes);
      final formattedAddress = decodedRes['results'][0]['formatted_address'];
      final coords = decodedRes['results'][0]['geometry']['location'];
      _locationData = LocationDataModel(
          latitude: coords['lat'],
          longitude: coords['lng'],
          address: formattedAddress);
    } else if (lat == null && lng == null) {
      _locationData = widget.content.location;
    } else {
      _locationData =
          LocationDataModel(address: address, latitude: lat, longitude: lng);
    }

    print('=====${_locationData.latitude} =======${_locationData.longitude}');
    if (mounted) {
      final StaticMapProvider smap =
          StaticMapProvider('AIzaSyCGHfaQ1rQNMIlUA7r25tx1kSC1ptXxy1U');
      final Uri staticuri = smap.getStaticUriWithMarkers([
        Marker('position', 'Position', _locationData.latitude,
            _locationData.longitude)
      ],
          center: Location(_locationData.latitude, _locationData.longitude),
          width: 500,
          height: 300,
          maptype: StaticMapViewType.roadmap);
      widget.setLocation(_locationData);
      setState(() {
        _addressControl.text = _locationData.address;
        _staticMapUri = staticuri;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          focusNode: _addressInputFocusNode,
          controller: _addressControl,
          decoration: InputDecoration(labelText: '地址'),
          validator: (String value) {
            if (_locationData == null || value.isEmpty) {
              return 'No valid location found';
            }
          },
        ),
        SizedBox(
          height: 10.0,
        ),
        FlatButton(
          child: Text('定位'),
          onPressed: _getUserLocation,
        ),
        SizedBox(
          height: 10.0,
        ),
        // Image.network(_staticMapUri.toString()),
        _staticMapUri == null
            ? Container()
            : Image.network(_staticMapUri.toString()),
      ],
    );
  }

  void _updateLocation() {
    if (!_addressInputFocusNode.hasFocus) {
      _getStaticMap(_addressControl.text);
    }
  }

  void _getUserLocation() async {
    // var currentLocation = geoloc.Location;

    final location = geoloc.Location();
    try {
      final currentLocation = await location.getLocation();
      print(currentLocation);
      // final address =await _getAddress(currentLocation['latitude'], currentLocation['longitude']);
      final address = await _getAddress(
          currentLocation.latitude, currentLocation.longitude);
      _getStaticMap(address,
          geocode: false,
          lat: currentLocation.latitude,
          lng: currentLocation.longitude);
    } catch (error) {
      showDialog(
          context: context,
          builder: (
            BuildContext context,
          ) {
            return AlertDialog(
              title: Text('无法获取当前位置'),
              content: Text('请手动添加地理位置'),
              actions: <Widget>[
                FlatButton(
                  child: Text('确定'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

  Future<String> _getAddress(double lat, double lng) async {
    final Uri uir = Uri.https('maps.googleapis.com', 'maps/api/geocode/json', {
      'latlng': '${lat.toString()},${lng.toString()}',
      'key': 'AIzaSyCGHfaQ1rQNMIlUA7r25tx1kSC1ptXxy1U'
    });
    final http.Response response = await http.get(uir);
    final decodedRes = json.decode(response.body);
    print(decodedRes);
    final formattedAddress = decodedRes['results'][0]['formatted_address'];
    return formattedAddress;
  }
}
