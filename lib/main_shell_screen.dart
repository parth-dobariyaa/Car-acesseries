import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carvora_provider.dart';
import '../theme/carvora_theme.dart';
import 'showcase_screen.dart';
import 'catalog_screen.dart';
import 'wishlist_screen.dart';
import 'cart_screen.dart';
import 'consultation_screen.dart';
import 'admin_login_screen.dart';

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarvoraProvider>();
    final currentIndex = provider.currentNavIndex;
    final isDesktop = MediaQuery.of(context).size.width > 900;

    final screens = const [
      ShowcaseScreen(),
      CatalogScreen(),
      WishlistScreen(),
      CartScreen(),
      ConsultationScreen(),
    ];

    return Scaffold(
      backgroundColor: CarvoraColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: CarvoraColors.surfaceHighlight,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: CarvoraColors.gold, width: 1),
              ),
              child: const Text(
                'C',
                style: TextStyle(
                  color: CarvoraColors.gold,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'CARVORA',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 3.0,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: CarvoraColors.gold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'ATELIER',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: CarvoraColors.gold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Admin console',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
            ),
            icon: const Icon(Icons.admin_panel_settings_outlined, color: Colors.white70),
          ),
          IconButton(
            tooltip: 'Catalog Search',
            onPressed: () => provider.setNavIndex(1),
            icon: const Icon(Icons.search, color: Colors.white70),
          ),
          IconButton(
            tooltip: 'Wishlist',
            onPressed: () => provider.setNavIndex(2),
            icon: Badge(
              isLabelVisible: provider.wishlistIds.isNotEmpty,
              label: Text('${provider.wishlistIds.length}'),
              backgroundColor: Colors.redAccent,
              child: const Icon(Icons.favorite_outline, color: Colors.white70),
            ),
          ),
          IconButton(
            tooltip: 'Bespoke Order',
            onPressed: () => provider.setNavIndex(3),
            icon: Badge(
              isLabelVisible: provider.cartCount > 0,
              label: Text(
                '${provider.cartCount}',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              backgroundColor: CarvoraColors.gold,
              child: const Icon(Icons.shopping_bag_outlined, color: Colors.white70),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          // Desktop Navigation Rail
          if (isDesktop)
            NavigationRail(
              backgroundColor: CarvoraColors.surface,
              selectedIndex: currentIndex,
              onDestinationSelected: (index) => provider.setNavIndex(index),
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: const IconThemeData(color: CarvoraColors.gold),
              unselectedIconTheme: const IconThemeData(color: CarvoraColors.textSecondary),
              selectedLabelTextStyle: const TextStyle(
                color: CarvoraColors.gold,
                fontWeight: FontWeight.w700,
                fontSize: 11,
                letterSpacing: 0.8,
              ),
              unselectedLabelTextStyle: const TextStyle(
                color: CarvoraColors.textMuted,
                fontSize: 11,
              ),
              destinations: [
                const NavigationRailDestination(
                  icon: Icon(Icons.auto_awesome_outlined),
                  selectedIcon: Icon(Icons.auto_awesome),
                  label: Text('Showcase'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(Icons.grid_view),
                  label: Text('Catalog'),
                ),
                NavigationRailDestination(
                  icon: Badge(
                    isLabelVisible: provider.wishlistIds.isNotEmpty,
                    label: Text('${provider.wishlistIds.length}'),
                    backgroundColor: Colors.redAccent,
                    child: const Icon(Icons.favorite_border),
                  ),
                  selectedIcon: const Icon(Icons.favorite),
                  label: const Text('Wishlist'),
                ),
                NavigationRailDestination(
                  icon: Badge(
                    isLabelVisible: provider.cartCount > 0,
                    label: Text('${provider.cartCount}', style: const TextStyle(color: Colors.black)),
                    backgroundColor: CarvoraColors.gold,
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                  selectedIcon: const Icon(Icons.shopping_bag),
                  label: const Text('Order'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.calendar_month_outlined),
                  selectedIcon: Icon(Icons.calendar_month),
                  label: Text('Consultation'),
                ),
              ],
            ),

          // Main View Content
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: CarvoraColors.border),
                ),
              ),
              child: NavigationBar(
                backgroundColor: CarvoraColors.surface,
                indicatorColor: CarvoraColors.gold.withValues(alpha: 0.2),
                selectedIndex: currentIndex,
                onDestinationSelected: (index) => provider.setNavIndex(index),
                destinations: [
                  const NavigationRequestDestination(
                    icon: Icon(Icons.auto_awesome_outlined),
                    selectedIcon: Icon(Icons.auto_awesome, color: CarvoraColors.gold),
                    label: 'Showcase',
                  ),
                  const NavigationRequestDestination(
                    icon: Icon(Icons.grid_view_outlined),
                    selectedIcon: Icon(Icons.grid_view, color: CarvoraColors.gold),
                    label: 'Catalog',
                  ),
                  NavigationRequestDestination(
                    icon: Badge(
                      isLabelVisible: provider.wishlistIds.isNotEmpty,
                      label: Text('${provider.wishlistIds.length}'),
                      backgroundColor: Colors.redAccent,
                      child: const Icon(Icons.favorite_border),
                    ),
                    selectedIcon: const Icon(Icons.favorite, color: Colors.redAccent),
                    label: 'Wishlist',
                  ),
                  NavigationRequestDestination(
                    icon: Badge(
                      isLabelVisible: provider.cartCount > 0,
                      label: Text(
                        '${provider.cartCount}',
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: CarvoraColors.gold,
                      child: const Icon(Icons.shopping_bag_outlined),
                    ),
                    selectedIcon: const Icon(Icons.shopping_bag, color: CarvoraColors.gold),
                    label: 'Order',
                  ),
                  const NavigationRequestDestination(
                    icon: Icon(Icons.calendar_month_outlined),
                    selectedIcon: Icon(Icons.calendar_month, color: CarvoraColors.gold),
                    label: 'VIP',
                  ),
                ],
              ),
            ),
    );
  }
}

class NavigationRequestDestination extends NavigationDestination {
  const NavigationRequestDestination({
    super.key,
    required super.icon,
    super.selectedIcon,
    required super.label,
  });
}
