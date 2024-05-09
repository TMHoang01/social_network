import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:social_network/presentation/blocs/clients/my_feed_back/my_feed_back_bloc.dart';
import 'package:social_network/presentation/widgets/custom_button.dart';
import 'package:social_network/presentation/widgets/custom_input.dart';
import 'package:social_network/presentation/widgets/show_snackbar.dart';
import 'package:social_network/utils/constants.dart';

class FormReviewFeedBack extends StatefulWidget {
  final String feedBackId;
  const FormReviewFeedBack({super.key, required this.feedBackId});

  @override
  State<FormReviewFeedBack> createState() => _FormReviewFeedBackState();
}

class _FormReviewFeedBackState extends State<FormReviewFeedBack> {
  final TextEditingController _controller = TextEditingController();
  double? rating;
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<MyFeedBackBloc, MyFeedBackState>(
      listener: (context, state) {
        if (state is MyFeedBackError) {
          showSnackBarError(context, state.message);
        }
        if (state is MyFeedBackLoaded) {
          showSnackBarSuccess(context, 'Đánh giá thành công');
        }
      },
      child: Form(
        key: _form,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đánh giá mức độ hài lòng',
                    style: theme.textTheme.titleMedium,
                  ),
                  const Text(
                      'Vui lòng đánh để nâng cao chất lượng dịch vụ của chúng tôi'),
                ],
              ),
            ),
            RatingBar.builder(
              initialRating: rating ?? 0,
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: kSecondaryColor,
                size: 16,
              ),
              onRatingUpdate: (vaule) {
                print(vaule);
                rating = vaule;
              },
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              hintText: 'Đánh giá',
              controller: _controller,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập nội dung phản ánh';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              title: 'Gửi đánh giá',
              onPressed: () {
                print('Gửi phản ánh ${_controller.text} $rating');
                if (rating == null) {
                  showSnackBarError(
                      context, 'Vui lòng chọn đánh giá sao từ 1-5');
                  return;
                }
                if (_form.currentState!.validate()) {
                  context.read<MyFeedBackBloc>().add(
                        MyFeedBackReviewFeedBack(
                          widget.feedBackId,
                          rating ?? 0,
                          _controller.text,
                        ),
                      );
                } else {
                  showSnackBarError(context, 'Vui lòng nhập nội dung đánh giá');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
