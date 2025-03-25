class NotificationItem {
  final String message;
  final DateTime timestamp;

  NotificationItem({required this.message, required this.timestamp});

  Map<String, dynamic> toJson() => {
    'message': message,
    'timestamp': timestamp.toIso8601String(),
  };

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
    message: json['message'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}
