import 'package:cinema_application/data/helpers/sharedprefsutil.dart';

class LocationServices {
  final sharedprefsutil = Sharedprefsutil();
  
  static const String _locationKey = 'currentLocation';

  Future<void> saveLocation(String location) async {
    await sharedprefsutil.saveString(_locationKey, location);
  }

  Future<String> getLocation() async {
    return await sharedprefsutil.getString(_locationKey) ?? '          ';
  }
}
