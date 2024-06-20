import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/domain/models/service/price_list.dart';
import 'package:social_network/domain/models/service/service.dart';
import 'package:social_network/presentation/resident/features/service/blocs/booking_service/booking_service_bloc.dart';
import 'package:social_network/presentation/resident/features/service/blocs/booking_service_create/booking_service_create_bloc.dart';
import 'package:social_network/presentation/resident/contact/blocs/infor_contact/infor_contact_bloc.dart';
import 'package:social_network/presentation/resident/router_client.dart';
import 'package:social_network/presentation/screens/not_found/not_found_screen.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';

class BookingFormFillScreen extends StatelessWidget {
  const BookingFormFillScreen({Key? key, required ServiceModel service})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingServiceCreateBloc, BookingServiceCreateState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        // TODO: implement listener
        if (state is BookingServiceSuccess) {
          // BlocProvider.of<CartBloc>(context).add(ClearCart());
          // navService.pushNamed(context, RouterClient.complete);
        } else if (state.error != null) {
          showSnackBarError(context, state.error!);
        }
      },
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.booking == null) {
          return const NotFoundScreen();
        }
        return switch (state.status) {
          BookingServiceCreateStatus.initial => _buildForm(context, state),
          _ => const NotFoundScreen(),
        };
      },
    );
  }

  Widget _buildForm(BuildContext context, BookingServiceCreateState state) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt lịch'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<InforContactBloc, InforContactState>(
              builder: (context, state) {
                if (state is InforContactLoaded) {
                  final infor = state.inforContact;
                  context.read<BookingServiceCreateBloc>().add(
                        BookingServiceCreateUpdateAdress(infor),
                      );
                  return InforContactCard(infor: infor);
                } else if (state is InforContactLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is InforContactEmpty) {
                  return const Center(child: Text('Chưa có thông tin liên hệ'));
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 8),
            CustomContainer(
              child: Column(
                children: [
                  if (state.booking?.servicePriceType == PriceType.package ||
                      state.booking?.servicePriceType == PriceType.other)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _textTile('Chọn gói đăng ký'),
                        bookingServiceCreateBlocSelector<PriceListItem?>(
                          selector: (state) => state.booking?.servicePriceItem,
                          builder: (context, priceItem) {
                            return Column(
                              children: [
                                ...state.service!.priceList!.map((e) {
                                  return RadioListTile<PriceListItem>(
                                    contentPadding: const EdgeInsets.all(.0),
                                    selected: e == priceItem,
                                    title: Text('${e.name}'),
                                    value: e,
                                    groupValue: priceItem,
                                    onChanged: (value) {
                                      if (value == null) return;
                                      context
                                          .read<BookingServiceCreateBloc>()
                                          .add(
                                            BookingServiceCreateUpdatePriceItem(
                                                value),
                                          );
                                    },
                                  );
                                }).toList(),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  if (state.booking?.servicePriceType == PriceType.hourly)
                    bookingServiceCreateBlocSelector<PriceListItem?>(
                      selector: (state) => state.booking?.servicePriceItem,
                      builder: (context, priceItem) {
                        final selectNum = switch (priceItem?.id) {
                          '1' => 1,
                          '2' => 2,
                          '4' => 4,
                          '8' => 8,
                          _ => null,
                        };
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textTile('Chọn thời gian ca'),
                            Row(
                              children: [
                                _buildTimeShift(selectNum == 1, 1,
                                    state.booking?.servicePriceBase, context),
                                _buildTimeShift(selectNum == 2, 2,
                                    state.booking?.servicePriceBase, context),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _buildTimeShift(selectNum == 4, 4,
                                    state.booking?.servicePriceBase, context),
                                _buildTimeShift(selectNum == 8, 8,
                                    state.booking?.servicePriceBase, context),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  if (state.booking?.servicePriceType == PriceType.fixed)
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _textTile('Giá cơ bản'),
                          _textTile(
                            '${state.booking?.servicePriceBase}',
                          ),
                        ])
                ],
              ),
            ),
            const SizedBox(height: 16),
            CustomContainer(
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
                  bookingServiceCreateBlocSelector<String?>(
                    selector: (state) => state.booking?.note,
                    builder: (context, note) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: note,
                          // controller: _noteController,
                          onChanged: (value) {
                            context.read<BookingServiceCreateBloc>().add(
                                  BookingServiceCreateUpdateNote(value),
                                );
                          },
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Nhập ghi chú',
                            border: InputBorder.none,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomButton(
        onPressed: () {
          handleBooking(context);
        },
        title: 'Đặt lịch',
      ),
    );
  }

  void handleBooking(BuildContext context) {
    final booking = context.read<BookingServiceCreateBloc>().state.booking;
    if (booking?.servicePriceType == PriceType.hourly ||
        booking?.servicePriceType == PriceType.package) {
      if (booking?.servicePriceItem == null) {
        showSnackBarError(context, 'Vui lòng chọn gói đăng ký');
        return;
      }
    }
    // if (booking == null) return;
    // if (booking.servicePriceItem == null) {
    //   showSnackBarError(context, 'Vui lòng chọn gói đăng ký');
    //   return;
    // }
    // if (booking.note == null) {
    //   showSnackBarError(context, 'Vui lòng nhập ghi chú');
    //   return;
    // }

    navService.pushNamed(context, RouterClient.servicBookingFormSchedule);
  }

  Widget _textTile(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  bookingServiceCreateBlocSelector<T>({
    required T Function(BookingServiceCreateState) selector,
    required Widget Function(BuildContext, T) builder,
  }) =>
      BlocSelector<BookingServiceCreateBloc, BookingServiceCreateState, T>(
        selector: selector,
        builder: builder,
      );

  Widget _buildTimeShift(
      bool isSelect, num num, num? priceBase, BuildContext context) {
    return Expanded(
      child: SizedBox(
        child: SelectWidget(
          text: '$num giờ ${(priceBase ?? 0) * num}',
          isSelect: isSelect,
          onChanged: () {
            // setState(() {
            //   booking = booking.copyWith(timeShift: num);
            // });
            context.read<BookingServiceCreateBloc>().add(
                  BookingServiceCreateUpdatePriceItem(
                    PriceListItem(
                      id: num.toString(),
                      name: '$num giờ',
                      price: (priceBase ?? 0) * num,
                    ),
                  ),
                );
          },
        ),
      ),
    );
  }
}
