import 'package:flutter/material.dart';
import 'package:social_network/domain/models/service/service.dart';
import 'package:social_network/presentation/widgets/widgets.dart';

class ServiceDetailProviderScreen extends StatelessWidget {
  final ServiceModel service;
  const ServiceDetailProviderScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết dịch vụ'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ReadMoreText(text: service.description ?? ''),
            Center(
              child: Text('Chi tiết dịch vụ$service'),
            ),
          ],
        ),
      ),
    );
  }
}
