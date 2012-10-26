//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jul 5, 2012  11:11:13 AM
// Author: hernichen

/**
 * Bridge Dart to Google Analytics JavaScript Object *Tracker*;
 * see <https://developers.google.com/analytics/devguides/> for details.
 *
 * This is used when you need to write function to push into analytics command queue.
 */
class PageTracker {
  var _tracker; //JavaScript object

  PageTracker._from(this._tracker);

  /** Release this PageTracker when no longer needed */
  void release() {
    if (_tracker != null)
      js.scoped(() => js.release(_tracker));
  }

  /** Returns the name of the tracker.
   *
   * e.g.
   *
   *     gAnalytics.pushFunction(() {
   *       PageTracker tracker = gAnalytics.getTrackerByName(); //default tracker
   *       String name = tracker.getName();
   *     });
   */
  String getName() => js.scoped(() => _tracker._getName());

  /** Returns the analytics account ID for this tracker.
   *
   * e.g.
   *
   *     gAnalytics.pushFunction(() {
   *       PageTracker tracker = gAnalytics.getTrackerByName(); //default tracker
   *       String account = tracker.getAccount();
   *     });
   */
  String getAccount() => js.scoped(() => _tracker._getAccount());

  /** Returns the analytics version
   *
   * e.g.
   *
   *     gAnalytics.pushFunction(() {
   *       PageTracker tracker = gAnalytics.getTrackerByName(); //default tracker
   *       String version = tracker.getVersion();
   *     });
   */
  String getVersion() => js.scoped(() => _tracker._getVersion());

  /** Returns visitor level custom variable value assigned for the specified
   * [index].
   *
   * e.g.
   *
   *     gAnalytics.pushFunction(() {
   *       PageTracker tracker = gAnalytics.getTrackerByName(); //default tracker
   *       String name = tracker.getVisitorCustomVar(1);
   *     });
   */
  String getVisitorCustomVar(int index)
  => js.scoped(() => _tracker._getVisitorCustomVar(index));

  /** Returns a string of all GATC cookie data from the initiating link by
   * appending it to the URL parameter.
   *
   * e.g.
   *
   *     gAnalytics.pushFunction(() {
   *       PageTracker tracker = gAnalytics.getTrackerByName(); //default tracker
   *       String linkerUrl = tracker.getLinkerUrl("http://www.myiframe.com/");
   *     });
   */
  String getLinkerUrl(String targetUrl, bool useHash)
  => js.scoped(() => _tracker._getLinkerUrl(targetUrl, useHash));

  /** Returns whether the browser tracking module is enabled.
   *
   * e.g.
   *
   *     gAnalytics.pushFunction(() {
   *       PageTracker tracker = gAnalytics.getTrackerByName(); //default tracker
   *       bool clientInfo = tracker.getClientInfo();
   *     });
   */
  bool getClientInfo() => js.scoped(() => _tracker._getClientInfo());

  /** Returns whether detect Flash.
   *
   * e.g.
   *
   *     gAnalytics.pushFunction(() {
   *       PageTracker tracker = gAnalytics.getTrackerByName(); //default tracker
   *       bool detectFlash = tracker.getDetectFlash();
   *     });
   */
  bool getDetectFlash() => js.scoped(() => _tracker._getDetectFlash());

  /** Returns whether detect title.
   *
   * e.g.
   *
   *     gAnalytics.pushFunction(() {
   *       PageTracker tracker = gAnalytics.getTrackerByName(); //default tracker
   *       bool dectectTitle = tracker.getDetectTitle();
   *     });
   */
  bool getDetectTitle() => js.scoped(() => _tracker._getDetectTitle());
}
