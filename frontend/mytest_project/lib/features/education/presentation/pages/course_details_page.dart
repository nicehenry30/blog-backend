import 'package:flutter/material.dart';

import '../models/education_course.dart';

class CourseDetailsPage extends StatelessWidget {
  final EducationCourse course;

  const CourseDetailsPage({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.08),
              ),
              child: Column(
                children: [
                  Icon(
                    course.icon,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    course.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.category,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'About This Course',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              course.description,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _CourseStat(
                    icon: Icons.menu_book_outlined,
                    label: 'Lessons',
                    value: '${course.lessons}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CourseStat(
                    icon: Icons.trending_up,
                    label: 'Progress',
                    value: '${(course.progress * 100).round()}%',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow),
                label: Text(
                  course.progress > 0
                      ? 'Continue Learning'
                      : 'Start Course',
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Course Lessons',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ...List.generate(
              course.lessons,
              (index) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text('Lesson ${index + 1}'),
                  subtitle: Text(
                    index == 0
                        ? 'Introduction to ${course.category}'
                        : 'Continue your ${course.title} learning',
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onTap: () {
                    // TODO: Open lesson page
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _CourseStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 26),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}