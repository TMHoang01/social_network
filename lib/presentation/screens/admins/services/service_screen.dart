import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/blocs/admins/services/services_bloc.dart';
import 'package:social_network/presentation/screens/admins/router_admin.dart';
import 'package:social_network/presentation/screens/admins/services/widgets/service_card.dart';
import 'package:social_network/router.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              navService.pushNamed(context, RouterAdmin.serviceAdd);
            },
          ),
        ],
      ),
      body: BlocConsumer<ServicesBloc, ServicesState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return _handleSate(state);
        },
      ),
    );
  }

  Widget _handleSate(ServicesState state) {
    return switch (state) {
      ServicesLoaded(services: final services) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('data'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: services.length,
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
      ServicesFailure(message: final message) => Center(child: Text(message)),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
