import 'package:flutter/material.dart';
import '../data/local/app_database.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AppDatabase _database = AppDatabase.instance;
  bool _orderUpdates = true;
  bool _promotions = true;
  bool _location = false;
  bool _biometrics = false;
  String _language = 'English';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final orderUpdates = await _database.getSetting('order_updates');
    final promotions = await _database.getSetting('promotions');
    final location = await _database.getSetting('location');
    final biometrics = await _database.getSetting('biometrics');
    final language = await _database.getSetting('language');

    if (!mounted) {
      return;
    }

    setState(() {
      _orderUpdates = orderUpdates != 'false';
      _promotions = promotions != 'false';
      _location = location == 'true';
      _biometrics = biometrics == 'true';
      _language = language ?? 'English';
    });
  }

  Future<void> _saveSetting(String key, String value) async {
    await _database.setSetting(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildSectionTitle('Notifications'),
            _buildSwitchTile(
              title: 'Order Updates',
              subtitle: 'Track delivery status and driver updates',
              value: _orderUpdates,
              onChanged: (value) {
                setState(() => _orderUpdates = value);
                _saveSetting('order_updates', value.toString());
              },
            ),
            _buildSwitchTile(
              title: 'Promotions',
              subtitle: 'Deals and coupons personalized for you',
              value: _promotions,
              onChanged: (value) {
                setState(() => _promotions = value);
                _saveSetting('promotions', value.toString());
              },
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Security'),
            _buildSwitchTile(
              title: 'Biometric Login',
              subtitle: 'Use fingerprint or face unlock',
              value: _biometrics,
              onChanged: (value) {
                setState(() => _biometrics = value);
                _saveSetting('biometrics', value.toString());
              },
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Personalization'),
            _buildSwitchTile(
              title: 'Location Access',
              subtitle: 'Improve delivery and recommendations',
              value: _location,
              onChanged: (value) {
                setState(() => _location = value);
                _saveSetting('location', value.toString());
              },
            ),
            const SizedBox(height: 8),
            _buildLanguageTile(),
            const SizedBox(height: 16),
            _buildSectionTitle('App'),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('App Version'),
              subtitle: const Text('1.0.0'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF6366F1),
    );
  }

  Widget _buildLanguageTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.language),
      title: const Text('Language'),
      trailing: DropdownButton<String>(
        value: _language,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: 'English', child: Text('English')),
          DropdownMenuItem(value: 'Hindi', child: Text('Hindi')),
          DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
        ],
        onChanged: (value) {
          if (value == null) {
            return;
          }
          setState(() => _language = value);
          _saveSetting('language', value);
        },
      ),
    );
  }
}
