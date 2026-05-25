# sky_home

A Flutter widget package for rendering dynamic home pages powered by the **SkyHome Shopify app**.

SkyHome lets Shopify merchants build and publish their mobile app's home page from the Shopify Admin — no code changes required. This package renders those sections automatically in your Flutter app.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  sky_home: ^0.1.0
```

Then run:

```bash
flutter pub get
```

---

## Usage

Only your Shopify store domain is required:

```dart
import 'package:sky_home/sky_home.dart';

SkyHomeWidget(
  shopDomain: 'my-shop.myshopify.com',
)
```

That's it. The widget automatically connects to the SkyHome backend and renders whatever sections the merchant has published.

---

## How it works

1. The merchant installs the **SkyHome** app from the Shopify App Store.
2. They design their home page (hero banners, featured collections, countdown timers, etc.) inside the Shopify Admin.
3. They hit **Publish**.
4. Your Flutter app renders the published layout instantly — no app update needed.

---

## Optional customisation

### Handle link taps

```dart
SkyHomeWidget(
  shopDomain: 'my-shop.myshopify.com',
  onLinkTap: (link) {
    // Navigate inside your app using your router
    context.go('/products/$link');
  },
)
```

### Custom product grid for Featured Collection sections

```dart
SkyHomeWidget(
  shopDomain: 'my-shop.myshopify.com',
  collectionBuilder: (context, section) {
    return MyProductGrid(
      collectionId: section.collectionId!,
      maxProducts: section.maxProducts ?? 6,
    );
  },
)
```

### Custom product card for Product Highlight sections

```dart
SkyHomeWidget(
  shopDomain: 'my-shop.myshopify.com',
  productHighlightBuilder: (context, section) {
    return MyProductCard(productId: section.collectionId!);
  },
)
```

### Loading and error states

```dart
SkyHomeWidget(
  shopDomain: 'my-shop.myshopify.com',
  loadingWidget: const MyShimmerPlaceholder(),
  errorBuilder: (context, error) {
    return Text('Could not load home page: $error');
  },
  emptyWidget: const SizedBox.shrink(), // hide when nothing published
)
```

---

## Supported section types

| Type | Description |
|---|---|
| `hero_banner` | Full-width image with title, subtitle and CTA button |
| `image_slider` | Auto-playing image carousel |
| `video_slider` | Video carousel |
| `featured_collection` | Product grid from a Shopify collection |
| `product_highlight` | Single featured product card |
| `promo_banner` | Promotional banner with background colour |
| `banner_grid` | 2-column image/video grid |
| `countdown_timer` | Countdown to a sale end date |
| `video_block` | Single embedded video |
| `testimonial` | Customer review carousel |
| `text_block` | Rich text content block |
| `announcement_bar` | Scrolling or static announcement strip |
| `category_tabs` | Horizontal category icon tabs |
| `flash_sale` | Flash sale block with timer |
| `app_exclusive_offer` | App-only offer highlight |
| `recently_viewed` | Recently viewed products (supply your own builder) |
| `instagram_feed` | Instagram feed placeholder |
| `store_locator` | Store location cards |
| `blog_articles` | Blog article cards |
| `faq` | Expandable FAQ list |

---

## Requirements

- Flutter ≥ 3.10.0
- Dart ≥ 3.0.0
- The **SkyHome** app must be installed on the merchant's Shopify store

---

## License

MIT
