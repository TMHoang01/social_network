import 'package:flutter/material.dart';
import 'package:social_network/domain/models/ecom/infor_contact.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/utils/utils.dart';

class BookingCheckDetailScreen extends StatefulWidget {
  final BookingService booking;
  const BookingCheckDetailScreen({super.key, required this.booking});

  @override
  State<BookingCheckDetailScreen> createState() =>
      _BookingCheckDetailScreenState();
}

class _BookingCheckDetailScreenState extends State<BookingCheckDetailScreen> {
  late final BookingService booking = widget.booking;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = booking.status == BookingStatus.accepted
        ? Colors.green
        : booking.status == BookingStatus.rejected
            ? Colors.red
            : const Color.fromARGB(255, 234, 234, 53);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt lịch'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InforContactCard(
                infor: booking.inforContact ?? const InforContactModel()),
            // infor service
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Thông tin dịch vụ',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tên dịch vụ: ${booking?.serviceName}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Nhà chu cấp: ${booking?.providerId}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Giá cơ bản: ${TextFormat.formatMoney(booking?.servicePriceBase ?? 0)}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Gói đăng ký: ${booking?.servicePriceItem?.name}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Giá dịch vụ: ${TextFormat.formatMoney(booking?.servicePriceItem?.price ?? 0)}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // infor cheulde
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Lịch đăng ký',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thời gian bắt đầu: ${TextFormat.formatDate(booking.schedule?.startDate)}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Thời gian kết thúc: ${TextFormat.formatDate(booking.schedule?.endDate)}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Lặp lại hàng tuần: ${booking.schedule?.isReapeat == false ? 'Không' : 'Có'}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Số buổi: ${booking.schedule?.scheduleCount}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Ghi chú',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(booking?.note ?? ''),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 8),

            CustomContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Tổng tiền',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      '${TextFormat.formatMoney(booking?.total ?? 0)}đ',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            CustomContainer(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Trạng thái',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        booking.status?.toName() ?? '',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: textColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
