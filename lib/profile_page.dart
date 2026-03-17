import 'package:flutter/material.dart';

import 'models.dart';
import 'main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.strings,
    required this.profile,
    required this.onUpdateProfile,
  });

  final AppStrings strings;
  final UserProfile profile;
  final void Function(UserProfile profile) onUpdateProfile;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  int _avatarSeed = 0;

  static const List<Color> _palette = <Color>[
    Color(0xFF1F6F5C),
    Color(0xFF2B7AAA),
    Color(0xFFAA6B2B),
    Color(0xFF8A3FAE),
    Color(0xFFB4475C),
    Color(0xFF4F8F3D),
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.profile.name;
    _emailController.text = widget.profile.email;
    _avatarSeed = widget.profile.avatarSeed;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return widget.strings.get('validationEmpty');
    }
    return null;
  }

  String? _email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return widget.strings.get('validationEmpty');
    }
    final bool valid = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(value.trim());
    return valid ? null : widget.strings.get('invalidEmail');
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.onUpdateProfile(
      UserProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        avatarSeed: _avatarSeed,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(widget.strings.get('profileUpdatedSuccess'))),
      );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? <Color>[
                      const Color(0xFF121E1B),
                      const Color(0xFF163228),
                      const Color(0xFF1D3D34),
                    ]
                  : <Color>[
                      const Color(0xFFE8F7EF),
                      const Color(0xFFF8F1E8),
                      const Color(0xFFF2FAF6),
                    ],
            ),
          ),
        ),
        Positioned(
          top: -70,
          left: -20,
          child: _GlowOrb(
            size: 170,
            color: isDark
                ? const Color(0xFF93B1FF).withValues(alpha: 0.18)
                : const Color(0xFFB9CBFF).withValues(alpha: 0.24),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? <Color>[
                              const Color(0xFF21473B),
                              const Color(0xFF153028),
                            ]
                          : <Color>[
                              const Color(0xFF1E3F36),
                              const Color(0xFF2D6D5D),
                            ],
                    ),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x25000000),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.strings.get('profile'),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: <Widget>[
                            Align(
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: _palette[_avatarSeed]
                                    .withValues(alpha: 0.2),
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 40,
                                  color: _palette[_avatarSeed],
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: List<Widget>.generate(_palette.length, (
                                int index,
                              ) {
                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => _avatarSeed = index),
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: _palette[index],
                                    child: _avatarSeed == index
                                        ? const Icon(
                                            Icons.check_rounded,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _nameController,
                              validator: _required,
                              decoration: InputDecoration(
                                labelText: widget.strings.get('name'),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _emailController,
                              validator: _email,
                              decoration: InputDecoration(
                                labelText: widget.strings.get('email'),
                              ),
                            ),
                            const SizedBox(height: 18),
                            FilledButton.icon(
                              onPressed: _save,
                              icon: const Icon(Icons.save_rounded),
                              label: Text(widget.strings.get('save')),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(color: color, blurRadius: 90, spreadRadius: 12),
          ],
        ),
      ),
    );
  }
}
