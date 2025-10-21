import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import '../services/login_audit_service.dart';
import '../models/login_audit.dart';

class LoginHistoryView extends StatefulWidget {
  final String userId;

  const LoginHistoryView({Key? key, required this.userId}) : super(key: key);

  @override
  State<LoginHistoryView> createState() => _LoginHistoryViewState();
}

class _LoginHistoryViewState extends State<LoginHistoryView> {
  late Future<List<LoginAudit>> _future;

  @override
  void initState() {
    super.initState();
    _future = LoginAuditService.getLoginsForUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de inicios de sesión'),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _future = LoginAuditService.getLoginsForUser(widget.userId);
          });
          await _future;
        },
        child: FutureBuilder<List<LoginAudit>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.history, size: 56, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'No hay registros de inicio de sesión',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final it = items[index];
                // Convertir a zona local (configurada en main.dart: America/Lima)
                final tzDT = tz.TZDateTime.from(it.timestamp, tz.local);
                final formatted = DateFormat(
                  "d 'de' MMMM yyyy, h:mm:ss a",
                  'es',
                ).format(tzDT);

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.blueAccent.withOpacity(0.15),
                          child: const Icon(
                            Icons.login,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                it.username,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                formatted,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'IP: ${it.ip}${it.deviceInfo != 'unknown' ? ' • ${it.deviceInfo}' : ''}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
