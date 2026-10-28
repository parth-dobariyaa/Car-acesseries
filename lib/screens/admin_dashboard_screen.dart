import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carvora_provider.dart';
import '../theme/carvora_theme.dart';
import 'admin_login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _section = 0;

  void _logout() {
    context.read<CarvoraProvider>().logoutAdmin();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarvoraProvider>();
    if (!provider.isAdminAuthenticated) {
      return const AdminLoginScreen();
    }
    final isDesktop = MediaQuery.sizeOf(context).width > 850;
    return Scaffold(
      appBar: AppBar(
        title: const Text('CARVORA / ADMIN'),
        actions: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: CarvoraColors.goldMuted,
            child: Icon(Icons.person, color: CarvoraColors.gold, size: 18),
          ),
          IconButton(
            tooltip: 'Sign out',
            onPressed: _logout,
            icon: const Icon(Icons.logout_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          if (isDesktop) _buildRail(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _buildSection(provider),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : NavigationBar(
              selectedIndex: _section,
              onDestinationSelected: (index) => setState(() => _section = index),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Overview'),
                NavigationDestination(icon: Icon(Icons.inventory_2_outlined), label: 'Products'),
                NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Orders'),
                NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: 'Bookings'),
                NavigationDestination(icon: Icon(Icons.people_outline), label: 'Users'),
              ],
            ),
    );
  }

  Widget _buildRail() {
    return NavigationRail(
      backgroundColor: CarvoraColors.surface,
      selectedIndex: _section,
      onDestinationSelected: (index) => setState(() => _section = index),
      labelType: NavigationRailLabelType.all,
      selectedIconTheme: const IconThemeData(color: CarvoraColors.gold),
      unselectedIconTheme: const IconThemeData(color: CarvoraColors.textSecondary),
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), label: Text('Overview')),
        NavigationRailDestination(icon: Icon(Icons.inventory_2_outlined), label: Text('Products')),
        NavigationRailDestination(icon: Icon(Icons.receipt_long_outlined), label: Text('Orders')),
        NavigationRailDestination(icon: Icon(Icons.calendar_month_outlined), label: Text('Bookings')),
        NavigationRailDestination(icon: Icon(Icons.people_outline), label: Text('Users')),
      ],
    );
  }

  Widget _buildSection(CarvoraProvider provider) {
    switch (_section) {
      case 1:
        return _ProductsSection(key: const ValueKey('products'), provider: provider);
      case 2:
        return _OrdersSection(key: const ValueKey('orders'));
      case 3:
        return _ConsultationsSection(key: const ValueKey('consultations'), provider: provider);
      case 4:
        return const _UsersSection(key: ValueKey('users'));
      default:
        return _OverviewSection(key: const ValueKey('overview'), provider: provider);
    }
  }
}

class _AdminPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  const _AdminPage({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 6),
              Text(subtitle, style: const TextStyle(color: CarvoraColors.textSecondary)),
              const SizedBox(height: 28),
              child,
            ]),
          ),
        ),
      );
}

class _OverviewSection extends StatelessWidget {
  final CarvoraProvider provider;
  const _OverviewSection({required this.provider, super.key});

  @override
  Widget build(BuildContext context) => _AdminPage(
        title: 'Good morning, Admin',
        subtitle: 'Here is the latest activity across the atelier.',
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 16, runSpacing: 16, children: [
            _MetricCard(label: 'Catalog items', value: '${provider.allAccessories.length}', icon: Icons.inventory_2_outlined),
            _MetricCard(label: 'Open orders', value: '12', icon: Icons.receipt_long_outlined),
            _MetricCard(label: 'Consultations', value: '${provider.consultations.length}', icon: Icons.calendar_month_outlined),
            const _MetricCard(label: 'Revenue this month', value: '₹1,84,500', icon: Icons.currency_rupee),
          ]),
          const SizedBox(height: 28),
          Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recent activity', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              const _ActivityRow(icon: Icons.shopping_bag_outlined, title: 'New bespoke order #CV-1048', detail: 'Rohan Mehta · 8 minutes ago'),
              const _ActivityRow(icon: Icons.calendar_month_outlined, title: 'Consultation request received', detail: 'Priya Shah · 42 minutes ago'),
              const _ActivityRow(icon: Icons.inventory_2_outlined, title: 'Low stock alert', detail: 'Ambient Lighting Kit · 2 units remaining'),
            ],
          ))),
        ]),
      );
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _MetricCard({required this.label, required this.value, required this.icon});
  @override
  Widget build(BuildContext context) => SizedBox(width: 250, child: Card(child: Padding(
    padding: const EdgeInsets.all(20),
    child: Row(children: [
      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: CarvoraColors.goldMuted, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: CarvoraColors.gold)),
      const SizedBox(width: 14),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: CarvoraColors.textSecondary, fontSize: 12)),
      ]),
    ]),
  )));
}

class _ActivityRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  const _ActivityRow({required this.icon, required this.title, required this.detail});
  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: CarvoraColors.gold),
        title: Text(title),
        subtitle: Text(detail),
      );
}

class _ProductsSection extends StatelessWidget {
  final CarvoraProvider provider;
  const _ProductsSection({required this.provider, super.key});
  @override
  Widget build(BuildContext context) => _AdminPage(
        title: 'Products',
        subtitle: 'Manage the catalog and keep stock levels current.',
        child: Card(child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.allAccessories.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final item = provider.allAccessories[index];
            final stock = provider.inventory[item.id] ?? 0;
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: CircleAvatar(backgroundColor: CarvoraColors.goldMuted, child: Icon(Icons.auto_awesome, color: CarvoraColors.gold)),
              title: Text(item.name),
              subtitle: Text('${item.category} · ₹${item.price.toStringAsFixed(0)}'),
              trailing: SizedBox(width: 130, child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text('$stock in stock', style: TextStyle(color: stock < 5 ? CarvoraColors.warning : CarvoraColors.success)),
                IconButton(
                  tooltip: 'Adjust stock',
                  onPressed: () => _editStock(context, provider, item.id, stock),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                ),
              ])),
            );
          },
        )),
      );

  void _editStock(BuildContext context, CarvoraProvider provider, String id, int current) {
    final controller = TextEditingController(text: '$current');
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update stock'),
        content: TextField(controller: controller, autofocus: true, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantity')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(onPressed: () {
            final quantity = int.tryParse(controller.text);
            if (quantity == null) return;
            provider.updateInventory(id, quantity);
            Navigator.pop(context);
          }, child: const Text('SAVE')),
        ],
      ),
    ).then((_) => controller.dispose());
  }
}

class _OrdersSection extends StatelessWidget {
  const _OrdersSection({super.key});
  @override
  Widget build(BuildContext context) => _AdminPage(
        title: 'Orders',
        subtitle: 'Track current bespoke orders and fulfilment status.',
        child: Card(child: Column(children: const [
          _OrderRow(id: '#CV-1048', customer: 'Rohan Mehta', total: '₹12,498', status: 'Processing'),
          _OrderRow(id: '#CV-1047', customer: 'Ananya Kapoor', total: '₹8,499', status: 'Ready to ship'),
          _OrderRow(id: '#CV-1046', customer: 'Vikram Singh', total: '₹4,499', status: 'Delivered'),
        ])),
      );
}

class _OrderRow extends StatelessWidget {
  final String id, customer, total, status;
  const _OrderRow({required this.id, required this.customer, required this.total, required this.status});
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
    leading: const Icon(Icons.receipt_long_outlined, color: CarvoraColors.gold),
    title: Text('$id · $customer'),
    subtitle: Text(total),
    trailing: Chip(label: Text(status), backgroundColor: CarvoraColors.goldMuted),
  );
}

class _ConsultationsSection extends StatelessWidget {
  final CarvoraProvider provider;
  const _ConsultationsSection({required this.provider, super.key});
  @override
  Widget build(BuildContext context) => _AdminPage(
    title: 'Consultations',
    subtitle: 'Review and follow up on customer appointment requests.',
    child: provider.consultations.isEmpty
        ? const Card(child: Padding(padding: EdgeInsets.all(28), child: Text('No consultation requests yet. New requests will appear here.')))
        : Card(child: ListView.builder(shrinkWrap: true, itemCount: provider.consultations.length, itemBuilder: (_, index) {
            final request = provider.consultations[index];
            return ListTile(
              leading: const Icon(Icons.calendar_month_outlined, color: CarvoraColors.gold),
              title: Text(request.clientName),
              subtitle: Text('${request.vehicleMakeModel} · ${request.serviceInterest}'),
              trailing: Text(request.timeSlot, style: const TextStyle(color: CarvoraColors.textSecondary)),
            );
          })),
  );
}

class _UsersSection extends StatelessWidget {
  const _UsersSection({super.key});
  @override
  Widget build(BuildContext context) => _AdminPage(
    title: 'Users',
    subtitle: 'Customer accounts and engagement overview.',
    child: Card(child: Column(children: const [
      _UserRow(name: 'Rohan Mehta', email: 'rohan.mehta@email.com', orders: '4 orders'),
      _UserRow(name: 'Ananya Kapoor', email: 'ananya.k@email.com', orders: '2 orders'),
      _UserRow(name: 'Priya Shah', email: 'priya.shah@email.com', orders: '1 order'),
    ])),
  );
}

class _UserRow extends StatelessWidget {
  final String name, email, orders;
  const _UserRow({required this.name, required this.email, required this.orders});
  @override
  Widget build(BuildContext context) => ListTile(
    leading: CircleAvatar(backgroundColor: CarvoraColors.surfaceElevated, child: Text(name[0], style: const TextStyle(color: CarvoraColors.gold))),
    title: Text(name),
    subtitle: Text(email),
    trailing: Text(orders, style: const TextStyle(color: CarvoraColors.textSecondary)),
  );
}
