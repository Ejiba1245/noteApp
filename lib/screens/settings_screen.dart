import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfile(),
            const SizedBox(height: 24),
            const Text('GENERAL', style: TextStyle(color: AppTheme.primary, letterSpacing: 1.5, fontSize: 12)),
            const SizedBox(height: 8),
            _buildGeneralSettings(),
            const SizedBox(height: 24),
            const Text('AI ENGINE (GEMINI)', style: TextStyle(color: AppTheme.primary, letterSpacing: 1.5, fontSize: 12)),
            const SizedBox(height: 8),
            _buildAIConfig(),
            const SizedBox(height: 24),
            const Text('DATA & EXPORT', style: TextStyle(color: AppTheme.primary, letterSpacing: 1.5, fontSize: 12)),
            const SizedBox(height: 8),
            _buildDataSettings(),
            const SizedBox(height: 40),
            const Center(child: Text('Version 2.4.0 (Stable)', style: TextStyle(color: Colors.white24, fontSize: 12))),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppTheme.primaryContainer,
            child: const Text('JD', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Jordan Decker', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('jordan.decker@intelligence.ai', style: TextStyle(color: AppTheme.onSurfaceVariant)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.edit, color: AppTheme.onSurfaceVariant), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return GlassCard(
      child: Column(
        children: [
          _settingItem(Icons.dark_mode, 'Theme', trailing: Switch(value: true, onChanged: (_) {}, activeColor: AppTheme.primaryContainer)),
          _settingItem(Icons.notifications, 'Notification settings'),
          _settingItem(Icons.database, 'Storage management', subtitle: '1.2 GB / 5 GB'),
        ],
      ),
    );
  }

  Widget _buildAIConfig() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gemini API Key', style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                  child: const Text('••••••••••••••••', style: TextStyle(color: AppTheme.primary)),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(color: AppTheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
                child: IconButton(icon: const Icon(Icons.key, color: Colors.white), onPressed: () {}),
              )
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              Text('Usage Limit (Requests/Min)', style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12)),
              Text('42/60', style: TextStyle(color: AppTheme.secondary, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: 0.7, backgroundColor: Colors.white10, color: AppTheme.primary),
        ],
      ),
    );
  }

  Widget _buildDataSettings() {
    return GlassCard(
      child: Column(
        children: [
          _settingItem(Icons.picture_as_pdf, 'Export to PDF', trailing: const Icon(Icons.download, color: AppTheme.primary)),
          _settingItem(Icons.cloud_sync, 'Sync Backup', trailing: const Text('Up to date', style: TextStyle(color: AppTheme.secondary, fontSize: 12))),
          _settingItem(Icons.delete_forever, 'Delete Account', color: Colors.redAccent),
        ],
      ),
    );
  }

  Widget _settingItem(IconData icon, String title, {Widget? trailing, String? subtitle, Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppTheme.onSurfaceVariant),
      title: Text(title, style: TextStyle(color: color ?? AppTheme.onSurface)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.white24, fontSize: 12)) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.white12),
    );
  }
}
