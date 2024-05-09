import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/ecom/infor_contact.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/presentation/blocs/clients/booking_service_create/booking_service_create_bloc.dart';
import 'package:social_network/presentation/blocs/clients/infor_contact/infor_contact_bloc.dart';
import 'package:social_network/presentation/screens/clients/router_client.dart';
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
      listener: (context, state) {
        if (state is BookingServiceCreateSuccess) {
          navService.pushNamedAndRemoveUntil(context, RouterClient.complete);
        } else if (state is BookingServiceCreateFailure) {
          showSnackBarError(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Đặt lịch'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                InforContactCard(
                    infor: widget.booking.inforContact ??
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
                              'Tên dịch vụ: ${widget.booking.serviceName}',
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              'Nhà chu cấp: ${widget.booking.providerId}',
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
                              'Thời gian bắt đầu: ${TextFormat.formatDate(widget.booking.scheduleBooking?.startDate)}',
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              'Thời gian kết thúc: ${TextFormat.formatDate(widget.booking.scheduleBooking?.endDate)}',
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              'Đăng ký gói: ${widget.booking.scheduleBooking?.isReapeat}',
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              'Số buổi: ${widget.booking.scheduleBooking!.scheduleDates?.length}',
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
                        child: Text(widget.booking.note ?? ''),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
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
