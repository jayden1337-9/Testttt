import 'dart:convert';
import '../filesystem/local_novafs.dart';

/// Manages custom domain configurations (e.g., free subdomain providers).
class DomainProviderService {
  final LocalNovaFS _fs = LocalNovaFS();
  final String _configFile = 'novafs://Browser/domains.json';

  /// Returns a map of custom domains to their target URLs
  Future<Map<String, String>> getCustomDomains() async {
    try {
      if (!await _fs.exists(_configFile)) return {};
      final content = await _fs.read(_configFile);
      return Map<String, String>.from(jsonDecode(content));
    } catch (e) {
      return {};
    }
  }

  Future<void> addDomain(String domain, String targetUrl) async {
    final domains = await getCustomDomains();
    domains[domain] = targetUrl;
    await _fs.write(_configFile, jsonEncode(domains));
  }

  Future<void> removeDomain(String domain) async {
    final domains = await getCustomDomains();
    domains.remove(domain);
    await _fs.write(_configFile, jsonEncode(domains));
  }

  /// Resolves a URL if it matches a custom domain
  Future<String?> resolveUrl(String url) async {
    final domains = await getCustomDomains();
    for (var domain in domains.keys) {
      if (url.contains(domain)) {
        return domains[domain]; // Return the mapped target URL
      }
    }
    return null; // No match found
  }
}
