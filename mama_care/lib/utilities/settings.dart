import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mama_care/services/auth_service.dart';
import 'package:mama_care/constants/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  String selectedLanguage = 'English';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile section
            _buildSectionHeader('Account'),
            _buildSettingsOption(
              context,
              'Profile Information',
              'Edit your personal details',
              Icons.person_outline,
              () => _showProfileDialog(context),
            ),
            _buildSettingsOption(
              context,
              'Change Password',
              'Update your account password',
              Icons.lock_outline,
              () => _showChangePasswordDialog(context),
            ),
            
            const SizedBox(height: 20),
            
            // App settings section
            _buildSectionHeader('Preferences'),
            _buildSettingsOption(
              context,
              'Notifications',
              'Manage your notification preferences',
              Icons.notifications_outlined,
              () => _showNotificationSettings(context),
            ),
            _buildSettingsOption(
              context,
              'Privacy',
              'Adjust your privacy settings',
              Icons.privacy_tip_outlined,
              () => _showPrivacySettings(context),
            ),
            _buildSettingsOption(
              context,
              'Language',
              'Change language settings',
              Icons.language_outlined,
              () => _showLanguageSettings(context),
            ),
            _buildSettingsOption(
              context,
              'Theme',
              'Switch between light and dark mode',
              Icons.color_lens_outlined,
              () => _showThemeSettings(context),
            ),
            
            const SizedBox(height: 20),
            
            // Support section
            _buildSectionHeader('Support'),
            _buildSettingsOption(
              context,
              'Help & Support',
              'Get help and contact support',
              Icons.help_outline,
              () => _showHelpDialog(context),
            ),
            _buildSettingsOption(
              context,
              'About',
              'App version and information',
              Icons.info_outline,
              () => _showAboutDialog(context),
            ),
            
            const SizedBox(height: 30),
            
            // Logout button
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.pink,
        ),
      ),
    );
  }

  Widget _buildSettingsOption(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple, size: 24),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    
    // Pre-fill with current user data if available
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      nameController.text = user.displayName ?? '';
      emailController.text = user.email ?? '';
      phoneController.text = user.phoneNumber ?? '';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  icon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                enabled: false, // Make email field read-only
                decoration: const InputDecoration(
                  labelText: 'Email (cannot be changed)',
                  icon: Icon(Icons.email),
                  filled: true,
                  fillColor: Color(0xFFEEEEEE),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  icon: Icon(Icons.phone),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await user.updateDisplayName(nameController.text);
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating profile: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  icon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  icon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  icon: Icon(Icons.lock_outline),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match!')),
                );
                return;
              }
              
              try {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null && user.email != null) {
                  // Reauthenticate user before changing password
                  final credential = EmailAuthProvider.credential(
                    email: user.email!,
                    password: currentPasswordController.text,
                  );
                  await user.reauthenticateWithCredential(credential);
                  await user.updatePassword(newPasswordController.text);
                  
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password updated successfully!')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating password: $e')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    // Initial values for notification preferences
    bool appointmentReminders = true;
    bool medicationReminders = true;
    bool healthTips = true;
    bool communityUpdates = true;
    bool emergencyAlerts = true;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Notification Settings'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Appointment Reminders'),
                  subtitle: const Text('Get notified about upcoming checkups'),
                  value: appointmentReminders,
                  onChanged: (value) => setState(() => appointmentReminders = value),
                  secondary: const Icon(Icons.calendar_today, color: Colors.pinkAccent),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Medication Reminders'),
                  subtitle: const Text('Reminders for medications and supplements'),
                  value: medicationReminders,
                  onChanged: (value) => setState(() => medicationReminders = value),
                  secondary: const Icon(Icons.medication, color: Colors.pinkAccent),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Health Tips'),
                  subtitle: const Text('Receive daily pregnancy and health tips'),
                  value: healthTips,
                  onChanged: (value) => setState(() => healthTips = value),
                  secondary: const Icon(Icons.tips_and_updates, color: Colors.pinkAccent),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Community Updates'),
                  subtitle: const Text('News and updates from the MamaCare community'),
                  value: communityUpdates,
                  onChanged: (value) => setState(() => communityUpdates = value),
                  secondary: const Icon(Icons.people, color: Colors.pinkAccent),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Emergency Alerts'),
                  subtitle: const Text('Important health and safety alerts'),
                  value: emergencyAlerts,
                  onChanged: (value) => setState(() => emergencyAlerts = value),
                  secondary: const Icon(Icons.warning, color: Colors.pinkAccent),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Save notification preferences to shared preferences or backend
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification preferences updated!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacySettings(BuildContext context) {
    bool shareLocation = false;
    bool shareData = false;
    bool receiveNotifications = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Privacy Settings'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Share Location'),
                  subtitle: const Text('Allow app to access your location'),
                  value: shareLocation,
                  onChanged: (value) => setState(() => shareLocation = value),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Share Usage Data'),
                  subtitle: const Text('Help us improve by sharing usage data'),
                  value: shareData,
                  onChanged: (value) => setState(() => shareData = value),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Receive Notifications'),
                  subtitle: const Text('Get important updates and reminders'),
                  value: receiveNotifications,
                  onChanged: (value) => setState(() => receiveNotifications = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Save privacy settings
                // TODO: Implement privacy settings storage
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Privacy settings updated!')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSettings(BuildContext context) {
    final languages = ['English', 'Swahili', 'French', 'Arabic'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Language Settings'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((language) => 
              ListTile(
                title: Text(language),
                leading: const Icon(Icons.language),
                trailing: Radio<String>(
                  value: language,
                  groupValue: selectedLanguage,
                  onChanged: (value) {
                    setState(() => selectedLanguage = value!);
                    Navigator.pop(context);
                    // Show confirmation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Language changed to $value')),
                    );
                  },
                ),
              ),
            ).toList(),
          ),
        ),
      ),
    );
  }

  void _showThemeSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Light Mode'),
              leading: const Icon(Icons.light_mode),
              trailing: Radio<bool>(
                value: false,
                groupValue: isDarkMode,
                onChanged: (value) {
                  setState(() => isDarkMode = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Dark Mode'),
              leading: const Icon(Icons.dark_mode),
              trailing: Radio<bool>(
                value: true,
                groupValue: isDarkMode,
                onChanged: (value) {
                  setState(() => isDarkMode = value!);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need help? Contact us:'),
            SizedBox(height: 10),
            Text('📧 support@mamacare.com'),
            Text('📞 +1-800-MAMA-CARE'),
            SizedBox(height: 10),
            Text('Or visit our FAQ section in the app.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Mama Care',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.favorite,
        color: Colors.pink,
        size: 48,
      ),
      children: [
        const Text('Your pregnancy journey companion'),
        const SizedBox(height: 10),
        const Text('Providing support and information for expecting mothers.'),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.logout, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Logout'),
          ],
        ),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              AuthService.logout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

