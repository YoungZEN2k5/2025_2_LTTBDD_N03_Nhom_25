import 'package:flutter/material.dart';

import 'main.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key, required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final List<String> members = <String>[strings.get('memberOne')];

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(strings.get('aboutTeam'))),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? <Color>[
                        const Color(0xFF0E1A16),
                        const Color(0xFF142823),
                        const Color(0xFF1B3A31),
                      ]
                    : <Color>[
                        const Color(0xFFEFFAF4),
                        const Color(0xFFFDF7EE),
                        const Color(0xFFF1FBF5),
                      ],
              ),
            ),
          ),
          Positioned(
            top: -90,
            right: -50,
            child: _GlowOrb(
              size: 220,
              color: isDark
                  ? const Color(0xFF74D8B1).withValues(alpha: 0.26)
                  : const Color(0xFF8DE2C3).withValues(alpha: 0.30),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -40,
            child: _GlowOrb(
              size: 190,
              color: isDark
                  ? const Color(0xFF5A8DFF).withValues(alpha: 0.16)
                  : const Color(0xFF96B6FF).withValues(alpha: 0.22),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: LinearGradient(
                      colors: isDark
                          ? <Color>[
                              const Color(0xFF2A5A4C),
                              const Color(0xFF133028),
                            ]
                          : <Color>[
                              const Color(0xFF173830),
                              const Color(0xFF2E7B68),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x32000000),
                        blurRadius: 24,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        strings.get('aboutTeam'),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        strings.get('aboutCaption'),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.86),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _InfoCard(
                  title: strings.get('projectName'),
                  icon: Icons.rocket_launch_rounded,
                  child: Text(
                    strings.get('projectValue'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _InfoCard(
                  title: strings.get('teamMembers'),
                  icon: Icons.badge_rounded,
                  child: Column(
                    children: members
                        .map(
                          (String member) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.18),
                                  child: Icon(
                                    Icons.person_rounded,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    member,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                _InfoCard(
                  title: strings.get('description'),
                  icon: Icons.notes_rounded,
                  child: Text(
                    strings.get('descriptionValue'),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(height: 1.45),
                  ),
                ),
                const SizedBox(height: 16),
                _InfoCard(
                  title: strings.get('contact'),
                  icon: Icons.contact_phone_rounded,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        strings.get('contactPhone'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        strings.get('contactEmail'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
            BoxShadow(color: color, blurRadius: 90, spreadRadius: 20),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.22),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
