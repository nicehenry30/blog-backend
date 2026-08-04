import 'package:flutter/material.dart';

import '../models/education_course.dart';
import 'course_details_page.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

 @override
Widget build(BuildContext context) {
  // Sample data - you would typically get this from a provider or API
  final List<EducationCourse> courses = [
    EducationCourse(
      title: 'Introduction to Trading',
      description:
          'Learn the fundamentals of trading, market structure, and order execution.',
      category: 'Basics',
      lessons: 12,
      progress: 0.6,
      isPremium: false,
      icon: Icons.trending_up,
    ),
    EducationCourse(
      title: 'Advanced Technical Analysis',
      description:
          'Master chart patterns, indicators, support and resistance, and price action.',
      category: 'Technical',
      lessons: 18,
      progress: 0.3,
      isPremium: true,
      icon: Icons.analytics_outlined,
    ),
    EducationCourse(
      title: 'Risk Management',
      description:
          'Learn how to protect your trading capital with professional risk management techniques.',
      category: 'Risk',
      lessons: 8,
      progress: 0.0,
      isPremium: false,
      icon: Icons.security,
    ),
  ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Education'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Course Section
            const _SectionHeader(title: 'Featured Course'),
            const SizedBox(height: 12),
            _FeaturedCourseCard(
              onTap: () {
                // Navigate to course details
              },
            ),
            const SizedBox(height: 24),

            // Categories Section
            const _SectionHeader(title: 'Categories'),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _CategoryCard(title: 'Basics', icon: Icons.school_outlined),
                  _CategoryCard(title: 'Technical', icon: Icons.analytics_outlined),
                  _CategoryCard(title: 'Risk', icon: Icons.security_outlined),
                  _CategoryCard(title: 'Psychology', icon: Icons.psychology_outlined),
                  _CategoryCard(title: 'Advanced', icon: Icons.trending_up_outlined),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // All Courses Section
            const _SectionHeader(title: 'All Courses'),
            const SizedBox(height: 12),
            ...courses.map((course) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CourseCard(
                course: course,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetailsPage(course: course),
                    ),
                  );
                },
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SECTION HEADER
// ============================================================================

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

// ============================================================================
// FEATURED COURSE CARD
// ============================================================================

class _FeaturedCourseCard extends StatelessWidget {
  final VoidCallback onTap;

  const _FeaturedCourseCard({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E3A8A),
                Color(0xFF2563EB),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.analytics_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'FEATURED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Master Technical Analysis',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Learn how to analyse price action and identify high-probability trading setups.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 6),
                  Text(
                    '18 Lessons',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CATEGORY CARD
// ============================================================================

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const _CategoryCard({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// COURSE CARD
// ============================================================================

class _CourseCard extends StatelessWidget {
  final EducationCourse course;
  final VoidCallback onTap;

  const _CourseCard({
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercentage = (course.progress * 100).round();

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  course.icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            course.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (course.isPremium)
                          const Icon(
                            Icons.lock_outline,
                            size: 18,
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      course.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${course.lessons} Lessons',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: course.progress,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$progressPercentage% Complete',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}