import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/resident/features/feed_back/blocs/my_feed_back/my_feed_back_bloc.dart';
import 'package:social_network/presentation/resident/router_client.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';

import 'widgets/widgets.dart';

class FeedBackListScreen extends StatefulWidget {
  const FeedBackListScreen({super.key});

  @override
  State<FeedBackListScreen> createState() => _FeedBackListScreenState();
}

class _FeedBackListScreenState extends State<FeedBackListScreen> {
  late final MyFeedBackBloc _myFeedBackBloc;
  @override
  void initState() {
    super.initState();
    _myFeedBackBloc = context.read<MyFeedBackBloc>();
    if (_myFeedBackBloc.state is MyFeedBackInitial) {
      _myFeedBackBloc.add(MyFeedBackStared());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phản ánh'),
      ),
      body: SizedBox(
        height: double.infinity,
        child: BlocBuilder<MyFeedBackBloc, MyFeedBackState>(
          builder: (context, state) {
            return _builderState(state);
          },
        ),
      ),
      bottomNavigationBar: CustomButton(
        onPressed: () {
          navService.pushNamed(context, RouterClient.feedbackCreate);
        },
        title: 'Tạo phản ánh',
      ),
    );
  }

  Widget _builderState(MyFeedBackState state) {
    return switch (state) {
      MyFeedBackLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
      MyFeedBackLoaded(feedBacks: final feedBacks) => feedBacks.isEmpty
          ? const Center(
              child: Text('Bạn chưa có phản ánh nào'),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 2),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: feedBacks.length,
                    itemBuilder: (context, index) {
                      final item = feedBacks[index];
                      return ItemFeedBack(item);
                    },
                  ),
                ],
              ),
            ),
      MyFeedBackError(message: final message) => Center(
          child: InkWell(
            onTap: () {
              _myFeedBackBloc.add(MyFeedBackStared());
            },
            child: Text(message),
          ),
        ),
      _ => InkWell(
          onTap: () {
            _myFeedBackBloc.add(MyFeedBackStared());
          },
          child: Center(
            child: Text('Lỗi không xác định $state'),
          ),
        ),
    };
  }
}
