import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/ecom/infor_contact.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/presentation/resident/features/service/blocs/booking_service_create/booking_service_create_bloc.dart';
import 'package:social_network/presentation/resident/router_client.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/utils.dart';

class BookingCheckoutScreen extends StatefulWidget {
  final BookingService booking;
  const BookingCheckoutScreen({super.key, required this.booking});

  @override
  State<BookingCheckoutScreen> createState() => _BookingCheckoutScreenState();
}

class _BookingCheckoutScreenState extends State<BookingCheckoutScreen> {
  DateTime? _workDate;
  final TextEditingController _scheduleDateController = TextEditingController();

  @override
  void dispose() {
    _scheduleDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<BookingServiceCreateBloc, BookingServiceCreateState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == BookingServiceCreateStatus.success) {
          navService.pushNamedAndRemoveUntil(context, RouterClient.complete);
        } else if (state.status == BookingServiceCreateStatus.failure) {
          showSnackBarError(context, state.error ?? '');
        }
      },
      builder: (context, state) {
        final servicePriceType = state.booking?.servicePriceType;
        bool checkSinglePrice = servicePriceType == PriceType.hourly ||
            servicePriceType == PriceType.fixed;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Đặt lịch'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                InforContactCard(
                    infor: state.booking?.inforContact ??
                        const InforContactModel()),
                // infor service
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  width: size.width,
                  decoration: _boxdecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.0, top: 8.0),
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
                              'Tên dịch vụ: ${state.booking?.serviceName}',
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              'Nhà chu cấp: ${state.booking?.providerName}',
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            checkSinglePrice
                                ? Text(
                                    'Giá cơ bản: ${TextFormat.formatMoney(state.booking?.servicePriceBase ?? 0)}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Gói đăng ký: ${state.booking?.servicePriceItem?.name}',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      Text(
                                        'Giá dịch vụ: ${TextFormat.formatMoney(state.booking?.servicePriceItem?.price ?? 0)}',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
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
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  width: size.width,
                  decoration: _boxdecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.0, top: 8.0),
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
                              'Thời gian bắt đầu: ${TextFormat.formatDate(state.schedule?.startDate)}',
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              'Thời gian kết thúc: ${TextFormat.formatDate(state.schedule?.endDate)}',
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              'Lặp lại hàng tuần: ${state.schedule?.isReapeat == false ? 'Không' : 'Có'}',
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              'Số buổi: ${state.schedule?.scheduleCount}',
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
                Container(
                  width: size.width,
                  decoration: _boxdecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0, top: 8.0),
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
                        child: Text(state.booking?.note ?? ''),
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
                        padding: EdgeInsets.only(left: 16.0, top: 8.0),
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
                          '${TextFormat.formatMoney(state.booking?.total ?? 0)}',
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
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              onPressed: () {
                // navService.pushNamed(context, RouterClient.checkOut);
                _handleBooking(context);
              },
              title: 'Đặt hàng',
            ),
          ),
        );
      },
    );
  }

  void _handleBooking(BuildContext context) {
    context
        .read<BookingServiceCreateBloc>()
        .add(BookingServiceCreateSubmit(widget.booking));
    // navService.pushNamed(context, RouterClient.checkOut);
  }

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
}
