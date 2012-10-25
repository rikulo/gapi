import 'package:rikulo_gapi/rikulo_gapi.dart';

void main() {
  // Create a feed instance that will grab Digg's feed.
  GFeed feed = new GFeed("http://www.digg.com/rss/index.xml");

  // Retrieve feed information as a Map
  Future<Map> info = feed.loadFeedInfo();

  info.then((Map result) => print(result));
}
