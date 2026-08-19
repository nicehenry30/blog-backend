import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';

import '../../domain/entities/course.dart';
import '../../domain/entities/lesson.dart';

import '../bloc/education_bloc.dart';
import 'lesson_page.dart';

class CourseDetailsPage extends StatelessWidget {
  final Course course;

  const CourseDetailsPage({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<EducationBloc>()
        ..add(
          LoadCourseDetails(course.id),
        ),
      child: _CourseDetailsView(
        initialCourse: course,
      ),
    );
  }
}

class _CourseDetailsView extends StatelessWidget {
  final Course initialCourse;

  const _CourseDetailsView({
    required this.initialCourse,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(initialCourse.title),
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
                      LoadCourseDetails(
                        initialCourse.id,
                      ),
                    );
              },
            );
          }

          if (state is EducationCourseDetailsLoaded) {
            return _CourseDetailsContent(
              course: state.course,
            );
          }

          return _CourseDetailsContent(
            course: initialCourse,
          );
        },
      ),
    );
  }
}

// ============================================================================
// COURSE DETAILS CONTENT
// ============================================================================

class _CourseDetailsContent extends StatelessWidget {
  final Course course;

  const _CourseDetailsContent({
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final lessons = course.lessons;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Header

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
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.school_outlined,
                    size: 40,
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                  ),
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

                if (course.category != null &&
                    course.category!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    course.category!,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],

                if (course.level != null &&
                    course.level!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    course.level!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // About

          const Text(
            'About This Course',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            course.description ??
                'No description has been added for this course yet.',
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 24),

          // Course Statistics

          Row(
            children: [
              Expanded(
                child: _CourseStat(
                  icon: Icons.menu_book_outlined,
                  label: 'Lessons',
                  value: '${lessons.length}',
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _CourseStat(
                  icon: Icons.school_outlined,
                  label: 'Level',
                  value: course.level ?? 'Beginner',
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Lessons

          const Text(
            'Course Lessons',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          if (lessons.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 40,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No lessons available yet.',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else
            ...lessons.map(
              (lesson) => _LessonCard(
                lesson: lesson,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonPage(
                        lesson: lesson,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// LESSON CARD
// ============================================================================

class _LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;

  const _LessonCard({
    required this.lesson,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: CircleAvatar(
          child: Text(
            '${lesson.lessonOrder}',
          ),
        ),
        title: Text(
          lesson.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          lesson.videoUrl != null &&
                  lesson.videoUrl!.isNotEmpty
              ? 'Video tutorial available'
              : 'Lesson content',
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}

// ============================================================================
// COURSE STAT
// ============================================================================

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
          Icon(
            icon,
            size: 26,
          ),

          const SizedBox(height: 8),

          Text(
            value,
            textAlign: TextAlign.center,
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
              'Unable to load course',
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