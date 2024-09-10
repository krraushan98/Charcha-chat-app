import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationApi {
  static const String oneSignalRestApiKey =
      'ZmQ5YWE0NjEtZmY3ZS00N2FjLWFlYTAtNjE4NTUzNzkyNDNk';
  static const String oneSignalAppId = '9208bca3-6fb4-4fae-a151-0be6f29ae630';
  initNotificatoins() {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.initialize("9208bca3-6fb4-4fae-a151-0be6f29ae630");
   OneSignal.Notifications.addPermissionObserver((state) {
      print("Has permission " + state.toString());
    });
    OneSignal.Notifications.addForegroundWillDisplayListener((event)
        {
      // Display Notification, send null to not display, send notification to display
      event.preventDefault();
    });
  }

  static Future<void> sendNotification(String title, String message) async {
    const apiUrl = 'https://onesignal.com/api/v1/notifications';
    print(title);
    print(message);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $oneSignalRestApiKey',
    };

    final body = {
      "app_id": "9208bca3-6fb4-4fae-a151-0be6f29ae630",
      "included_segments": ["All"],
      "headings": {"en": title},
      "contents": {"en": message},
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(body),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print(
            'Failed to send notification. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
