import 'package:flutter/material.dart';
import 'package:sky_home/sky_home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ─── Configuration ────────────────────────────────────────────────────────────
  // Only your Shopify store domain is needed. The backend URL is pre-configured.
  static const String kShopDomain = 'your-store.myshopify.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SingleChildScrollView(
        child: SkyHomeWidget(
          shopDomain: kShopDomain,

          // ── Link handler ─────────────────────────────────────────────────────
          // Handle navigation yourself, or leave null to open in browser.
          onLinkTap: (link) {
            debugPrint('Navigate to: $link');
            // e.g. GoRouter: context.push('/collections/$link');
          },

          // ── Featured collection ───────────────────────────────────────────────
          // Supply your own Storefront API product grid here.
          // The section gives you: collectionId, collectionTitle, maxProducts, displayStyle.
          collectionBuilder: (ctx, section) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.collectionTitle ?? 'Collection',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Replace with your real product grid widget:
                  Text(
                    'Load products from collectionId: ${section.collectionId}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          },

          // ── Loading state ─────────────────────────────────────────────────────
          loadingWidget: const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ),
          ),

          // ── Error state ───────────────────────────────────────────────────────
          // If null, errors are swallowed silently (recommended for production).
          errorBuilder: (ctx, error) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Could not load home: $error',
                style: const TextStyle(color: Colors.red),
              ),
            );
          },
        ),
      ),
    );
  }
}
