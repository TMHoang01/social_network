import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/resident/features/service/blocs/service_detail/service_detail_bloc.dart';
import 'package:social_network/presentation/resident/features/service/screens/services/widgets/widgets.dart';

class ReviewsServiceScreen extends StatefulWidget {
  const ReviewsServiceScreen({super.key});

  @override
  State<ReviewsServiceScreen> createState() => _ReviewsServiceScreenState();
}

class _ReviewsServiceScreenState extends State<ReviewsServiceScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadMoreReview();
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      final isLoadMoreEnd =
          context.read<ServiceDetailBloc>().state.isLoadMoreEnd ?? false;
      if (maxScroll - currentScroll < 200 && !isLoadMoreEnd) {
        loadMoreReview();
      }
    });
  }

  loadMoreReview() {
    context.read<ServiceDetailBloc>().add(ServiceDetailLoadMoreReview());
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá dịch vụ'),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.delayed(const Duration(seconds: 1), () {
          context.read<ServiceDetailBloc>().add(ServiceDetailRefreshReview());
        }),
        child: BlocBuilder<ServiceDetailBloc, ServiceDetailState>(
          buildWhen: (previous, current) =>
              previous.listReview != current.listReview,
          builder: (context, state) {
            if (state.status == ServiceDetailStatus.loadmore) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == ServiceDetailStatus.failure) {
              return const Center(child: Text('Có lỗi xảy ra'));
            }
            final listtReview = state.listReview ?? [];
            if (listtReview.isEmpty) {
              return const Center(child: Text('Chưa có đánh giá nào'));
            }
            final bottom = state.status == ServiceDetailStatus.loadmore
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    child: Text('s'),
                  );
            return SingleChildScrollView(
              controller: scrollController,
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
                  bottom,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
