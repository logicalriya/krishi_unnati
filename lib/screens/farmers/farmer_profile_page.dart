import 'package:flutter/material.dart';

import '../../state/app_locale.dart';
import '../../state/app_session.dart';
import '../../welcome/startup.dart';

class FarmerProfilePage extends StatelessWidget {
  const FarmerProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    await AppSession.of(context).logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const StartupPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocale.of(context).t;
    final user = AppSession.of(context).user;
    final name = (user?['fullName'] ?? 'Farmer').toString();
    final phone = (user?['phone'] ?? '').toString();
    final village = (user?['village'] ?? '').toString();
    final district = (user?['district'] ?? '').toString();
    final location = [village, district]
        .where((value) => value.isNotEmpty)
        .join(', ');

    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF172033),
        elevation: 0,
        title: Text(
          t('myProfile'),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0B8F4D),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 29,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Text(
                    name.trim().isEmpty ? 'F' : name.trim()[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (phone.isNotEmpty)
                        Text(
                          phone,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.86),
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _sectionCard(
            title: t('profile'),
            children: [
              _infoRow(Icons.person_outline, t('fullName'), name),
              if (phone.isNotEmpty) _infoRow(Icons.phone_outlined, t('phoneNumber'), phone),
              if (location.isNotEmpty)
                _infoRow(Icons.location_on_outlined, t('locationCol'), location),
            ],
          ),
          const SizedBox(height: 14),
          _sectionCard(
            title: t('settings'),
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.language_outlined, color: Color(0xFF0B8F4D)),
                title: Text(t('selectLanguage')),
                subtitle: Text(AppLocale.of(context).language.displayName),
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<AppLanguage>(
                    value: AppLocale.of(context).language,
                    items: AppLanguage.values
                        .map(
                          (language) => DropdownMenuItem(
                            value: language,
                            child: Text(language.displayName),
                          ),
                        )
                        .toList(),
                    onChanged: (language) {
                      if (language != null) {
                        AppLocale.of(context).setLanguage(language);
                      }
                    },
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout, color: Color(0xFFB42318)),
                title: Text(
                  t('logout'),
                  style: const TextStyle(
                    color: Color(0xFFB42318),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () => _logout(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCE8DF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF195B37),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: const Color(0xFF607064), size: 20),
      title: Text(
        label,
        style: const TextStyle(fontSize: 11, color: Color(0xFF6A727D)),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF1E2B38),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
