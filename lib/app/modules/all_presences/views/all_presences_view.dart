import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/all_presences_controller.dart';

class AllPresencesView extends GetView<AllPresencesController> {
  const AllPresencesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AllPresencesView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'AllPresencesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
