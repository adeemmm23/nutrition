import 'package:flutter/material.dart';

class DataBottomSheet extends StatelessWidget {
  const DataBottomSheet(this.extractedData, this.healthEvaluation, {super.key});

  final Map<String, dynamic> extractedData;
  final Map<String, dynamic> healthEvaluation;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      shouldCloseOnMinExtent: false,
      builder: (context, scrollController) => ListView(
        controller: scrollController,
        children: [
          const Text('Extracted Data'),
          for (var key in extractedData.keys)
            ListTile(
              title: Text(key),
              subtitle: Text(extractedData[key]),
            ),
          const Text('Health Evaluation'),
          for (var key in healthEvaluation.keys)
            ListTile(
              title: Text(key),
              subtitle: Text(healthEvaluation[key]),
            ),
        ],
      ),
    );
  }
}
