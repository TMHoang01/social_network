import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/service/review_service.dart';
import 'package:social_network/presentation/blocs/clients/service_detail/service_detail_bloc.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/utils.dart';

class ReviewFormScreen extends StatefulWidget {
  const ReviewFormScreen({super.key});

  @override
  State<ReviewFormScreen> createState() => _ReviewFormScreenState();
}

class _ReviewFormScreenState extends State<ReviewFormScreen> {
  double? rating;
  final controler = TextEditingController();

  @override
  void initState() {
    final myReview = context.read<ServiceDetailBloc>().state.myReview;
    rating = myReview?.rating ?? 0;
    controler.text = myReview?.comment ?? '';
    super.initState();
  }

  @override
  void dispose() {
    controler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Đánh giá dịch vụ'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              ListTile(
                // contentPadding: const EdgeInsets.all(0),
                leading: CustomImageView(
                  height: 44,
                  width: 44,
                  borderRadius: BorderRadius.circular(180),
                  url: userCurrent?.avatar ?? 'https://via.placeholder.com/150',
                ),
                title: Text(
                  userCurrent?.username ?? 'Ẩn danh',
                ),
                subtitle: Text(
                  userCurrent?.email ?? 'Ẩn danh',
                ),
              ),
              const SizedBox(height: 12),
              RatingStarIcon(
                isEdit: true,
                rating: rating,
                size: 40,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                onRatingUpdate: (value) {
                  rating = value;
                },
              ),
              const SizedBox(height: 4),
              CustomTextFormField(
                hintText: 'Mô tả trải nghiệm của bạn',
                controller: controler,
                maxLines: 5,
                maxLength: 500,
              ),
              const SizedBox(height: 8),
              CustomButton(
                onPressed: () {
                  ReviewService myreview = ReviewService(
                    rating: rating ?? 0,
                    comment: controler.text,
                  );
                  context.read<ServiceDetailBloc>().add(
                        ServiceDetailAddReviewSubmit(myreview),
                      );
                  navService.pop(context);
                },
                title: 'Gửi đánh giá',
              )
            ],
          ),
        ),
      ),
    );
  }
}
