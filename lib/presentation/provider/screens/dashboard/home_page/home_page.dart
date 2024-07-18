import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network/presentation/provider/screens/router_admin.dart';
import 'package:social_network/presentation/resident/router_client.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/utils.dart';

class ItemHomePage {
  final String title;
  final IconData icon;
  final Color? color;
  final Function onTap;
  ItemHomePage({
    required this.title,
    required this.icon,
    this.color,
    required this.onTap,
  });
}

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage>
// with AutomaticKeepAliveClientMixin<AdminHomePage>
{
  // @override
  // bool get wantKeepAlive => true;

  final listPost = [
    ItemHomePage(
      title: 'Tin tức',
      icon: FontAwesomeIcons.podcast,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterAdmin.post);
      },
    ),
    ItemHomePage(
      title: 'Tin tức của tôi',
      icon: FontAwesomeIcons.hornbill,
      color: Colors.yellow,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterAdmin.postMyProvider);
      },
    ),
  ];

  final manageShop = [
    // ItemHomePage(
    //   title: 'Hàng hóa',
    //   icon: FontAwesomeIcons.productHunt,
    //   color: Colors.green,
    //   onTap: (BuildContext context) {
    //     navService.pushNamed(context, RouterAdmin.products);
    //   },
    // ),
    ItemHomePage(
      title: 'Dịch vụ',
      icon: FontAwesomeIcons.servicestack,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterAdmin.services);
      },
    ),
    ItemHomePage(
      title: 'Lịch hẹn',
      icon: FontAwesomeIcons.calendarDays,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterAdmin.schedule);
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    // super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Trang chủ ',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // list post
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tin tức sự kiện',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildGridView(listPost),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quản lý dịch vụ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildGridView(manageShop),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  GridView _buildGridView(List<ItemHomePage> list) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 2,
        mainAxisSpacing: 0,
        childAspectRatio: 1.34,
      ),
      itemBuilder: (context, index) {
        final item = list[index];
        return ItemHomeBox(item: item);
      },
    );
  }
}

class ItemHomeBox extends StatelessWidget {
  final ItemHomePage item;
  const ItemHomeBox({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        item.onTap(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        width: 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                shape: BoxShape.rectangle,
              ),
              child: Icon(
                item.icon,
                size: 24,
                color: item.color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: BorderSide.strokeAlignCenter,
              ),
            ),
            // Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}

class ItemHomeCard extends StatelessWidget {
  final router;
  final String title;
  // icon
  final IconData icon;
  const ItemHomeCard(
      {super.key, this.router, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(10),
      width: size.width * 0.36,
      height: size.width * 0.36,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(40),
        shape: BoxShape.rectangle,
        gradient: const LinearGradient(
          colors: [
            kPrimaryColor,
            kSecondaryColor,
          ],
          transform: GradientRotation(0.5 * 3.14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              navService.pushNamed(context, router);
            },
            icon: Icon(
              size: 32,
              icon,
              color: Colors.white,
            ),
          ),
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
