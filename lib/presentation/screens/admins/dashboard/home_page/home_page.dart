import 'package:flutter/material.dart';
import 'package:social_network/presentation/screens/admins/router_admin.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/constants.dart';

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            ),
            const Divider(height: 3),
            const Divider(height: 1),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ItemHomeCard(
                  title: 'Danh sách phê duyệt',
                  router: RouterAdmin.users,
                  icon: Icons.checklist_outlined,
                ),
                ItemHomeCard(
                  title: 'Bài đăng',
                  router: RouterAdmin.post,
                  icon: Icons.newspaper_rounded,
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ItemHomeCard(
                  title: 'Dịch vụ',
                  router: RouterAdmin.services,
                  icon: Icons.post_add_rounded,
                ),
                ItemHomeCard(
                  title: 'Sản phẩm',
                  router: RouterAdmin.users,
                  icon: Icons.post_add_rounded,
                ),
              ],
            ),
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
      width: size.width * 0.4,
      height: size.width * 0.4,
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
            // icon xét duyệt danh sách
            icon: Icon(
              size: 50,
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
          ))
        ],
      ),
    );
  }
}
