import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';
import '../utils/constants.dart';
import 'login_screen.dart';
import 'orders_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final orders = context.watch<OrderProvider>().orders;
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header gradient
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,    // Using theme
                    AppColors.secondary,   // Using theme
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                          Border.all(color: AppColors.surface, width: 2.5), // Using theme
                        ),
                        child: ClipOval(
                          child: user?.image != null
                              ? CachedNetworkImage(
                            imageUrl: user!.image!,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                _AvatarFallback(user.fullName),
                          )
                              : _AvatarFallback(user?.fullName ?? 'User'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.fullName ?? 'Guest User',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.surface), // Using theme
                            ),
                            const SizedBox(height: 3),
                            Text(
                              user?.email ?? '',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.surface.withOpacity(0.75)), // Using theme
                            ),
                            if (user?.phone != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                user!.phone!,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.surface.withOpacity(0.6)), // Using theme
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Stats row
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.textDark.withOpacity(0.06), // Using theme
                        blurRadius: 16,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                        label: 'Orders',
                        value: '${orders.length}',
                        icon: Icons.receipt_long_rounded),
                    Container(
                        width: 1, height: 40, color: AppColors.divider), // Using theme
                    _StatItem(
                        label: 'Wishlist',
                        value: '0',
                        icon: Icons.favorite_rounded),
                    Container(
                        width: 1, height: 40, color: AppColors.divider), // Using theme
                    _StatItem(
                        label: 'Reviews',
                        value: '0',
                        icon: Icons.star_rounded),
                  ],
                ),
              ),
            ),

            // Menu items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _MenuSection(title: 'Account', items: [
                    _MenuItem(
                      icon: Icons.person_outline_rounded,
                      label: 'Personal Information',
                      subtitle: user != null
                          ? '${user.firstName} ${user.lastName}'
                          : '',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.location_on_outlined,
                      label: 'Shipping Address',
                      subtitle: user?.address ?? 'Add address',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.credit_card_rounded,
                      label: 'Payment Methods',
                      subtitle: 'VISA •••• 4242',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _MenuSection(title: 'Shopping', items: [
                    _MenuItem(
                      icon: Icons.receipt_long_outlined,
                      label: 'My Orders',
                      subtitle: '${orders.length} orders',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const OrdersScreen()),
                      ),
                    ),
                    _MenuItem(
                      icon: Icons.favorite_border_rounded,
                      label: 'Wishlist',
                      subtitle: 'Saved items',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.star_border_rounded,
                      label: 'My Reviews',
                      subtitle: 'Rate your purchases',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _MenuSection(title: 'Preferences', items: [
                    _MenuItem(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      subtitle: 'Manage alerts',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.language_rounded,
                      label: 'Language',
                      subtitle: 'English',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.lock_outline_rounded,
                      label: 'Privacy & Security',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.help_outline_rounded,
                      label: 'Help & Support',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 16),

                  // Logout
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          title: Text('Sign Out',
                              style: TextStyle(color: AppColors.textDark)), // Using theme
                          content: Text('Are you sure you want to sign out?',
                              style: TextStyle(color: AppColors.textLight)), // Using theme
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel',
                                    style: TextStyle(color: AppColors.textLight))), // Using theme
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await auth.logout();
                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                        const LoginScreen()),
                                        (_) => false,
                                  );
                                }
                              },
                              child: Text('Sign Out',
                                  style: TextStyle(
                                      color: AppColors.error)), // Using theme
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.06), // Using theme
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.error.withOpacity(0.2)), // Using theme
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded,
                              color: AppColors.error, size: 20), // Using theme
                          const SizedBox(width: 10),
                          Text('Sign Out',
                              style: TextStyle(
                                  color: AppColors.error, // Using theme
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  final String name;
  const _AvatarFallback(this.name);

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase()
        : 'U';
    return Container(
      color: AppColors.primary.withOpacity(0.2), // Using theme
      child: Center(
        child: Text(initials,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.primary)), // Using theme
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _StatItem(
      {required this.label,
        required this.value,
        required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 22), // Using theme
        const SizedBox(height: 6),
        Text(value,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark)), // Using theme
        Text(label,
            style: TextStyle(
                fontSize: 11, color: AppColors.textLight)), // Using theme
      ],
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<Widget> items;
  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(title,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight, // Using theme
                  letterSpacing: 0.5)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface, // Using theme
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.divider), // Using theme
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08), // Using theme
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20), // Using theme
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark)), // Using theme
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Text(subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textLight)), // Using theme
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.textLight, size: 20), // Using theme
          ],
        ),
      ),
    );
  }
}