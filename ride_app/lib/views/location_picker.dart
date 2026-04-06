import 'package:flutter/material.dart';
import '../models/location_point.dart';
import '../services/location_service.dart';

class LocationPicker extends StatefulWidget {
  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  List<LocationPoint> filtered =
      List.from(LocationService.locations);

  void search(String keyword) {
    setState(() {
      filtered = LocationService.locations
          .where((loc) =>
              loc.name.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chọn địa điểm")),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Tìm kiếm...",
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: search,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                var loc = filtered[index];
                return ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text(loc.name),
                  onTap: () => Navigator.pop(context, loc),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}