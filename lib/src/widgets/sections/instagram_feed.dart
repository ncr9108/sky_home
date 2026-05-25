import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/home_section.dart';
import '../../utils/section_utils.dart';

/// Instagram Feed section.
///
/// Fetches posts from the Instagram Basic Display API using the
/// [accessToken] stored in [section.instagramData].
/// Falls back to a placeholder grid if the token is missing or the
/// request fails.
///
/// API doc: https://developers.facebook.com/docs/instagram-basic-display-api/reference/media
class InstagramFeedSection extends StatefulWidget {
  final HomeSection section;
  final void Function(String)? onLinkTap;

  const InstagramFeedSection({
    super.key,
    required this.section,
    this.onLinkTap,
  });

  @override
  State<InstagramFeedSection> createState() => _InstagramFeedSectionState();
}

class _InstagramFeedSectionState extends State<InstagramFeedSection> {
  List<_IgPost> _posts = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final data = widget.section.instagramData;
    final token = data['accessToken'] as String?;
    final count = (data['count'] as num?)?.toInt() ?? 6;

    if (token == null || token.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'No access token configured.';
      });
      return;
    }

    try {
      final uri = Uri.parse(
        'https://graph.instagram.com/me/media'
        '?fields=id,media_type,thumbnail_url,media_url,permalink'
        '&limit=$count'
        '&access_token=$token',
      );
      final res = await http.get(uri).timeout(const Duration(seconds: 8));
      if (!mounted) return;
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final list = (body['data'] as List<dynamic>?) ?? [];
        setState(() {
          _posts = list.map((item) {
            final map = item as Map<String, dynamic>;
            final type = map['media_type'] as String? ?? 'IMAGE';
            final isVideo = type == 'VIDEO';
            final imgUrl = isVideo
                ? (map['thumbnail_url'] as String?)
                : (map['media_url'] as String?);
            return _IgPost(
              imageUrl: imgUrl ?? '',
              permalink: map['permalink'] as String? ?? '',
              isVideo: isVideo,
            );
          }).toList();
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
          _error = 'Failed to load posts (${res.statusCode}).';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Could not reach Instagram.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.section.instagramData;
    final username = data['username'] as String? ?? '';
    final columns = (data['columns'] as num?)?.toInt() ?? 3;
    final bg = hexColor(widget.section.bgColor);
    final fg = hexColor(widget.section.textColor, fallback: Colors.black);

    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                const Icon(Icons.camera_alt_outlined, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.section.title?.isNotEmpty == true
                        ? widget.section.title!
                        : (username.isNotEmpty ? username : 'Instagram'),
                    style: TextStyle(
                      color: fg,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (_error != null || _posts.isEmpty)
            _PlaceholderGrid(columns: columns, bg: bg)
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 2),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                childAspectRatio: 1,
              ),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return GestureDetector(
                  onTap: () => openLink(post.permalink, widget.onLinkTap),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      netImage(post.imageUrl, fit: BoxFit.cover),
                      if (post.isVideo)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Icon(Icons.play_circle_outline,
                              color: Colors.white.withOpacity(0.85), size: 20),
                        ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _IgPost {
  final String imageUrl;
  final String permalink;
  final bool isVideo;
  const _IgPost({
    required this.imageUrl,
    required this.permalink,
    this.isVideo = false,
  });
}

/// Shown while loading or on error — a grid of grey boxes.
class _PlaceholderGrid extends StatelessWidget {
  final int columns;
  final Color bg;
  const _PlaceholderGrid({required this.columns, required this.bg});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 2),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 1,
      ),
      itemCount: columns * 2,
      itemBuilder: (_, __) => Container(
        color: Colors.grey[200],
        child: Center(
          child: Icon(Icons.image_outlined, color: Colors.grey[400]),
        ),
      ),
    );
  }
}
