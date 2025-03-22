import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'theme.dart';

// Global notifier for theme mode.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Settings.init(cacheProvider: SharePreferenceCache());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode mode, __) {
        return MaterialApp(
          title: 'Settings Menu',
          themeMode: mode,
          theme: getTheme(false),
          darkTheme: getTheme(true),
          home: const SettingsMenu(),
        );
      },
    );
  }
}

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({Key? key}) : super(key: key);

  @override
  State<SettingsMenu> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<SettingsMenu> {
  bool pushNotificationsEnabled = false;
  bool darkModeEnabled = false;
  String currentUsername = 'user123';

  @override
  void initState() {
    super.initState();
    // Initialize the local state with the global state
    darkModeEnabled = darkModeNotifier.value;

    // Listen for changes from other screens
    darkModeNotifier.addListener(_updateDarkMode);
  }

  @override
  void dispose() {
    darkModeNotifier.removeListener(_updateDarkMode);
    super.dispose();
  }

  void _updateDarkMode() {
    if (mounted && darkModeEnabled != darkModeNotifier.value) {
      setState(() {
        darkModeEnabled = darkModeNotifier.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = getTheme(darkModeEnabled);

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Profile Settings'),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile picture with name pill that displays the current username.
              ProfilePictureName(
                name: currentUsername,
                theme: theme,
              ),
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
                    theme: theme,
                  ),
                  PasswordTile(theme: theme),
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
                    theme: theme,
                  ),
                  DarkModeTile(
                    value: darkModeEnabled,
                    onChanged: (newVal) {
                      setState(() => darkModeEnabled = newVal);
                      themeNotifier.value =
                          newVal ? ThemeMode.dark : ThemeMode.light;
                    },
                    theme: theme,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Logout Button at the bottom
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        theme.colorScheme.secondary.withOpacity(0.2),
                    foregroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 16),
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
      ),
    );
  }
}

/// Profile picture with a name pill. The name is passed in via [name].
class ProfilePictureName extends StatelessWidget {
  final String name;
  final ThemeData theme;

  const ProfilePictureName({
    Key? key,
    required this.name,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile picture placeholder.
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.secondary.withOpacity(0.2),
          ),
          child: Icon(
            Icons.person,
            size: 60,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        // Name "pill" displaying the current username.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            name,
            style: TextStyle(
              color: theme.colorScheme.primary,
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
  final ThemeData theme;

  const UsernameTile({
    Key? key,
    required this.currentUsername,
    required this.onUsernameChanged,
    required this.theme,
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
      theme: theme,
    );
  }
}

/// Password tile opens a change password dialog.
class PasswordTile extends StatelessWidget {
  final ThemeData theme;

  const PasswordTile({
    Key? key,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PurpleRowItem(
      title: 'Password',
      subtitle: 'Change password',
      onTap: () => showDialog(
        context: context,
        builder: (context) => const _ChangePasswordDialog(),
      ),
      theme: theme,
    );
  }
}

/// Push Notifications tile with a switch.
class PushNotificationsTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final ThemeData theme;

  const PushNotificationsTile({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PurpleSwitchRow(
      label: 'Push Notifications',
      value: value,
      onChanged: onChanged,
      theme: theme,
    );
  }
}

/// Dark Mode tile with a switch.
class DarkModeTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final ThemeData theme;

  const DarkModeTile({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PurpleSwitchRow(
      label: 'Dark Mode',
      value: value,
      onChanged: (newVal) {
        onChanged(newVal);
        // Update the global dark mode state
        ThemeHelper.setDarkMode(newVal);
        themeNotifier.value = newVal ? ThemeMode.dark : ThemeMode.light;
      },
      theme: theme,
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
          validator: (password) => (password != null && password.length >= 6)
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

/// Helper widget: A themed row with title, subtitle, and an arrow.
class _PurpleRowItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final ThemeData theme;

  const _PurpleRowItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary.withOpacity(0.2),
          borderRadius: const BorderRadius.only(
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
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: theme.colorScheme.primary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper widget: A themed row with a label and a switch.
class _PurpleSwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final ThemeData theme;

  const _PurpleSwitchRow({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.2),
        borderRadius: const BorderRadius.only(
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
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Switch(
            activeColor: theme.colorScheme.primary,
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
