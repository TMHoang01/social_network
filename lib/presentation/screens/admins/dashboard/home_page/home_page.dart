import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network/presentation/screens/admins/router_admin.dart';
import 'package:social_network/presentation/widgets/custom_image_view.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/constants.dart';

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

  final List<ItemHomePage> listTypeUser = [
    ItemHomePage(
      title: 'Phê duyệt',
      icon: FontAwesomeIcons.userCheck,
      color: Colors.yellow,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterAdmin.users);
      },
    ),
    ItemHomePage(
      title: 'Nhân viên',
      icon: FontAwesomeIcons.userTie,
      color: Colors.blue,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterAdmin.employList);
      },
    ),
    ItemHomePage(
      title: 'Cư dân',
      icon: FontAwesomeIcons.buildingUser,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterAdmin.users);
      },
    ),
    ItemHomePage(
      title: 'Nhà cung cấp',
      icon: FontAwesomeIcons.userGear,
      color: Colors.red,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterAdmin.users);
      },
    ),
  ];

  final List<ItemHomePage> listinternalServices = [
    ItemHomePage(
      title: 'Phản ánh cư dân',
      icon: FontAwesomeIcons.ticket,
      color: Colors.red,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterAdmin.feedback);
      },
    ),
    ItemHomePage(
      title: 'Khách thăm',
      icon: FontAwesomeIcons.addressCard,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterAdmin.products);
      },
    ),
    ItemHomePage(
      title: 'Phòng hội nghị',
      icon: FontAwesomeIcons.doorOpen,
      color: Colors.blue,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterAdmin.products);
      },
    ),
    ItemHomePage(
      title: 'Bài đăng',
      icon: FontAwesomeIcons.podcast,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterAdmin.products);
      },
    ),
    ItemHomePage(
      title: 'Dịch vụ',
      icon: FontAwesomeIcons.box,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterAdmin.services);
      },
    ),
    ItemHomePage(
      title: 'Dịch vụ',
      icon: FontAwesomeIcons.box,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterAdmin.products);
      },
    ),
  ];

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
      title: 'Sự kiện',
      icon: FontAwesomeIcons.hornbill,
      color: Colors.yellow,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterAdmin.post);
      },
    ),
    ItemHomePage(
      title: 'Hàng hóa',
      icon: FontAwesomeIcons.productHunt,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterAdmin.products);
      },
    ),
    ItemHomePage(
      title: 'Dịch vụ',
      icon: FontAwesomeIcons.servicestack,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterAdmin.services);
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
            SizedBox(
              height: size.height * 0.24,
              width: size.width,
              child: CustomImageView(
                imagePath: ImageConstant.banners[1],
                boxFit: BoxFit.fitWidth,
              ),
            ),

            // List type user
            Text('  Quản lý người dùng', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            _buildGridView(listTypeUser),
            Text('  Dịch vụ tiện ích', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            _buildGridView(listinternalServices),
            Text('  Bài đăng, sản phẩm', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            _buildGridView(listPost),

            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ItemHomeCard(
            //       title: 'Danh sách phê duyệt',
            //       router: RouterAdmin.users,
            //       icon: Icons.checklist_outlined,
            //     ),
            //     ItemHomeCard(
            //       title: 'Bài đăng',
            //       router: RouterAdmin.post,
            //       icon: Icons.newspaper_rounded,
            //     ),
            //   ],
            // ),
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ItemHomeCard(
            //       title: 'Dịch vụ',
            //       router: RouterAdmin.services,
            //       icon: Icons.post_add_rounded,
            //     ),
            //     ItemHomeCard(
            //       title: 'Sản phẩm',
            //       router: RouterAdmin.users,
            //       icon: Icons.post_add_rounded,
            //     ),
            //   ],
            // ),
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
