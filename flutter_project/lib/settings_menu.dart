import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

// Global notifier for theme mode.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({Key? key}) : super(key: key);
  
  @override
  State<SettingsMenu> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<SettingsMenu> {
  bool pushNotificationsEnabled = false;
  bool darkModeEnabled = false;
  String currentUsername = 'weyfhnsfns';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Customize as needed
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // If you have a main page to go back to, pop this route:
            Navigator.pop(context);
            // Or do something else like navigate to a new page:
            // Navigator.push(context, MaterialPageRoute(builder: (_) => MainPage()));
          },
        ),
        title: const Text('Profile Settings'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Dark purple
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile picture with name pill that displays the current username.
            ProfilePictureName(name: currentUsername),
            const SizedBox(height: 24),
            
            // Personal Information Group
            SettingsGroup(
              title: 'Personal information',
              children: [
                UsernameTile(
                  currentUsername: currentUsername,
                  onUsernameChanged: (newUsername) {
                    setState(() {
                      currentUsername = newUsername;
                    });
                  },
                ),
                const PasswordTile(),
              ],
            ),
            const SizedBox(height: 24),
            
            // Preferences Group
            SettingsGroup(
              title: 'Preferences',
              children: [
                PushNotificationsTile(
                  value: pushNotificationsEnabled,
                  onChanged: (newVal) {
                    setState(() => pushNotificationsEnabled = newVal);
                  },
                ),
                DarkModeTile(
                  value: darkModeEnabled,
                  onChanged: (newVal) {
                    setState(() => darkModeEnabled = newVal);
                    themeNotifier.value =
                        newVal ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Logout Button at the bottom
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEADDFF), // Light purple background
                  foregroundColor: const Color(0xFF65558F), // Dark purple text
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  // Handle logout logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out')),
                  );
                },
                child: const Text(
                  'Log out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Profile picture with a name pill. The name is passed in via [name].
class ProfilePictureName extends StatelessWidget {
  final String name;
  
  const ProfilePictureName({
    Key? key,
    required this.name,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile picture placeholder.
        Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFEADDFF),
          ),
          child: const Icon(
            Icons.person,
            size: 60,
            color: Color(0xFF65558F),
          ),
        ),
        const SizedBox(height: 16),
        // Name "pill" displaying the current username.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEADDFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            name,
            style: const TextStyle(
              color: Color(0xFF65558F),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

/// Username tile opens a change username dialog.
class UsernameTile extends StatelessWidget {
  final String currentUsername;
  final ValueChanged<String> onUsernameChanged;
  
  const UsernameTile({
    Key? key,
    required this.currentUsername,
    required this.onUsernameChanged,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return _PurpleRowItem(
      title: 'Username',
      subtitle: 'Change username',
      onTap: () => showDialog(
        context: context,
        builder: (context) => ChangeUsernameDialog(
          currentUsername: currentUsername,
          onUsernameChanged: onUsernameChanged,
        ),
      ),
    );
  }
}

/// Password tile opens a change password dialog.
class PasswordTile extends StatelessWidget {
  const PasswordTile({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return _PurpleRowItem(
      title: 'Password',
      subtitle: 'Change password',
      onTap: () => showDialog(
        context: context,
        builder: (context) => const _ChangePasswordDialog(),
      ),
    );
  }
}

/// Push Notifications tile with a switch.
class PushNotificationsTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  
  const PushNotificationsTile({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return _PurpleSwitchRow(
      label: 'Push Notifications',
      value: value,
      onChanged: onChanged,
    );
  }
}

/// Dark Mode tile with a switch.
class DarkModeTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  
  const DarkModeTile({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return _PurpleSwitchRow(
      label: 'Dark Mode',
      value: value,
      onChanged: onChanged,
    );
  }
}

/// Dialog for changing the password.
class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog({Key? key}) : super(key: key);
  
  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  String _newPassword = '';
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose a new password'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          obscureText: true,
          decoration: const InputDecoration(labelText: 'New password'),
          validator: (password) =>
              (password != null && password.length >= 6)
                  ? null
                  : 'Password must be at least 6 characters',
          onChanged: (value) => _newPassword = value,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              // Implement password change logic if needed.
              Navigator.pop(context);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

/// Dialog for changing the username with validation.
class ChangeUsernameDialog extends StatefulWidget {
  final String currentUsername;
  final ValueChanged<String> onUsernameChanged;
  
  const ChangeUsernameDialog({
    Key? key,
    required this.currentUsername,
    required this.onUsernameChanged,
  }) : super(key: key);
  
  @override
  State<ChangeUsernameDialog> createState() => _ChangeUsernameDialogState();
}

class _ChangeUsernameDialogState extends State<ChangeUsernameDialog> {
  final _formKey = GlobalKey<FormState>();
  String _newUsername = '';
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose a new username'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: const InputDecoration(labelText: 'New username'),
          validator: (username) {
            if (username == null || username.isEmpty) {
              return 'Username cannot be empty';
            }
            if (username == widget.currentUsername) {
              return 'Please choose a different username';
            }
            if (username.length > 15) {
              return 'Username must be 15 characters or fewer';
            }
            if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(username)) {
              return 'Only letters and numbers allowed';
            }
            return null;
          },
          onChanged: (value) => _newUsername = value,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              widget.onUsernameChanged(_newUsername);
              Navigator.pop(context);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

/// Helper widget: A purple row with title, subtitle, and an arrow.
class _PurpleRowItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  
  const _PurpleRowItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFEADDFF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF65558F),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper widget: A purple row with a label and a switch.
class _PurpleSwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  
  const _PurpleSwitchRow({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFEADDFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Switch(
            activeColor: const Color(0xFF65558F),
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}



