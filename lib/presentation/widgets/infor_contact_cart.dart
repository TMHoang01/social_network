import 'package:flutter/material.dart';
import 'package:social_network/domain/models/ecom/infor_contact.dart';
import 'package:social_network/presentation/resident/router_client.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/utils.dart';

class InforContactCard extends StatelessWidget {
  final InforContactModel infor;
  const InforContactCard({
    super.key,
    required this.infor,
  });
  BoxDecoration _boxdecoration() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: kGrayLight.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0.0, 8),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        width: MediaQuery.of(context).size.width,
        decoration: _boxdecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Thông tin liên hệ',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    logger.i('change adrres');
                  },
                  child: InkWell(
                    onTap: () {
                      navService.pushNamed(context, RouterClient.contact);
                    },
                    child: const Text(
                      'Thay đổi',
                      style: TextStyle(color: kSecondaryColor),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(width: 4),
            Row(
              children: [
                const Icon(Icons.person, color: kPrimaryColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  '${infor.username}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.phone, color: kPrimaryColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  '${infor.phone}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: kGray,
                      ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: kPrimaryColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  '${infor.address}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: kGray,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
