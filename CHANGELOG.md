## 0.1.1

* Fix README heading display name.
* Fix unused variable warning in promo_banner.dart.
* Fix unused import warning in sky_home_widget.dart.

## 0.1.0

* Initial release.
* `SkyHomeWidget` — renders published SkyHome sections for any Shopify store.
* Only `shopDomain` is required; backend URL is pre-configured.
* Supports 19 section types: hero_banner, image_slider, video_slider, featured_collection, product_highlight, promo_banner, banner_grid, countdown_timer, video_block, testimonial, text_block, announcement_bar, category_tabs, flash_sale, app_exclusive_offer, recently_viewed, instagram_feed, store_locator, blog_articles, faq.
* Optional `collectionBuilder`, `productHighlightBuilder`, `recentlyViewedBuilder` callbacks for custom product UIs.
* Graceful error handling — fails silently by default so host app UI is never broken.
