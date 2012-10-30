import 'package:rikulo_gapi/gloader.dart';

void main() {
  gLoader.loadIPLatLng()
    .then((Map result) => print("lat: ${result['lat']}, lng: ${result['lng']}"));

  gLoader.load(GLoader.FEED, "1", {"callback": ()=>print("Feed loaded")});
}