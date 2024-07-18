import 'package:social_network/presentation/resident/parking/domain/model/parking_lot.dart';
import 'package:social_network/presentation/resident/parking/domain/model/vehicle_ticket.dart';
import 'package:social_network/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ParkingLocalDataSource {
  ParkingLocalDataSource();
  static const String _key = 'parkinglot_list';
  static const String _keyTime = 'parkinglot_time';
  List<ParkingLot> _list = [];

  Future<void> _settimeBegin(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String strTime = date.toIso8601String();
      prefs.setString(_keyTime, strTime);
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<DateTime?> getTimeBegin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_keyTime);

      if (data == null) return null;
      return DateTime.parse(data);
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> _updateLocal() async {
    try {
      if (_list.isEmpty) return;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final save = _list.map((e) => jsEncodeVehicle(e)).toList();

      // // find timestame max
      // DateTime

      // prefs.setStringList(_key, save);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  jsEncodeVehicle(ParkingLot ticket) {
    return jsonEncode({});
  }
}
