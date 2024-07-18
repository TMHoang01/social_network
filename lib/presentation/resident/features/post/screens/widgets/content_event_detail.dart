import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/post/event.dart';
import 'package:social_network/presentation/resident/features/post/blocs/post_detail/post_detail_bloc.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/utils.dart';

class ContentEventsDetail extends StatelessWidget {
  const ContentEventsDetail({
    super.key,
    required this.post,
  });

  final EventModel post;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<PostViewDetailBloc, PostViewDetailState>(
          buildWhen: (previous, current) {
            if (current is PostDetailInitial ||
                current is PostDetailLoadInProgress) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            late final EventModel event;
            if (state is PostDetailLoadSuccess) {
              event = state.post as EventModel;
            } else {
              // logger.d('state.post: else ${state}');
              event = post;
            }

            Widget btnJoiner = CustomButton(
              height: 40,
              onPressed: () {
                context
                    .read<PostViewDetailBloc>()
                    .add(PostJoinEvent(post: post));
              },
              title: 'Đăng ký tham gia',
              // color: theme.primaryColor,
              // textColor: Colors.white,
            );

            if (event.checkUserJoin(userCurrent?.uid ?? '')) {
              btnJoiner = CustomButton(
                height: 40,
                onPressed: () {
                  _dialogBuilder(context);
                },
                backgroundColor: kSecondaryColor,
                title: 'Hủy đăng ký',
                // color: theme.primaryColor,
                // textColor: Colors.white,
              );
            }

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${post.title}',
                    style: theme.textTheme.headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        TextFormat.formatDate(post.beginDate!),
                        style: theme.textTheme.labelLarge!.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        ' - ',
                        style: theme.textTheme.labelLarge!.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        TextFormat.formatDate(post.endDate!),
                        style: theme.textTheme.labelLarge!.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.location}',
                        style: theme.textTheme.labelLarge!.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.people_alt_rounded,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        post.joinersCountText(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge!.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  btnJoiner,
                ],
              ),
            );
          },
        ),
        const Divider(),
        const SizedBox(height: 8),
        CustomContainer(
          // padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Thông tin sự kiện',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReadMoreText(text: post.content ?? ''),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Thông báo'),
          content: const Text(
            'Bạn có muốn hủy đăng ký sự kiện này không?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Hủy bỏ'),
              onPressed: () {
                navService.pop(ctx);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Dồng ý'),
              onPressed: () async {
                context
                    .read<PostViewDetailBloc>()
                    .add(PostLeaveEvent(post: post));
                navService.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }
}
