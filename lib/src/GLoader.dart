//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 20, 2012  10:30:28 AM
// Author: hernichen

/**
 * Bridge Dart to Google JavaScript APIs loader; see https://developers.google.com/loader/ for details.
 */

GLoader gLoader = new GLoader();

class GLoader {
  static const String _BASE_URI = "https://www.google.com/jsapi";

  //module names
  static const String MAPS = "maps";
  static const String SEARCH = "search";
  static const String FEED = "feeds";
  static const String EARTH = "earth";
  static const String VISUALIZATION = "visualization";
  static const String ORKUT = "orkut";
  static const String PICKER = "picker";

  static bool _loaderStatus; //null(not loaded), false(loading), true(loaded)

  /** Load Google JavaScript API module; see <https://developers.google.com/loader/#GoogleLoad> for details.
   * + [name] the module name
   * + [version] the module version
   * + [options] the options used in loading the module; can specify a *callback* function when module loaded.
   */
  Future<bool> load(String name, String version, [Map options]) {
    Future<bool> loader = _initGLoader();
    return loader.chain((ok) => ok ?
        _load(name, version, options) : new Future.immediate(false));
  }

  /** Load latitude/longitude of the calling client via Future.then(Map) method.
   * Note that this service sometimes return null value. In the Map with key:
   * + 'lat': return the latitude.
   * + 'lng': return the longitude.
   */
  Future<Map> loadIPLatLng() {
    Future<bool> loaded = _initGLoader();
    return loaded.chain((bool ok) {
      Map result = null;
      if (ok) {
        js.scoped(() {
          var google = js.context.google;
          if (google['loader'] != null && google.loader['ClientLocation'] != null)
            result = {'lat': google.loader.ClientLocation.latitude,
                      'lng': google.loader.ClientLocation.longitude};
        });
      }
      return new Future.immediate(result);
    });
  }

  Future<bool> _initGLoader() {
    if (_loaderStatus == null) {
      _loaderStatus = false; //change state to loading
      return _loadGLoader();
    }
    else if (!_loaderStatus) //is loading
      return _waitGLoaderReady();
    else //already loaded
      return new Future.immediate(true);
  }

  //Load the GLoader
  Future<bool> _loadGLoader() {
    //start loading
    JSUtil.injectJavaScriptSrc(_BASE_URI);

    //wait until loaded
    return _waitGLoaderReady();
  }

  //Wait the GLoader loaded and ready
  Future<bool> _waitGLoaderReady() {
    //check if loaded every 10 ms, wait total 180 seconds
    Future<bool> loader = JSUtil.doWhenReady(_readyGLoader, 10, 180000);
    return loader.chain((bool ok) {
      if (ok) {//loaded
        _loaderStatus = true;
    } else if (_loaderStatus != null) { //fail to load. Timeout!
        _loaderStatus = null;
        JSUtil.removeJavaScriptSrc(_BASE_URI);
      }
      return new Future.immediate(ok);
    });
  }

  //check whether the GLoader is ready
  bool _readyGLoader() {
    return js.scoped(()
      =>(js.context['google'] != null && js.context['google']['load'] != null));
  }

  Future<bool> _load(String name, String version, [Map options]) {
    options = options != null ? new Map.from(options) : new Map();
    var fn = options.remove('callback');
    Completer cmpl = new Completer();
    js.scoped(() {
      options['callback'] = new js.Callback.once(() {
        if (fn != null) fn();
        cmpl.complete(true);
      });
    });
    js.scoped(() {
      var opts = js.map(options);
      js.context.google.load(name, version, opts);
    });
    return cmpl.future;
  }
}
