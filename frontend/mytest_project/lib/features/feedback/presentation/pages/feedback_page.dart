import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/feedback.dart' as feedback_entity;
import '../bloc/feedback_bloc.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();

  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  String _category = 'general';

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<FeedbackBloc>().add(
          SubmitUserFeedback(
            category: _category,
            subject: _subjectController.text.trim(),
            message: _messageController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        centerTitle: true,
      ),
      body: BlocConsumer<FeedbackBloc, FeedbackState>(
        listener: (context, state) {
          if (state is FeedbackSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Feedback submitted successfully.',
                ),
              ),
            );

            _subjectController.clear();
            _messageController.clear();

            setState(() {
              _category = 'general';
            });

            context.read<FeedbackBloc>().add(
                  const LoadFeedback(),
                );
          }

          if (state is FeedbackFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          final isSubmitting =
              state is FeedbackSubmitting;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<FeedbackBloc>().add(
                    const LoadFeedback(),
                  );
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _buildSubmitCard(isSubmitting),

                const SizedBox(height: 28),

                const Text(
                  'My Feedback',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                _buildFeedbackHistory(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubmitCard(bool isSubmitting) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Send Feedback',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Tell us how we can improve Tradewisser.',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(
                    Icons.category_outlined,
                  ),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'general',
                    child: Text('General'),
                  ),
                  DropdownMenuItem(
                    value: 'bug',
                    child: Text('Bug Report'),
                  ),
                  DropdownMenuItem(
                    value: 'feature',
                    child: Text('Feature Request'),
                  ),
                  DropdownMenuItem(
                    value: 'support',
                    child: Text('Support'),
                  ),
                  DropdownMenuItem(
                    value: 'other',
                    child: Text('Other'),
                  ),
                ],
                onChanged: isSubmitting
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() {
                            _category = value;
                          });
                        }
                      },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _subjectController,
                enabled: !isSubmitting,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  hintText: 'What is your feedback about?',
                  prefixIcon: Icon(
                    Icons.subject_outlined,
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter a subject.';
                  }

                  if (value.trim().length < 3) {
                    return 'Subject is too short.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _messageController,
                enabled: !isSubmitting,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  hintText: 'Tell us what you think...',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 80),
                    child: Icon(
                      Icons.message_outlined,
                    ),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter your message.';
                  }

                  if (value.trim().length < 10) {
                    return 'Message must be at least 10 characters.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed:
                      isSubmitting ? null : _submitFeedback,
                  icon: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.send_outlined,
                        ),
                  label: Text(
                    isSubmitting
                        ? 'Submitting...'
                        : 'Submit Feedback',
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackHistory(
    FeedbackState state,
  ) {
    if (state is FeedbackLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state is FeedbackFailure) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(
                Icons.error_outline,
                size: 42,
              ),
              const SizedBox(height: 10),
              Text(
                state.message,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  context.read<FeedbackBloc>().add(
                        const LoadFeedback(),
                      );
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is FeedbackLoaded) {
      if (state.feedback.isEmpty) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.feedback_outlined,
                  size: 45,
                  color: Theme.of(context)
                      .colorScheme
                      .primary,
                ),
                const SizedBox(height: 12),
                const Text(
                  'No feedback yet.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Your submitted feedback will appear here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Column(
        children: state.feedback
            .map(
              (feedback) => _FeedbackCard(
                feedback: feedback,
              ),
            )
            .toList(),
      );
    }

    if (state is FeedbackSubmitted) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _FeedbackCard extends StatelessWidget {
  final feedback_entity.Feedback feedback;

  const _FeedbackCard({
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    final status = feedback.status.toString();

    final statusText = status.isEmpty
        ? 'Pending'
        : status[0].toUpperCase() +
            status.substring(1);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    feedback.subject,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _StatusChip(
                  status: statusText,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              feedback.message,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),

            if (feedback.hasReply) ...[
              const SizedBox(height: 14),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'Admin Reply',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                feedback.adminReply!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primary
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: Theme.of(context)
              .colorScheme
              .primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}