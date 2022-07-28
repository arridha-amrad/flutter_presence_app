import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PresenceCard extends StatelessWidget {
  final String title;
  final Map<String, dynamic> presence;

  const PresenceCard({
    Key? key,
    required this.title,
    required this.presence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(12),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_pin,
                color: Colors.red,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(presence["address"]))
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.access_time,
                color: Colors.red,
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(DateFormat.Hms()
                      .format(DateTime.parse(presence["date"]))))
            ],
          )
        ],
      ),
    );
  }
}
