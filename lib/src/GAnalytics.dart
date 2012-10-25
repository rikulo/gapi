//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jul 5, 2012  11:11:13 AM
// Author: hernichen

/** Singleton Google Analytics */
GAnalytics gAnalytics = new GAnalytics._internal();

/**
 * Bridge Dart to Google Analytics JavaScript APIs;
 * see <https://developers.google.com/analytics/devguides/> for details.
 */
class GAnalytics {

  factory GAnalytics() => gAnalytics;

  GAnalytics._internal(){}

  /**
   * Push a List as a command with arguments to be executed by the Google
   * Analytics engine. It returns the number of commands that failed to execute.
   *
   * e.g. create the default tracker and start page tracking.
   *
   *     GAnalytics.push(['_setAccount', 'UA-65432-1']);
   *     GAnalytics.push(['_trackPageview']);
   *
   * e.g. track change event of Switch.
   *
   *     new Switch().on.change.add((event) {
   *        GAnalytics.push(['_trackEvent', 'switch1', 'change']);
   *        ... //handle the event
   *     });
   *
   * see <https://developers.google.com/analytics/devguides/> and
   * <https://developers.google.com/analytics/devguides/collection/gajs/methods/gaJSApi_gaq#_gaq.push>
   * for details.
   *
   * + [command] the command with arguments in the List to be executed by
   *   Analytics engine asynchronously.
   */
  int push(List command) {
    _initJSFunctions();
    return js.scoped(() => js.context._gaq.push(js.array(command)));
  }

  /**
   * Push a Function to be executed by the Google Analytics engine. This is
   * useful for calling the tracking APIs that return values.
   * It returns the number of function that failed to execute.
   *
   * e.g. builds a linker URL and sets the href property for the link.
   *
   *    GAnalytics.pushFunction(() {
   *      PageTracker tracker = GAnalytics.getTrackerByName(); //default tracker
   *      AnchorElement link = query('#mylink');
   *      link.href = tracker.getLinkerUrl("http://www.myiframe.com/");
   *    });
   *
   * see <https://developers.google.com/analytics/devguides/> and
   * <https://developers.google.com/analytics/devguides/collection/gajs/methods/gaJSApi_gaq#_gaq.push>
   * for details.
   *
   * + [fn] the function to be executed by Analytics engine asynchronously.
   */
  int pushFunction(Function fn) {
    _initJSFunctions();
    return js.scoped(() {
      var callback = new js.Callback.many(fn);
      return js.context._gaq.push(callback);
    });
  }

  /**
   * Set disable-tracking flag. After set to true, no tracking information of the spcified account
   * on this page would be sent to analytics server.
   *
   * + [account] tracking account
   * + [flag] optional boolean flag to disable the tracking of the specified account in this page; default to true.
   */
  void setDisableTracking(String account, [bool flag = true]) {
    _initJSFunctions();
    js.scoped(() => js.context['ga-disable-$account'] = flag);
  }

  /**
   * Create a tracker with the specified name.
   * + [account] tracking account
   * + [name] tracker name; if not given, default to empty string.
   */
  PageTracker createTracker(String account, [String name]) {
    _initJSFunctions();
    return new PageTracker._from(
        js.scoped(() => js.context._gat._createTracker(account, name)));
  }

  /**
   * Returns the tracker with the specified name. If no tracker with the specified name, a new
   * tracker will be created automatically.
   * + [name] tracker name; if not given, default to empty string.
   */
  PageTracker getTrackerByName([String name]) {
    _initJSFunctions();
    return new PageTracker._from(
        js.scoped(() => js.context._gat._getTrackerByName(name)));
  }

  static bool _initDone = false;
  static void _initJSFunctions() {
    if (_initDone) return;

    JSUtil.injectJavaScript('''
var _gaq = _gaq || [];
(function() {
  if (!window._gat) {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  }
})(); 
    ''', false);
    _initDone = true;
  }
}
