import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearby_connections/nearby_connections.dart';

class ReceiveConnectReqWidget extends StatelessWidget {
  final String id;
  final ConnectionInfo info;
  final void Function() onAccept;
  final void Function() onReject;
  const ReceiveConnectReqWidget(
      {Key? key, required this.id, required this.info, required this.onAccept, required this.onReject})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Name: ${info.endpointName}',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 5),
            Text('Id: $id'),
            const SizedBox(height: 5),
            Text('Token: ${info.authenticationToken}'),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: context.theme.colorScheme.onPrimaryContainer,
                backgroundColor: context.theme.colorScheme.primaryContainer,
              ),
              onPressed: () {
                Get.back(result: true);
                onAccept();
              },
              child: const Text('Accept Connection'),
            ),
            const SizedBox(height: 15),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: context.theme.colorScheme.error,
                backgroundColor: context.theme.colorScheme.onError,
                side: BorderSide(color: context.theme.colorScheme.error),
              ),
              onPressed: () {
                Get.back(result: false);
                onReject();
              },
              child: const Text('Reject Connection'),
            ),
          ],
        ),
      ),
    );
  }
}
