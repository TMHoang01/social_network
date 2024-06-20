import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/resident/features/service/blocs/services/services_bloc.dart';
import 'package:social_network/presentation/provider/service/screens/services/widgets/service_card.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  void _initFetch(BuildContext context) {
    context.read<ServicesBloc>().add(ServicesStarted());
  }

  @override
  void initState() {
    super.initState();
    final state = context.read<ServicesBloc>().state;
    if (state is ServicesInitial) {
      _initFetch(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách dịch vụ'),
      ),
      body: BlocConsumer<ServicesBloc, ServicesState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return RefreshIndicator(
              onRefresh: () => Future.delayed(const Duration(seconds: 1), () {
                    _initFetch(context);
                  }),
              child: _handleSate(state));
        },
      ),
    );
  }

  Widget _handleSate(ServicesState state) {
    return switch (state) {
      ServicesLoaded(services: final services) => SingleChildScrollView(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 4),
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
      ServicesFailure(message: final message) => Center(
          child:
              InkWell(onTap: () => _initFetch(context), child: Text(message))),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
