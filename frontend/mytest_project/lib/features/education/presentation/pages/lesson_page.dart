import 'package:flutter/material.dart';

import '../../domain/entities/lesson.dart';

class LessonPage extends StatelessWidget {
  final Lesson lesson;

  const LessonPage({
    super.key,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lesson header
            Text(
              'Lesson ${lesson.lessonOrder}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              lesson.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 20),

            // Video section
            _VideoSection(
              videoUrl: lesson.videoUrl,
            ),

            const SizedBox(height: 24),

            // Description
            const Text(
              'About This Lesson',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              lesson.description ??
                  'No description has been added for this lesson yet.',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                    height: 1.6,
                  ),
            ),

            const SizedBox(height: 32),

            // Completion button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.check_circle_outline,
                ),
                label: const Text(
                  'Mark as Completed',
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// VIDEO SECTION
// ============================================================================

class _VideoSection extends StatelessWidget {
  final String? videoUrl;

  const _VideoSection({
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (videoUrl == null || videoUrl!.isEmpty) {
      return Container(
        width: double.infinity,
        height: 210,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 52,
              color: Colors.grey,
            ),
            SizedBox(height: 12),
            Text(
              'Video tutorial not available',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.play_circle_fill,
            color: Colors.white,
            size: 70,
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 14,
            child: Text(
              videoUrl!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}