import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/domain/models/service/price_list.dart';
import 'package:social_network/domain/models/service/service.dart';
import 'package:social_network/presentation/blocs/clients/booking_service_create/booking_service_create_bloc.dart';
import 'package:social_network/presentation/screens/clients/router_client.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/utils.dart';

class ServiceDetailScreen extends StatelessWidget {
  final ServiceModel service;
  const ServiceDetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${service.title}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImageView(
              url: service.image,
              width: double.infinity,
              boxFit: BoxFit.contain,
              height: 200.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${service.title}',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildPrice(service.priceList ?? []),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mô tả dịch vụ',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${service.description}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomButton(
        onPressed: () {
          context.read<BookingServiceCreateBloc>().add(
                BookingServiceCreateStared(service),
              );
          navService.pushNamed(context, RouterClient.servicBookingFormFill,
              args: service);
        },
        title: 'Đặt lịch',
      ),
    );
  }

  Widget _buildPrice(List<PriceListItem> priceList) {
    if (service.priceType == PriceType.package ||
        service.priceType == PriceType.other) {
      return Column(
        children: [
          const Text(
            'Bảng giá thanh khảo',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Loại dịch vụ',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Giá',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
            rows: priceList
                .map(
                  (e) => DataRow(
                    cells: <DataCell>[
                      DataCell(Text('${e.name}')),
                      DataCell(
                          Text('${TextFormat.formatMoney(e.price ?? 0)} đ')),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      );
    } else {
      String text = 'Giá: ${TextFormat.formatMoney(service.priceBase ?? 0)} đ';
      if (service.priceType == PriceType.hourly) {
        text = 'Giá: ${TextFormat.formatMoney(service.priceBase ?? 0)} đ/giờ';
      }
      return Column(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
  }
}
