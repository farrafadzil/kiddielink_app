import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<void> loadServiceAccount() async {
  try {
    // Load the JSON file
    String jsonString = await rootBundle.loadString('service_account.json');

    // Parse the JSON string
    Map<String, dynamic> serviceAccount = jsonDecode(jsonString);

    // Now you can access fields like project_id, private_key, etc.
    String projectId = serviceAccount['project_id'];
    String privateKey = serviceAccount['private_key'];

    print('Project ID: $projectId');
    print('Private Key: $privateKey');
  } catch (e) {
    print('Error loading service account JSON: $e');
  }
}

// You can add more functions or code related to Firebase here
