import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/resident/parking/blocs/my_vehicle/vehicle_list_bloc.dart';

import 'widgets/item_vehicle_card.dart';

class ListMyVehicleScreen extends StatefulWidget {
  const ListMyVehicleScreen({super.key});

  @override
  State<ListMyVehicleScreen> createState() => _ListMyVehicleScreenState();
}

class _ListMyVehicleScreenState extends State<ListMyVehicleScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MyVehicleBloc>().add(MyVehicleStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách thẻ gửi xe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/parking/my-vehicle/create');
            },
          ),
        ],
      ),
      body: BlocBuilder<MyVehicleBloc, MyVehicleState>(
        builder: (context, state) {
          if (state.status == MyVehicleStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.status == MyVehicleStatus.error) {
            return const Center(
              child: Text('Có lỗi xảy ra'),
            );
          }
          if (state.list.isEmpty) {
            return const Center(
              child: Text('Không có dữ liệu'),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                final item = state.list[index];
                return ItemVehicleCard(item: item);
              },
            ),
          );
        },
      ),
    );
  }
}
