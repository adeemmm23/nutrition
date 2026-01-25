import 'package:flutter/material.dart';

class DataBottomSheet extends StatelessWidget {
  const DataBottomSheet(
      this.extractedData, this.healthEvaluation, this.allergiesFound,
      {super.key});

  final Map<String, dynamic> extractedData;
  final Map<String, dynamic> healthEvaluation;
  final Map<String, dynamic> allergiesFound;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      shouldCloseOnMinExtent: false,
      snapSizes: const [0.5],
      snapAnimationDuration: const Duration(milliseconds: 200),
      builder: (context, scrollController) => ListView(
        controller: scrollController,
        children: [
          const DataTitle('Extracted Data'),
          for (var key in extractedData.keys)
            ListTile(
              title: Text(key.replaceAll('_', ' ').toLowerCase()),
              subtitle: Text(extractedData[key]),
            ),
          const Divider(
            endIndent: 30,
            indent: 30,
            height: 40,
          ),
          const DataTitle('Health Evaluation'),
          for (var key in healthEvaluation.keys)
            ListTile(
              title: Text(key.replaceAll('_', ' ').toLowerCase()),
              subtitle: Text(healthEvaluation[key] ?? 'N/A'),
            ),
          const Divider(
            endIndent: 30,
            indent: 30,
            height: 40,
          ),
          const DataTitle('Allergies Found'),
          for (var key in allergiesFound.keys)
            ListTile(
              title: Text(key.replaceAll('_', ' ').toLowerCase()),
              subtitle: Text(allergiesFound[key] ?? 'N/A'),
            ),
        ],
      ),
    );
  }
}

class DataTitle extends StatelessWidget {
  const DataTitle(this.text, {super.key});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }
}
