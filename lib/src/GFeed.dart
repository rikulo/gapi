//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jun 21, 2012  02:40:30 PM
// Author: hernichen

/**
 * Bridge Dart to Google Feed JavaScript APIs; see
 * <https://developers.google.com/feed/> for details.
 */
class GFeed {
  String _url; //feed url
  String _version; //Feed module version
  Map _options; //options for loading the jsFeed module
  var jsFeed; //JavaScript Feed object

  /**
   * Prepare a Google Feed.
   * + [url] - the url of this Feed.
   * + [version] - the Google Feed API version to be loaded; default "1".
   * + [options] - special option when loading Google Feed API (used by Google Loader).
   */
  GFeed(String url, {String version : "1", Map options})
    : this._url = url,
      this._version = version,
      this._options = options;


  /** Load feed information in a Map via Future.then() method; null if failed.*/
  Future<Map> loadFeedInfo()
  => _loadModule()
        .chain((bool ok) => ok ? _load() : new Future.immediate(null));

  /** Release the feed if no longer used. */
  void release() {
    if (jsFeed != null)
      js.release(jsFeed);
  }

  //load Feed API module
  Future<bool> _loadModule() {
    Map options = _options != null ? new Map.from(_options) : new Map();
    options["nocss"] = true;
    return gLoader.load(GLoader.FEED, _version, options); //load Feed API
  }

  //load the specified Feed
  Future<Map> _load() {
    Completer cmpl = new Completer();
    js.scoped(() {
      if (jsFeed == null) {
        var feeds = js.context.google.feeds;
        jsFeed = new js.Proxy(feeds.Feed, [_url]);
        jsFeed.setResultFormat(feeds.Feed.XML_FORMAT);
        js.retain(jsFeed);
      }
      var callback = new js.Callback.once((xmldoc)
        => cmpl.complete(JSUtil.xmlNodeToDartMap(xmldoc.documentElement, new Map())));
      try {
        jsFeed.load(callback);
      } catch(ex) {
        return new Future.immediate(null);
      }
    });
    return cmpl.future;
  }
}
