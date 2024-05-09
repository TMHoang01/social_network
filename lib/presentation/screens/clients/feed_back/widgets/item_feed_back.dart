import 'package:flutter/material.dart';
import 'package:social_network/domain/models/feed_back/feed_back.dart';
import 'package:social_network/presentation/screens/clients/router_client.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/utils.dart';

class ItemFeedBack extends StatelessWidget {
  final FeedBackModel item;

  ItemFeedBack(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    Color color = switch (item.status ?? FeedBackStatus.pending) {
      FeedBackStatus.pending => Colors.orange,
      FeedBackStatus.approved => Colors.blue,
      FeedBackStatus.completed => Colors.green,
      FeedBackStatus.reviewed => Colors.green,
      _ => Colors.orange,
    };
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 164,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: () => navService.pushNamed(
            context,
            RouterClient.feedbackDetail,
            args: item,
          ),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                width: size.width,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                ),
                child: Text(
                  'Phản ánh ${item.type?.toName() ?? ''}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        item.content ?? '',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'Ngày tạo: ${TextFormat.formatDate(item.createdAt ?? DateTime.now(), formatType: 'dd/MM/yyyy hh:mm')}',
                    ),
                    Row(
                      children: [
                        const Text('Trạng thái:  '),
                        _buildStatus(
                            item.status ?? FeedBackStatus.pending, color),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text _buildStatus(FeedBackStatus status, Color color) {
    return Text(
      status.toName(),
      style: TextStyle(
        color: color,
      ),
    );
  }
}
