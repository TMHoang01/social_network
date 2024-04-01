import 'package:flutter/material.dart';
import 'package:social_network/utils/constants.dart';
import 'package:social_network/presentation/widgets/custom_button.dart';

class OrdersDetailWidget extends StatefulWidget {
  final Function? changeView;

  const OrdersDetailWidget({super.key, this.changeView});

  @override
  State<OrdersDetailWidget> createState() => _OrdersDetailWidgetState();
}

class _OrdersDetailWidgetState extends State<OrdersDetailWidget> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('List Order'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: width * 1.43,
              width: width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(ImageConstant.imgLogo),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    width: width / 2,
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        ('fashionSale'),
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 15, bottom: 15, top: 15),
                    width: 160,
                    child: CustomButton(
                      title: 'Check',
                      width: 160,
                      height: 48,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.only(left: 15, bottom: 15),
                      width: 160,
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          ('Check Order'),
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  CustomButton(
                    title: 'Next Home Page',
                    width: 160,
                    height: 48,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
