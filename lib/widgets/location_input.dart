import 'package:favorite_places/models/place.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onPickedLocation});

  final void Function(PlaceLocation location) onPickedLocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  var _isGettingLocation = false;
  var _isLocationFetched = false;
  var _isSettingLocation = false;
  double? _fetchedLatitude;
  double? _fetchedLongitude;
  PlaceLocation? _pickedLocation;
  List<Placemark>? newPlace;

  @override
  void initState() {
    super.initState();
    _fetchedLongitude = null;
    _fetchedLongitude = null;
    _pickedLocation = null;
    newPlace = null;
  }

  @override
  void dispose() {
    _pickedLocation = null;
    newPlace = null;
    super.dispose();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (mounted) {
      setState(() {
        _isGettingLocation = true;
      });
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final Position position = await Geolocator.getCurrentPosition();
    _fetchedLatitude = position.latitude;
    _fetchedLongitude = position.longitude;
    if (mounted) {
      setState(() {
        _isGettingLocation = false;
        _isLocationFetched = true;
      });
    }
    _pickedLocation = await fetchedLocation;
    if (_pickedLocation != null) {
      widget.onPickedLocation(_pickedLocation!);
    }
    return position;
  }

  Future<PlaceLocation> get fetchedLocation async {
    newPlace =
        await placemarkFromCoordinates(_fetchedLatitude!, _fetchedLongitude!);
    Placemark? placemark = newPlace?[0];
    return PlaceLocation(
        latitude: _fetchedLatitude!,
        longitude: _fetchedLongitude!,
        address:
            ('${placemark!.name}, ${placemark!.postalCode} ${placemark!.locality}, ${placemark!.country}'));
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No location chosen",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    if (_isSettingLocation) {
      print("Location je: ${_pickedLocation}");
      previewContent = OpenStreetMapSearchAndPick(
          locationPinTextStyle: TextStyle(fontSize: 0),
          buttonColor: Colors.blue,
          buttonText: 'Select Location',
          onPicked: (pickedData) {
            print(pickedData.address);
            String street = pickedData.address['road'];
            String houseNumber = pickedData.address['house_number'];
            String postCode = pickedData.address['postcode'];
            String city = pickedData.address['city'];
            String country = pickedData.address['country'];
            String formattedAddress = ('$street $houseNumber, $postCode $city, $country');
            _pickedLocation = PlaceLocation(
                latitude: pickedData.latLong.latitude,
                longitude: pickedData.latLong.longitude,
                address: formattedAddress);
            if (_pickedLocation != null) {
              widget.onPickedLocation(_pickedLocation!);
            }
          });
    }

    if (_isLocationFetched) {
      previewContent = FlutterMap(
          options: MapOptions(
              initialCenter: LatLng(_fetchedLatitude!, _fetchedLongitude!)),
          mapController: MapController(),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.favoritePlaces',
            ),
            RichAttributionWidget(attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () {},
              )
            ]),
            CurrentLocationLayer(),
          ]);
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                width: 1),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
              onPressed: _determinePosition,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Select on map'),
              onPressed: () {
                setState(() {
                  _pickedLocation = null;
                  _isGettingLocation = false;
                  _isLocationFetched = false;
                  _isSettingLocation = true;
                });
              },
            )
          ],
        ),
      ],
    );
  }
}
