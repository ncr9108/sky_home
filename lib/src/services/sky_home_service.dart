import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/home_config.dart';

/// The production API base URL for the SkyHome Shopify app.
const String kSkyHomeApiBaseUrl =
    'https://zonal-purpose-production-d272.up.railway.app';

class SkyHomeService {
  final String apiBaseUrl;
  final String shopDomain;
  final Duration timeout;
  final Map<String, String>? extraHeaders;

  SkyHomeService({
    this.apiBaseUrl = kSkyHomeApiBaseUrl,
    required this.shopDomain,
    this.timeout = const Duration(seconds: 10),
    this.extraHeaders,
  });

  /// Fetches the published home config for [shopDomain].
  /// Throws [SkyHomeException] on any network or server error.
  Future<HomeConfig> fetchHomeConfig() async {
    final base = apiBaseUrl.endsWith('/')
        ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
        : apiBaseUrl;

    final uri = Uri.parse('$base/api/home')
        .replace(queryParameters: {'shop': shopDomain});

    try {
      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
        ...?extraHeaders,
      }).timeout(timeout);

      // ── Happy path ──────────────────────────────────────────────────────
      if (response.statusCode == 200) {
        // Guard against HTML responses (e.g. Cloudflare error pages)
        final contentType = response.headers['content-type'] ?? '';
        if (!contentType.contains('application/json') &&
            !contentType.contains('text/json')) {
          // Try to extract a human-readable title from the HTML
          final htmlTitle = _extractHtmlTitle(response.body);
          throw SkyHomeException(
            htmlTitle != null
                ? 'Server returned HTML instead of JSON.\n$htmlTitle'
                : 'Server returned HTML instead of JSON. '
                    'Make sure your Shopify app is running.',
            statusCode: response.statusCode,
          );
        }

        try {
          final json = jsonDecode(response.body) as Map<String, dynamic>;
          return HomeConfig.fromJson(json);
        } catch (_) {
          throw const SkyHomeException(
            'Response was not valid JSON. '
            'Make sure your Shopify app is running and the API URL is correct.',
            statusCode: 200,
          );
        }
      }

      // ── Tunnel / gateway errors ─────────────────────────────────────────
      // Cloudflare returns 530 when the origin is down,
      // 502/503 when the app is starting up.
      if (response.statusCode == 530 ||
          response.statusCode == 502 ||
          response.statusCode == 503) {
        throw SkyHomeException(
          'Cannot reach your Shopify app (HTTP ${response.statusCode}).\n'
          'Make sure "npm run dev" is running in SkyHomeApp and the '
          'tunnel URL in Settings is up to date.',
          statusCode: response.statusCode,
        );
      }

      if (response.statusCode == 404) {
        throw SkyHomeException(
          'API endpoint not found (404).\n'
          'Check that the API Base URL is correct and has no trailing slash.',
          statusCode: 404,
        );
      }

      // ── Other errors — try to extract JSON error field ──────────────────
      String errorMessage =
          'Server returned ${response.statusCode}.';
      try {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['error'] != null) {
          errorMessage = json['error'].toString();
        }
      } catch (_) {
        // Not JSON — extract HTML title as fallback
        final title = _extractHtmlTitle(response.body);
        if (title != null) errorMessage += '\n$title';
      }

      throw SkyHomeException(errorMessage, statusCode: response.statusCode);
    } on SkyHomeException {
      rethrow;
    } on SocketException catch (e) {
      throw SkyHomeException(
        'No internet connection or server unreachable.\n${e.message}',
      );
    } on HttpException catch (e) {
      throw SkyHomeException('HTTP error: ${e.message}');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw SkyHomeException(
          'Request timed out after ${timeout.inSeconds}s.\n'
          'Make sure your Shopify app is running and the tunnel is active.',
        );
      }
      throw SkyHomeException('Network error: $e');
    }
  }

  /// Extracts the text content of the first <title> tag in [html].
  static String? _extractHtmlTitle(String html) {
    final match = RegExp(
      r'<title[^>]*>(.*?)<\/title>',
      caseSensitive: false,
      dotAll: true,
    ).firstMatch(html);
    final raw = match?.group(1)?.trim();
    if (raw == null || raw.isEmpty) return null;
    // Decode common HTML entities
    return raw
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&#39;', "'")
        .replaceAll('&quot;', '"');
  }
}

class SkyHomeException implements Exception {
  final String message;
  final int? statusCode;

  const SkyHomeException(this.message, {this.statusCode});

  @override
  String toString() => message; // No "SkyHomeException:" prefix for clean UI display
}
