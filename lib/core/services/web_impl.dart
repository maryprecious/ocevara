import 'dart:html' as html;

class WebStorage {
  static String? get(String key) => html.window.localStorage[key];
  static void set(String key, String value) {
    html.window.localStorage[key] = value;
  }
}
