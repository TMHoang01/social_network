import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/resident/features/service/blocs/service_detail/service_detail_bloc.dart';
import 'package:social_network/presentation/resident/features/service/screens/services/widgets/widgets.dart';

class ReviewsServiceScreen extends StatelessWidget {
  const ReviewsServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá dịch vụ'),
      ),
      body: BlocBuilder<ServiceDetailBloc, ServiceDetailState>(
        buildWhen: (previous, current) =>
            previous.listReview != current.listReview,
        builder: (context, state) {
          if (state.status == ServiceDetailStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ServiceDetailStatus.failure) {
            return const Center(child: Text('Có lỗi xảy ra'));
          }
          final listtReview = state.listReview ?? [];
          if (listtReview.isEmpty) {
            return const Center(child: Text('Chưa có đánh giá nào'));
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listtReview.length,
                  itemBuilder: (context, index) {
                    final review = listtReview[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ReviewContentItem(
                        review: review,
                        onTapIcon: () {},
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
