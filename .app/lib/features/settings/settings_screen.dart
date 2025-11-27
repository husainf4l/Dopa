import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'notifications_settings_screen.dart';
import 'privacy_settings_screen.dart';
import 'export_data_settings_screen.dart';
import 'backup_sync_settings_screen.dart';
import 'language_settings_screen.dart';
import 'account_security_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF8175D1)),
        titleTextStyle: const TextStyle(
          color: Color(0xFF8175D1),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: const Color(0xFFE6E6E6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8175D1),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 40),
              _buildSettingItem(
                'Notifications',
                'Manage notification preferences',
                Icons.notifications_outlined,
                () => context.push('/home/settings/notifications'),
              ),
              _buildSettingItem(
                'Privacy',
                'Control data sharing and privacy settings',
                Icons.lock_outline,
                () => context.push('/home/settings/privacy'),
              ),
              _buildSettingItem(
                'Export Data',
                'Download a copy of your personal data',
                Icons.download_outlined,
                () => context.push('/home/settings/export-data'),
              ),
              _buildSettingItem(
                'Backup & Sync',
                'Manage data backup and synchronization',
                Icons.cloud_outlined,
                () => context.push('/home/settings/backup-sync'),
              ),
              _buildSettingItem(
                'Language',
                'Choose your preferred language',
                Icons.language_outlined,
                () => context.push('/home/settings/language'),
              ),
              _buildSettingItem(
                'Account Security',
                'Manage security and authentication settings',
                Icons.security_outlined,
                () => context.push('/home/settings/account-security'),
              ),
              const SizedBox(height: 40),
              Center(
                child: TextButton(
                  onPressed: () => _showSignOutDialog(context),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF8175D1)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text(
          'Are you sure you want to sign out? You will need to log in again to access your account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement actual sign out logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
