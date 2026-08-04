import 'package:flutter/material.dart';

import '../../domain/entities/news.dart';

import 'countdown_timer.dart';
import 'impact_badge.dart';

class NewsCard extends StatelessWidget {
  final News news;

  final VoidCallback onTap;

  const NewsCard({
    super.key,
    required this.news,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      news.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  ImpactBadge(
                    impact: news.impactLevel,
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  const Icon(
                    Icons.public,
                    size: 18,
                  ),

                  const SizedBox(width: 6),

                  Text(news.country),

                  const Spacer(),

                  Text(
                    news.currency,
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              CountdownTimer(
                targetTime:
                    news.eventDateTime,
              ),

              const SizedBox(height: 14),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: news.affectedPairs
                    .map(
                      (pair) => Chip(
                        label: Text(pair),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 14),

              Align(
                alignment:
                    Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onTap,
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  label: const Text(
                    'View Details',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}