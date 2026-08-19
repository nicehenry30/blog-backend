import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/course.dart';
import '../bloc/education_bloc.dart';
import 'course_details_page.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  @override
  void initState() {
    super.initState();

    context.read<EducationBloc>().add(
          LoadCourses(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Education'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<EducationBloc, EducationState>(
        builder: (context, state) {
          if (state is EducationLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is EducationFailure) {
            return _ErrorView(
              message: state.message,
              onRetry: () {
                context.read<EducationBloc>().add(
                      LoadCourses(),
                    );
              },
            );
          }

          if (state is EducationLoaded) {
            return _EducationContent(
              courses: state.courses,
            );
          }

          return const Center(
            child: Text(
              'No courses available.',
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// EDUCATION CONTENT
// ============================================================================

class _EducationContent extends StatelessWidget {
  final List<Course> courses;

  const _EducationContent({
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const Center(
        child: Text(
          'No courses available yet.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    final featuredCourse = courses.first;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<EducationBloc>().add(
              LoadCourses(),
            );
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Course
            const _SectionHeader(
              title: 'Featured Course',
            ),

            const SizedBox(height: 12),

            _FeaturedCourseCard(
              course: featuredCourse,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CourseDetailsPage(
                      course: featuredCourse,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Categories
            const _SectionHeader(
              title: 'Categories',
            ),

            const SizedBox(height: 12),

            _Categories(courses: courses),

            const SizedBox(height: 24),

            // All Courses
            const _SectionHeader(
              title: 'All Courses',
            ),

            const SizedBox(height: 12),

            ...courses.map(
              (course) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: _CourseCard(
                  course: course,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetailsPage(
                          course: course,
                        ),
                      ),
                    );
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
// FEATURED COURSE
// ============================================================================

class _FeaturedCourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const _FeaturedCourseCard({
    required this.course,
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
                      color: Colors.white.withValues(
                        alpha: 0.15,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.school_outlined,
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
                      color: Colors.white.withValues(
                        alpha: 0.15,
                      ),
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

              Text(
                course.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                course.description ??
                    'Learn the fundamentals of trading.',
                style: TextStyle(
                  color: Colors.white.withValues(
                    alpha: 0.85,
                  ),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  const Icon(
                    Icons.menu_book_outlined,
                    color: Colors.white,
                    size: 18,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    '${course.lessons.length} Lessons',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Spacer(),

                  const Icon(
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
// CATEGORIES
// ============================================================================

class _Categories extends StatelessWidget {
  final List<Course> courses;

  const _Categories({
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    final categories = courses
        .map((course) => course.category)
        .whereType<String>()
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList();

    if (categories.isEmpty) {
      return const Text(
        'Categories will appear here as courses are added.',
        style: TextStyle(
          color: Colors.grey,
        ),
      );
    }

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _CategoryCard(
            title: categories[index],
            icon: _categoryIcon(
              categories[index],
            ),
          );
        },
      ),
    );
  }

  IconData _categoryIcon(String category) {
    final value = category.toLowerCase();

    if (value.contains('technical')) {
      return Icons.analytics_outlined;
    }

    if (value.contains('risk')) {
      return Icons.security_outlined;
    }

    if (value.contains('psychology')) {
      return Icons.psychology_outlined;
    }

    if (value.contains('advanced')) {
      return Icons.trending_up_outlined;
    }

    return Icons.school_outlined;
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
      margin: const EdgeInsets.only(
        right: 12,
      ),
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
            color: Theme.of(context)
                .colorScheme
                .primary,
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
  final Course course;
  final VoidCallback onTap;

  const _CourseCard({
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.school_outlined,
                  color: Theme.of(context)
                      .colorScheme
                      .primary,
                  size: 28,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      course.level ?? 'Beginner',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '${course.lessons.length} Lessons',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    if (course.description != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        course.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// ERROR VIEW
// ============================================================================

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),

            const SizedBox(height: 16),

            const Text(
              'Unable to load courses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}