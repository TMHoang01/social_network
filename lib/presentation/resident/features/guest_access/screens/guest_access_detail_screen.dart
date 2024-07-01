import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/resident/features/guest_access/blocs/guest_access/guest_access_bloc.dart';
import 'package:social_network/presentation/widgets/custom_button.dart';
import 'package:social_network/utils/text_format.dart';

class GuestAccessDetailScreen extends StatelessWidget {
  const GuestAccessDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết khách thăm'),
      ),
      body: BlocBuilder<GuestAccessBloc, GuestAccessState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildItem('Tên khách', state.select?.guestName),
                  const Divider(),
                  _buildItem('Số điện thoại', state.select?.guestPhone),
                  const Divider(),
                  _buildItem('Số CCCD', state.select?.guestCccd),
                  const Divider(),
                  _buildItem('Mục đích', state.select?.purpose),
                  const Divider(),
                  _buildItem(
                      'Thời gian dự kiến',
                      TextFormat.formatDate(
                          state.select?.expectedTime ?? DateTime.now())),
                  const Divider(),
                  _buildItem('Trạng thái', state.select?.statusText),
                  // _buildItem('Thời gian xác nhận', '10:00 01/01/2022'),
                  // _buildItem('Người xác nhận', 'Nguyễn Văn B'),
                  if (state.select?.status == null ||
                      state.select?.status == 'pending')
                    CustomButton(
                      backgroundColor: Colors.red,
                      onPressed: () {
                        context.read<GuestAccessBloc>().add(
                            GuestAccessEventCancel(context
                                    .read<GuestAccessBloc>()
                                    .state
                                    .select!
                                    .id ??
                                ''));
                      },
                      title: 'Hủy',
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem(String title, String? value) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          '$value ',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
