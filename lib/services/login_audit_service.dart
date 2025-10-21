import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../models/login_audit.dart';

class LoginAuditService {
  static Future<void> logLogin({
    required String userId,
    required String username,
    required DateTime timestamp,
    required String ip,
    required String deviceInfo,
  }) async {
    print('🔔 logLogin called for userId=$userId username=$username');
    String ipToStore = ip;
    if (ipToStore.isEmpty || ipToStore == 'unknown') {
      try {
        ipToStore = await _fetchPublicIp();
      } catch (_) {
        ipToStore = 'unknown';
      }
    }

    final data = {
      'userId': userId,
      'username': username,
      'timestamp': Timestamp.fromDate(timestamp),
      'ip': ipToStore,
      'deviceInfo':
          deviceInfo.isNotEmpty && deviceInfo != 'unknown'
              ? deviceInfo
              : 'unknown',
    };

    try {
      print('🔔 Escribiendo documento audit en Firestore con data=$data');
      final ref = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .collection('login_audits');
      await ref.add(data);
      print('\u2705 Login audit registrado para $username');
    } catch (e) {
      print('Error registrando login audit: $e');
    }
  }

  static Future<List<LoginAudit>> getLoginsForUser(String userId) async {
    try {
      final ref = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .collection('login_audits')
          .orderBy('timestamp', descending: true);

      final query = await ref.get();
      return query.docs.map((d) => LoginAudit.fromDoc(d)).toList();
    } catch (e) {
      print('Error obteniendo login audits: $e');
      return [];
    }
  }

  static Future<String> _fetchPublicIp() async {
    try {
      final uri = Uri.parse('https://api.ipify.org?format=json');
      final resp = await http.get(uri).timeout(const Duration(seconds: 3));
      if (resp.statusCode == 200) {
        final m = jsonDecode(resp.body) as Map<String, dynamic>;
        final ip = m['ip'] as String?;
        if (ip != null && ip.isNotEmpty) return ip;
      }
      return 'unknown';
    } catch (e) {
      print('Advertencia: fallo al obtener IP pública: $e');
      return 'unknown';
    }
  }
}
