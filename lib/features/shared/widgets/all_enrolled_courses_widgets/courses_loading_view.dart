import 'package:flutter/material.dart';

class CoursesLoadingView extends StatelessWidget {
  const CoursesLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (_, __) =>
          const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return const _LoadingCard();
      },
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE SHIMMER LINE
          Container(
            width: 180,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          const SizedBox(height: 12),

          /// SUBTITLE SHIMMER LINE
          Container(
            width: 120,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          const SizedBox(height: 20),

          /// BOTTOM ROW SHIMMER
          Row(
            children: [
              Container(
                width: 80,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const Spacer(),
              Container(
                width: 50,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// PROGRESS BAR SHIMMER
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}