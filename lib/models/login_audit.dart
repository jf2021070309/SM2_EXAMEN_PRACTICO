import 'package:cloud_firestore/cloud_firestore.dart';

class LoginAudit {
  final String id;
  final String userId;
  final String username;
  final DateTime timestamp;
  final String ip;
  final String deviceInfo;

  LoginAudit({
    required this.id,
    required this.userId,
    required this.username,
    required this.timestamp,
    required this.ip,
    required this.deviceInfo,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'username': username,
    'timestamp': Timestamp.fromDate(timestamp),
    'ip': ip,
    'deviceInfo': deviceInfo,
  };

  static LoginAudit fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final ts = data['timestamp'] as Timestamp?;
    final dt = ts != null ? ts.toDate() : DateTime.now();
    // Forzar conversión a hora local para evitar inconsistencias de zona
    // horaria que pueden ocurrir según cómo el Timestamp se marque (UTC/local).
    final localDt = dt.toLocal();
    return LoginAudit(
      id: doc.id,
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      timestamp: localDt,
      ip: data['ip'] ?? 'unknown',
      deviceInfo: data['deviceInfo'] ?? 'unknown',
    );
  }
}
