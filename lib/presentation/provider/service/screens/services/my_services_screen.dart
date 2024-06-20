import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/provider/service/blocs/services_my/my_services_bloc.dart';
import 'package:social_network/presentation/provider/screens/router_admin.dart';
import 'package:social_network/presentation/provider/service/screens/services/widgets/service_card.dart';
import 'package:social_network/router.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  void initState() {
    _initServiceFetch();
    super.initState();
  }

  void _initServiceFetch() {
    context.read<MyServicesBloc>().add(MyServicesStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dịch vụ cung cấp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              navService.pushNamed(context, RouterAdmin.serviceAdd);
            },
          ),
        ],
      ),
      body: BlocConsumer<MyServicesBloc, MyServicesState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return RefreshIndicator(
              onRefresh: () => Future.delayed(const Duration(seconds: 1), () {
                    context.read<MyServicesBloc>().add(MyServicesStarted());
                  }),
              child: _handleSate(state));
        },
      ),
    );
  }

  Widget _handleSate(MyServicesState state) {
    return switch (state) {
      MyServicesLoaded(services: final services) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: services.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return ServiceCardWidget(service: service);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      MyServicesFailure(message: final message) =>
        Center(child: InkWell(onTap: _initServiceFetch, child: Text(message))),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
