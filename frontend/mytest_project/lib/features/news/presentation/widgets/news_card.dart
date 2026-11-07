import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/news.dart';

class NewsCard extends StatelessWidget {
  final News news;
  final VoidCallback? onTap;

  const NewsCard({super.key, required this.news, this.onTap});

  Future<void> _openArticle() async {
    final uri = Uri.tryParse(news.url);

    if (uri == null) {
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? _openArticle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.imageUrl != null && news.imageUrl!.isNotEmpty)
              Image.network(
                news.imageUrl!,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink();
                },
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (news.source != null && news.source!.isNotEmpty)
                        Expanded(
                          child: Text(
                            news.source!,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      _buildSentimentBadge(context),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    news.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  if (news.description != null &&
                      news.description!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      news.description!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],

                  if (news.symbols.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: news.symbols
                          .map(
                            (symbol) => Chip(
                              label: Text(symbol),
                              visualDensity: VisualDensity.compact,
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 16),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          _formatPublishedAt(news.publishedAt),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _openArticle,
                        icon: const Icon(Icons.open_in_new, size: 16),
                        label: const Text('Read Article'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSentimentBadge(BuildContext context) {
    final sentiment = news.sentiment?.toLowerCase();

    String label;

    switch (sentiment) {
      case 'positive':
        label = 'Positive';
        break;
      case 'negative':
        label = 'Negative';
        break;
      default:
        label = 'Neutral';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  String _formatPublishedAt(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Publication time unavailable';
    }

    final local = dateTime.toLocal();

    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();

    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }
}
