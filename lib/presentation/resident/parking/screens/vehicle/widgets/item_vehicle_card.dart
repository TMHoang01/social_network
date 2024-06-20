import 'package:flutter/material.dart';
import 'package:social_network/presentation/resident/parking/domain/model/vehicle_ticket.dart';

class ItemVehicleCard extends StatelessWidget {
  final VehicleTicket item;
  const ItemVehicleCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final Color color = item.status == TicketStatus.pending
        ? Colors.orange
        : item.status == TicketStatus.active
            ? Colors.green
            : Colors.red;
    final Size size = MediaQuery.of(context).size;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
            child: Icon(item.vehicleType == 'car'
                ? Icons.directions_car
                : Icons.motorcycle)),
        title: Text(item.vehicleLicensePlate ?? ""),
        subtitle: Text(
          item.status?.toName() ?? '',
          // item.parkingLotName ?? '',
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
