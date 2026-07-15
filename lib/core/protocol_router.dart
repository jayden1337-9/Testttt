/// Handles routing for custom internal protocols.
class ProtocolRouter {
  static const String novaScheme = 'nova';
  static const String browserScheme = 'browser';
  static const String novafsScheme = 'novafs';

  String? route(Uri uri) {
    switch (uri.scheme) {
      case novaScheme:
        return '/nova/${uri.host}';
      case browserScheme:
        return '/browser/${uri.host}';
      case novafsScheme:
        return '/novafs/${uri.host}${uri.path}';
      default:
        return null;
    }
  }
}
