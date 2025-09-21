import 'dart:html' as html;

/// This is the implementation for the web platform.
/// It cleans the browser's URL bar after a successful authentication redirect.
void cleanUrlAfterAuth() {
  // This line uses dart:html and will only be compiled for the web.
  html.window.history.pushState(null, '', '/');
}