import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/ecom/infor_contact.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/presentation/provider/service/blocs/service_booking/service_booking_bloc.dart';
import 'package:social_network/presentation/provider/service/screens/service_booking/widgets/widgets.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/utils.dart';

class ServiceBookingDetailScreen extends StatelessWidget {
  const ServiceBookingDetailScreen({super.key, required this.booking});
  final BookingService booking;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceBookingBloc, ServiceBookingState>(
      buildWhen: (previous, current) {
        return previous.bookingSelected != current.bookingSelected;
      },
      builder: (context, state) {
        final booking = state.bookingSelected;
        if (booking == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (booking.status == BookingStatus.pending) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Đặt lịch x'),
            ),
            body: SingleChildScrollView(
              child: _builderPendindStatus(),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Đặt lịch'),
          ),
          body: SingleChildScrollView(
            child: _builderAcceptedStatus(booking),
          ),
        );
      },
    );
  }

  Widget _builderPendindStatus() {
    return Column(
      children: [
        InforContactCard(
          infor: booking.inforContact ?? const InforContactModel(),
          hideChange: true,
          title: 'thông tin khách hàng',
        ),

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
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tên dịch vụ: ${booking.serviceName}',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      'Nhà chu cấp: ${booking.providerName}',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      'Giá cơ bản: ${TextFormat.formatMoney(booking.servicePriceBase ?? 0)}',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      'Gói đăng ký: ${booking.servicePriceItem?.name}',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      'Giá dịch vụ: ${TextFormat.formatMoney(booking.servicePriceItem?.price ?? 0)}',
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
        // infor schedule
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      'Thứ: ${booking.schedule?.dayRepeat?.map((e) => 'T${e + 1}').join(',') ?? ''}',
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
        // note
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
                child: Text(booking.note ?? 'Không'),
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
        // status
        serviceFormStateBlocSelector<BookingStatus?>(
          selector: (state) {
            return state.bookingSelected!.status;
          },
          builder: (context, status) {
            final textColor = status == BookingStatus.accepted
                ? Colors.green
                : status == BookingStatus.rejected
                    ? Colors.red
                    : kSecondaryColor;
            Widget childStatus = CustomContainer(
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
                        status?.toName() ?? '',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: textColor),
                      ),
                    ),
                  ],
                ),
              ),
            );

            if (status != BookingStatus.pending || status == null) {
              return childStatus;
            }
            return Column(
              children: [
                childStatus,
                const SizedBox(height: 8),
                CustomButton(
                  onPressed: () {
                    context.read<ServiceBookingBloc>().add(
                          ServiceBookingAcceptStatus(booking.id),
                        );
                  },
                  title: 'Xác nhận',
                ),
                const SizedBox(height: 8),
                CustomButton(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    // show Dilo
                    _dialogBuilder(context);
                  },
                  title: 'Hủy bỏ',
                ),
                const SizedBox(height: 8),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Thông báo'),
          content: const Text(
            'Bạn có xác nhận muốn hủy bỏ đơn đặt này không?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Hủy bỏ'),
              onPressed: () {
                navService.pop(ctx);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Xác nhận'),
              onPressed: () async {
                context.read<ServiceBookingBloc>().add(
                      ServiceBookingUpdateStatus(
                        booking.id,
                        BookingStatus.rejected,
                      ),
                    );
                navService.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }

  serviceFormStateBlocSelector<T>({
    required T Function(ServiceBookingState) selector,
    required Widget Function(BuildContext, T) builder,
  }) =>
      BlocSelector<ServiceBookingBloc, ServiceBookingState, T>(
        selector: selector,
        builder: builder,
      );

  _builderAcceptedStatus(BookingService booking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InforContactCard(
          infor: booking.inforContact ?? const InforContactModel(),
          hideChange: true,
          title: 'thông tin khách hàng',
        ),
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
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tên dịch vụ: ${booking.serviceName}',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      'Nhà chu cấp: ${booking.providerName}',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      'Trạng tháo: ${booking.status?.toName()}',
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
        CustomContainer(
          child: Column(
            children: [
              const SizedBox(width: 8),
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
              ListSchedule(booking: booking),
            ],
          ),
        ),
      ],
    );
  }
}
