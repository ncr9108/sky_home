import 'package:flutter/material.dart';
import '../models/home_config.dart';
import '../models/home_section.dart';
import '../services/sky_home_service.dart'
    show SkyHomeService, kSkyHomeApiBaseUrl;
import 'sections/hero_banner.dart';
import 'sections/image_slider.dart';
import 'sections/video_slider.dart';
import 'sections/featured_collection.dart';
import 'sections/product_highlight.dart';
import 'sections/promo_banner.dart';
import 'sections/banner_grid.dart';
import 'sections/countdown_timer_section.dart';
import 'sections/video_block.dart';
import 'sections/testimonial_section.dart';
import 'sections/text_block.dart';
import 'sections/announcement_bar.dart';
import 'sections/category_tabs.dart';
import 'sections/flash_sale.dart';
import 'sections/app_exclusive_offer.dart';
import 'sections/recently_viewed.dart';
import 'sections/instagram_feed.dart';
import 'sections/store_locator.dart';
import 'sections/blog_articles.dart';
import 'sections/faq_section.dart';

/// Builds a custom section widget from a [HomeSection].
typedef SectionWidgetBuilder = Widget Function(
  BuildContext context,
  HomeSection section,
);

/// The main SkyHome widget. Drop it anywhere in your widget tree.
///
/// Minimal usage — only your Shopify store domain is required:
/// ```dart
/// SkyHomeWidget(
///   shopDomain: 'my-shop.myshopify.com',
/// )
/// ```
///
/// With optional customisation:
/// ```dart
/// SkyHomeWidget(
///   shopDomain: 'my-shop.myshopify.com',
///   onLinkTap: (link) => context.go('/products/$link'),
///   collectionBuilder: (ctx, section) => MyProductGrid(
///     collectionId: section.collectionId!,
///     maxProducts: section.maxProducts ?? 6,
///   ),
/// )
/// ```
class SkyHomeWidget extends StatefulWidget {
  /// Base URL of the SkyHome backend.
  /// Defaults to the production Railway URL — you do not need to set this.
  final String apiBaseUrl;

  /// The merchant's myshopify.com domain, e.g. "my-shop.myshopify.com".
  /// This is the only required parameter.
  final String shopDomain;

  /// Called when any CTA button or tappable link is tapped.
  /// If null, url_launcher opens the link in the default browser.
  final void Function(String link)? onLinkTap;

  /// Custom widget builder for featured_collection sections.
  /// Receive [section.collectionId], [section.collectionTitle], [section.maxProducts],
  /// and [section.displayStyle] to fetch products from your Storefront API.
  /// If null, a placeholder grid is shown.
  final SectionWidgetBuilder? collectionBuilder;

  /// Custom widget builder for product_highlight sections.
  /// If null, a simple product card is shown.
  final SectionWidgetBuilder? productHighlightBuilder;

  /// Custom widget builder for recently_viewed sections.
  /// Your app should track recently viewed product IDs and render product cards.
  /// If null, the section is silently hidden.
  final SectionWidgetBuilder? recentlyViewedBuilder;

  /// Widget shown while loading. Defaults to a centered [CircularProgressIndicator].
  final Widget? loadingWidget;

  /// Called when fetching fails. Return a widget to show, or null to hide silently.
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  /// Widget shown when the config is not published or has no sections.
  /// Defaults to [SizedBox.shrink] (invisible).
  final Widget? emptyWidget;

  /// How long to cache the home config before refetching. Default 30s.
  final Duration cacheDuration;

  const SkyHomeWidget({
    super.key,
    required this.shopDomain,
    this.apiBaseUrl = kSkyHomeApiBaseUrl,
    this.onLinkTap,
    this.collectionBuilder,
    this.productHighlightBuilder,
    this.recentlyViewedBuilder,
    this.loadingWidget,
    this.errorBuilder,
    this.emptyWidget,
    this.cacheDuration = const Duration(seconds: 30),
  });

  @override
  State<SkyHomeWidget> createState() => _SkyHomeWidgetState();
}

class _SkyHomeWidgetState extends State<SkyHomeWidget> {
  late SkyHomeService _service;
  late Future<HomeConfig> _future;

  @override
  void initState() {
    super.initState();
    _service = SkyHomeService(
      apiBaseUrl: widget.apiBaseUrl,
      shopDomain: widget.shopDomain,
    );
    _future = _service.fetchHomeConfig();
  }

  @override
  void didUpdateWidget(SkyHomeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.apiBaseUrl != widget.apiBaseUrl ||
        oldWidget.shopDomain != widget.shopDomain) {
      _service = SkyHomeService(
        apiBaseUrl: widget.apiBaseUrl,
        shopDomain: widget.shopDomain,
      );
      _future = _service.fetchHomeConfig();
    }
  }

  /// Re-fetches the home config from the server.
  void refresh() => setState(() {
        _future = _service.fetchHomeConfig();
      });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HomeConfig>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.loadingWidget ??
              const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          if (widget.errorBuilder != null) {
            return widget.errorBuilder!(context, snapshot.error!);
          }
          // Fail silently by default — don't break the host app's UI.
          return const SizedBox.shrink();
        }

        final config = snapshot.data!;

        if (!config.isPublished || config.sections.isEmpty) {
          return widget.emptyWidget ?? const SizedBox.shrink();
        }

        return _SkyHomeSections(
          sections: config.sections,
          onLinkTap: widget.onLinkTap,
          collectionBuilder: widget.collectionBuilder,
          productHighlightBuilder: widget.productHighlightBuilder,
          recentlyViewedBuilder: widget.recentlyViewedBuilder,
        );
      },
    );
  }
}

class _SkyHomeSections extends StatelessWidget {
  final List<HomeSection> sections;
  final void Function(String)? onLinkTap;
  final SectionWidgetBuilder? collectionBuilder;
  final SectionWidgetBuilder? productHighlightBuilder;
  final SectionWidgetBuilder? recentlyViewedBuilder;

  const _SkyHomeSections({
    required this.sections,
    this.onLinkTap,
    this.collectionBuilder,
    this.productHighlightBuilder,
    this.recentlyViewedBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: sections.map((s) => _buildSection(context, s)).toList(),
    );
  }

  Widget _buildSection(BuildContext context, HomeSection section) {
    switch (section.type) {
      case 'hero_banner':
        return HeroBannerSection(section: section, onLinkTap: onLinkTap);

      case 'image_slider':
        return ImageSliderSection(section: section, onLinkTap: onLinkTap);

      case 'video_slider':
        return VideoSliderSection(section: section, onLinkTap: onLinkTap);

      case 'featured_collection':
        if (collectionBuilder != null) {
          return collectionBuilder!(context, section);
        }
        return FeaturedCollectionSection(section: section, onLinkTap: onLinkTap);

      case 'product_highlight':
        if (productHighlightBuilder != null) {
          return productHighlightBuilder!(context, section);
        }
        return ProductHighlightSection(section: section, onLinkTap: onLinkTap);

      case 'promo_banner':
        return PromoBannerSection(section: section, onLinkTap: onLinkTap);

      case 'banner_grid':
        return BannerGridSection(section: section, onLinkTap: onLinkTap);

      case 'countdown_timer':
        return CountdownTimerSection(section: section, onLinkTap: onLinkTap);

      case 'video_block':
        return VideoBlockSection(section: section, onLinkTap: onLinkTap);

      case 'testimonial':
        return TestimonialSection(section: section);

      case 'text_block':
        return TextBlockSection(section: section, onLinkTap: onLinkTap);

      // ── New section types ──────────────────────────────────────────────────

      case 'announcement_bar':
        return AnnouncementBarSection(section: section, onLinkTap: onLinkTap);

      case 'category_tabs':
        return CategoryTabsSection(section: section, onLinkTap: onLinkTap);

      case 'flash_sale':
        return FlashSaleSection(section: section, onLinkTap: onLinkTap);

      case 'app_exclusive_offer':
        return AppExclusiveOfferSection(section: section, onLinkTap: onLinkTap);

      case 'recently_viewed':
        return RecentlyViewedSection(
          section: section,
          recentlyViewedBuilder: recentlyViewedBuilder,
          onLinkTap: onLinkTap,
        );

      case 'instagram_feed':
        return InstagramFeedSection(section: section, onLinkTap: onLinkTap);

      case 'store_locator':
        return StoreLocatorSection(section: section, onLinkTap: onLinkTap);

      case 'blog_articles':
        return BlogArticlesSection(section: section, onLinkTap: onLinkTap);

      case 'faq':
        return FaqSection(section: section);

      default:
        // Unknown section type — ignore gracefully.
        return const SizedBox.shrink();
    }
  }
}
