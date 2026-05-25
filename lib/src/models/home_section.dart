import 'dart:convert';

/// A single banner in a banner_grid section.
class BannerItem {
  final String mediaUrl;
  final String mediaType; // 'image' | 'video'
  final String? title;
  final bool showTitle;
  final String? link;

  const BannerItem({
    required this.mediaUrl,
    this.mediaType = 'image',
    this.title,
    this.showTitle = true,
    this.link,
  });

  bool get isVideo => mediaType == 'video';
}

/// A single slide in an image_slider section.
class SlideItem {
  final String url;
  final String? title;
  final String? link;
  const SlideItem({required this.url, this.title, this.link});
}

/// A single video in a video_slider section.
class VideoItem {
  final String url;
  final String? thumbnail;
  final String? title;
  final String? link;
  const VideoItem({required this.url, this.thumbnail, this.title, this.link});
}

class HomeSection {
  final String id;
  final String type;
  final int sortOrder;
  final bool isEnabled;
  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final String? buttonText;
  final String? buttonLink;
  final String? collectionId;
  final String? collectionTitle;
  final int? maxProducts;
  final String? displayStyle;
  final DateTime? countdownEnd;
  final String? countdownLabel;
  final String? bodyText;
  final String bgColor;
  final String textColor;

  /// Products injected server-side for featured_collection and product_highlight.
  /// Empty list if the section type doesn't need products or fetch failed.
  final List<ProductItem> products;

  const HomeSection({
    required this.id,
    required this.type,
    required this.sortOrder,
    required this.isEnabled,
    this.title,
    this.subtitle,
    this.imageUrl,
    this.buttonText,
    this.buttonLink,
    this.collectionId,
    this.collectionTitle,
    this.maxProducts,
    this.displayStyle,
    this.countdownEnd,
    this.countdownLabel,
    this.bodyText,
    this.bgColor = '#FFFFFF',
    this.textColor = '#000000',
    this.products = const [],
  });

  factory HomeSection.fromJson(Map<String, dynamic> json) {
    return HomeSection(
      id: json['id'] as String,
      type: json['type'] as String,
      sortOrder: json['sortOrder'] as int,
      isEnabled: json['isEnabled'] as bool? ?? true,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      imageUrl: json['imageUrl'] as String?,
      buttonText: json['buttonText'] as String?,
      buttonLink: json['buttonLink'] as String?,
      collectionId: json['collectionId'] as String?,
      collectionTitle: json['collectionTitle'] as String?,
      maxProducts: json['maxProducts'] as int?,
      displayStyle: json['displayStyle'] as String?,
      countdownEnd: json['countdownEnd'] != null
          ? DateTime.tryParse(json['countdownEnd'] as String)
          : null,
      countdownLabel: json['countdownLabel'] as String?,
      bodyText: json['bodyText'] as String?,
      bgColor: json['bgColor'] as String? ?? '#FFFFFF',
      textColor: json['textColor'] as String? ?? '#000000',
      products: (json['products'] as List<dynamic>? ?? [])
          .map((p) => ProductItem.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Parses bodyText as a JSON list. Returns [] on failure.
  List<dynamic> get _bodyList {
    if (bodyText == null || bodyText!.isEmpty) return [];
    try {
      return jsonDecode(bodyText!) as List<dynamic>;
    } catch (_) {
      return [];
    }
  }

  /// For image_slider — list of slide objects {url, title?, link?}.
  /// Supports old format (array of strings) gracefully.
  List<SlideItem> get slides {
    return _bodyList.map((item) {
      if (item is String) return SlideItem(url: item);
      if (item is Map<String, dynamic>) {
        return SlideItem(
          url: item['url'] as String? ?? '',
          title: item['title'] as String?,
          link: item['link'] as String?,
        );
      }
      return SlideItem(url: '');
    }).toList();
  }

  /// For video_slider — list of video objects {url, thumbnail?, title?, link?}.
  List<VideoItem> get videoSlides {
    return _bodyList.map((item) {
      if (item is String) return VideoItem(url: item);
      if (item is Map<String, dynamic>) {
        return VideoItem(
          url: item['url'] as String? ?? '',
          thumbnail: item['thumbnail'] as String?,
          title: item['title'] as String?,
          link: item['link'] as String?,
        );
      }
      return VideoItem(url: '');
    }).toList();
  }

  /// For banner_grid — typed list of [BannerItem].
  /// Supports old format {imageUrl} and new format {mediaUrl, mediaType, showTitle}.
  List<BannerItem> get bannerItems {
    return _bodyList.map((item) {
      if (item is! Map<String, dynamic>) return BannerItem(mediaUrl: '');
      // backward-compat: old format used imageUrl
      final url = (item['mediaUrl'] ?? item['imageUrl'] ?? '') as String;
      return BannerItem(
        mediaUrl: url,
        mediaType: item['mediaType'] as String? ?? 'image',
        title: item['title'] as String?,
        showTitle: item['showTitle'] as bool? ?? true,
        link: item['link'] as String?,
      );
    }).toList();
  }

  /// For testimonial — list of {name, rating, text, avatar} maps.
  List<Map<String, dynamic>> get reviews =>
      _bodyList.whereType<Map<String, dynamic>>().toList();

  /// For category_tabs — list of [CategoryItem].
  List<CategoryItem> get categoryItems {
    return _bodyList.map((item) {
      if (item is! Map<String, dynamic>) return CategoryItem(title: '');
      return CategoryItem(
        imageUrl: item['imageUrl'] as String?,
        title: item['title'] as String? ?? '',
        link: item['link'] as String?,
      );
    }).toList();
  }

  /// For store_locator — list of [StoreItem].
  List<StoreItem> get storeItems {
    return _bodyList.map((item) {
      if (item is! Map<String, dynamic>) return StoreItem(name: '');
      return StoreItem(
        name: item['name'] as String? ?? '',
        address: item['address'] as String?,
        phone: item['phone'] as String?,
        hours: item['hours'] as String?,
        mapLink: item['mapLink'] as String?,
      );
    }).toList();
  }

  /// For blog/articles — list of [ArticleItem].
  List<ArticleItem> get articleItems {
    return _bodyList.map((item) {
      if (item is! Map<String, dynamic>) return ArticleItem(title: '');
      return ArticleItem(
        imageUrl: item['imageUrl'] as String?,
        title: item['title'] as String? ?? '',
        excerpt: item['excerpt'] as String?,
        link: item['link'] as String?,
        date: item['date'] as String?,
      );
    }).toList();
  }

  /// For faq — list of [FaqItem].
  List<FaqItem> get faqItems {
    return _bodyList.map((item) {
      if (item is! Map<String, dynamic>) return FaqItem(question: '');
      return FaqItem(
        question: item['question'] as String? ?? '',
        answer: item['answer'] as String? ?? '',
      );
    }).toList();
  }

  /// For announcement_bar — parsed extra options from bodyText JSON object.
  /// bodyText may be `{"marquee": true}` or a list (old style string).
  bool get announcementMarquee {
    if (bodyText == null || bodyText!.isEmpty) return false;
    try {
      final decoded = jsonDecode(bodyText!);
      if (decoded is Map<String, dynamic>) {
        return decoded['marquee'] as bool? ?? false;
      }
    } catch (_) {}
    return false;
  }

  /// For flash_sale — parsed fields from bodyText JSON object.
  Map<String, String> get flashSaleData {
    if (bodyText == null || bodyText!.isEmpty) return {};
    try {
      final decoded = jsonDecode(bodyText!);
      if (decoded is Map<String, dynamic>) {
        return decoded.map((k, v) => MapEntry(k, v?.toString() ?? ''));
      }
    } catch (_) {}
    return {};
  }

  /// For instagram_feed — parsed fields from bodyText JSON object.
  Map<String, dynamic> get instagramData {
    if (bodyText == null || bodyText!.isEmpty) return {};
    try {
      final decoded = jsonDecode(bodyText!);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return {};
  }
}

// ── New model classes ─────────────────────────────────────────────────────────

class CategoryItem {
  final String? imageUrl;
  final String title;
  final String? link;
  const CategoryItem({this.imageUrl, required this.title, this.link});
}

class StoreItem {
  final String name;
  final String? address;
  final String? phone;
  final String? hours;
  final String? mapLink;
  const StoreItem({
    required this.name,
    this.address,
    this.phone,
    this.hours,
    this.mapLink,
  });
}

class ArticleItem {
  final String? imageUrl;
  final String title;
  final String? excerpt;
  final String? link;
  final String? date;
  const ArticleItem({
    this.imageUrl,
    required this.title,
    this.excerpt,
    this.link,
    this.date,
  });
}

class FaqItem {
  final String question;
  final String answer;
  const FaqItem({required this.question, this.answer = ''});
}

// ── Product item — injected by the SkyHome backend ───────────────────────────

class ProductItem {
  final String id;
  final String title;
  final String? imageUrl;
  final String? price;
  final String? currencyCode;

  const ProductItem({
    required this.id,
    required this.title,
    this.imageUrl,
    this.price,
    this.currencyCode,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      price: json['price'] as String?,
      currencyCode: json['currencyCode'] as String?,
    );
  }

  /// e.g. "₹499.00"
  String get formattedPrice {
    if (price == null || price!.isEmpty) return '';
    final num = double.tryParse(price!);
    if (num == null) return '';
    return '${_symbol(currencyCode ?? '')}${num.toStringAsFixed(2)}';
  }

  static String _symbol(String code) {
    switch (code.toUpperCase()) {
      case 'USD': return '\$';
      case 'EUR': return '€';
      case 'GBP': return '£';
      case 'INR': return '₹';
      case 'CAD': return 'CA\$';
      case 'AUD': return 'A\$';
      case 'JPY': return '¥';
      default: return '$code ';
    }
  }
}
