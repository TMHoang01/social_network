import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/domain/models/service/price_list.dart';
import 'package:social_network/domain/models/service/review_service.dart';
import 'package:social_network/domain/models/service/service.dart';
import 'package:social_network/presentation/blocs/clients/booking_service_create/booking_service_create_bloc.dart';
import 'package:social_network/presentation/blocs/clients/service_detail/service_detail_bloc.dart';
import 'package:social_network/presentation/screens/clients/router_client.dart';
import 'package:social_network/presentation/screens/clients/services/widgets/widgets.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/utils.dart';

class ServiceDetailScreen extends StatefulWidget {
  final ServiceModel service;
  const ServiceDetailScreen({super.key, required this.service});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ServiceDetailBloc>().add(ServiceDetailStarted(widget.service));
  }

  @override
  void dispose() {
    context.read<ServiceDetailBloc>().add(SericeDetiailInitial());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sizeBox12 = SizedBox(height: 12.0);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.service.title}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImageView(
              url: widget.service.image,
              width: double.infinity,
              boxFit: BoxFit.contain,
              height: 200.0,
            ),
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.service.title}',
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildPrice(widget.service.priceList ?? []),
                ],
              ),
            ),
            sizeBox12,
            CustomContainer(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: CircleAvatar(
                      radius: 30.0,
                      // url
                      child: CustomImageView(
                        url:
                            'https://www.pngkey.com/png/full/114-1149878_setting-user-avatar-in-specific-size-without-breaking.png',
                      ),
                    ),
                    title: Text(
                      widget.service.providerName ?? 'Người cung cấp dịch vụ',
                    ),
                    // icon 3 chấm
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
            sizeBox12,
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleContainer('Mô tả dịch vụ'),
                  ReadMoreText(text: widget.service.description ?? ''),
                ],
              ),
            ),
            sizeBox12,
            sizeBox12,
            ServiceDetailBlocSelector<ReviewService?>(
              selector: (state) => state.myReview,
              builder: (context, review) {
                if (review == null || review.id == null) {
                  return CustomContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _titleContainer('Đánh giá cho dịch vụ này'),
                        const Text(
                          'Cho người khác biết về dịch vụ này',
                          style: TextStyle(color: kGray),
                        ),
                        Center(
                          child: RatingStarIcon(
                            isEdit: true,
                            size: 40,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4,
                            ),
                            onRatingUpdate: (value) async {
                              logger.d('rating $value');
                              await _navReviewForm(context, value);
                            },
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _navReviewForm(context);
                          },
                          child: const Text('Viết đánh giá'),
                        ),
                      ],
                    ),
                  );
                }
                return CustomContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _titleContainer('Đánh giá của bạn'),
                      ReviewContentItem(
                          review: review,
                          onTapIcon: () {
                            _dialogConfirmBuilder(context);
                          }),
                      TextButton(
                        onPressed: () {
                          _navReviewForm(context);
                        },
                        child: const Text('Chỉnh sủa đánh giá của bạn'),
                      ),
                    ],
                  ),
                );
              },
            ),
            sizeBox12,
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ServiceDetailBlocSelector<ServiceModel?>(
                    selector: (state) => state.service,
                    builder: (context, service) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _titleContainer('Đánh giá dịch vụ '),
                              RatingStarIcon(
                                rating: service?.ratingAverage,
                                allowHalfRating: true,
                              ),
                              Text(
                                  '${service?.ratingAverage}/ ${service?.ratingCountTotal ?? 0} đánh giá'),
                              // ...service!.ratingCount!.entries
                              //     .map((e) => Text(
                              //         '${e.key} sao: ${e.value} đánh giá',
                              //         style: const TextStyle(color: kGray)))
                              //     .toList(),
                            ],
                          ),
                          // TextButton(
                          //   onPressed: () {
                          //     navService.pushNamed(
                          //         context, RouterClient.serviceReviews);
                          //   },
                          //   child: const Text(
                          //     'Xem tất cả',
                          //     style: TextStyle(color: kSecondaryColor),
                          //   ),
                          // ),
                          InkWell(
                            onTap: () {
                              navService.pushNamed(
                                  context, RouterClient.serviceReviews);
                            },
                            child: const Icon(
                              Icons.arrow_forward_ios,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  BlocBuilder<ServiceDetailBloc, ServiceDetailState>(
                    buildWhen: (previous, current) =>
                        previous.status != current.status ||
                        previous.listReview != current.listReview,
                    builder: (context, state) {
                      if (state.status == ServiceDetailStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state.status == ServiceDetailStatus.loaded) {
                        if (state.listReview!.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: Text('Chưa có đánh giá nào')),
                          );
                        }
                        int count = state.listReview!.length > 3
                            ? 3
                            : state.listReview!.length;
                        Widget widget = ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: count,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final review = state.listReview![index];
                            return ReviewContentItem(review: review);
                          },
                        );
                        if (state.listReview!.length > 3) {
                          widget = Column(
                            children: [
                              widget,
                              TextButton(
                                onPressed: () {
                                  navService.pushNamed(
                                      context, RouterClient.serviceReviews);
                                },
                                child: const Text(
                                  'Xem thêm',
                                  style: TextStyle(color: kSecondaryColor),
                                ),
                              ),
                            ],
                          );
                        }
                        return widget;
                      }
                      if (state.status == ServiceDetailStatus.failure) {
                        return Center(
                            child: Text(state.error ?? 'Lỗi không xác định'));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            sizeBox12,
          ],
        ),
      ),
      bottomNavigationBar: CustomButton(
        onPressed: () {
          context.read<BookingServiceCreateBloc>().add(
                BookingServiceCreateStared(widget.service),
              );
          navService.pushNamed(context, RouterClient.servicBookingFormFill,
              args: widget.service);
        },
        title: 'Đặt lịch',
      ),
    );
  }

  Text _titleContainer(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPrice(List<PriceListItem> priceList) {
    if (widget.service.priceType == PriceType.package ||
        widget.service.priceType == PriceType.other) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bảng giá thanh khảo',
            style: TextStyle(
              fontSize: 18.0,
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
      String text =
          'Giá: ${TextFormat.formatMoney(widget.service.priceBase ?? 0)} đ';
      if (widget.service.priceType == PriceType.hourly) {
        text =
            'Giá: ${TextFormat.formatMoney(widget.service.priceBase ?? 0)} đ/giờ';
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
  }

  Future<void> _navReviewForm(BuildContext context, [double? value]) async {
    logger.d('navReviewForm $value');
    context
        .read<ServiceDetailBloc>()
        .add(SericeDetiailAddReviewInitial(ratingInit: value));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ReviewFormScreen(),
      ),
    );
  }

  Future<void> _dialogConfirmBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('Basic dialog title'),
          content: const Text(
            'Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Không'),
              onPressed: () {
                navService.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Đồng ý'),
              onPressed: () async {
                navService.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
