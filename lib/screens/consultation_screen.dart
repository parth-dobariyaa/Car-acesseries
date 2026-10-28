import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/consultation.dart';
import '../providers/carvora_provider.dart';
import '../theme/carvora_theme.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Rohit Sharma');
  final _emailController = TextEditingController(text: 'rohit.sharma@gmail.com');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  final _notesController = TextEditingController();

  String _selectedVehicle = 'Mahindra Thar / Thar Roxx';
  String _selectedService = 'Complete Interior Package (7D Mats + Seat Covers + Ambient Light)';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 3));
  String _selectedTimeSlot = '2:30 PM (Doorstep / Atelier Fitment)';

  final List<String> _vehicles = [
    'Mahindra Thar / Thar Roxx',
    'Hyundai Creta',
    'Mahindra Scorpio-N / Classic',
    'Maruti Suzuki Swift',
    'Tata Nexon / Curvv',
    'Maruti Suzuki Brezza',
    'Toyota Fortuner / Legender',
    'Kia Seltos / Sonet',
    'Universal / All Other Cars',
  ];

  final List<String> _services = [
    'Complete Interior Package (7D Mats + Seat Covers + Ambient Light)',
    'Dual 4K Dash Cam Installation & Concealed Hardwire',
    'Custom-Fit Nappa Leatherette Seat Cover Fitment',
    'All-Weather Protection & Body Cover Bundle',
    'Full Car Accessories Makeover',
  ];

  final List<String> _timeSlots = [
    '10:30 AM (Morning Slot)',
    '2:30 PM (Doorstep / Atelier Fitment)',
    '5:30 PM (Evening Slot)',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = ConsultationRequest(
        id: 'REQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        clientName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        vehicleMakeModel: _selectedVehicle,
        serviceInterest: _selectedService,
        preferredDate: _selectedDate,
        timeSlot: _selectedTimeSlot,
        notes: _notesController.text.trim(),
      );

      final provider = context.read<CarvoraProvider>();
      provider.submitConsultation(request);

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: CarvoraColors.surfaceElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: CarvoraColors.gold, width: 1.2),
          ),
          title: const Row(
            children: [
              Icon(Icons.workspace_premium, color: CarvoraColors.gold, size: 28),
              SizedBox(width: 12),
              Text(
                'CONSULTATION RESERVED',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirmation #${request.id}',
                style: const TextStyle(
                  color: CarvoraColors.cyanAccent,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Our Master Vehicle Engineer has received your reservation for ${request.vehicleMakeModel}. You will receive private access details and telemetry pre-check documents via ${request.email}.',
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: CarvoraColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CarvoraColors.surfaceHighlight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: CarvoraColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Slot: ${request.timeSlot}',
                        style: const TextStyle(color: CarvoraColors.gold, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('EXCELLENT'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 120)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: CarvoraColors.gold,
              onPrimary: Colors.black,
              surface: CarvoraColors.surfaceElevated,
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: CarvoraColors.surfaceElevated,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarvoraProvider>();
    final consultations = provider.consultations;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1B2335),
                    Color(0xFF10141E),
                  ],
                ),
                border: Border.all(color: CarvoraColors.borderHighlight.withValues(alpha: 0.5)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.stars, color: CarvoraColors.gold, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'VIP ATELIER SESSIONS',
                        style: TextStyle(
                          color: CarvoraColors.gold,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'BESPOKE CONSULTATION',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Collaborate directly with our master designers, CFD aerodynamicists, and acoustic engineers to tailor 1-of-1 enhancements for your vehicle.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: CarvoraColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Vehicle Selection
            const Text(
              'TARGET VEHICLE PLATFORM',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: CarvoraColors.cyanAccent,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedVehicle,
              dropdownColor: CarvoraColors.surfaceElevated,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.directions_car, color: CarvoraColors.gold),
              ),
              items: _vehicles
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedVehicle = val);
              },
            ),
            const SizedBox(height: 20),

            // Enhancement Focus
            const Text(
              'PRIMARY ENHANCEMENT FOCUS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: CarvoraColors.cyanAccent,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedService,
              dropdownColor: CarvoraColors.surfaceElevated,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.tune, color: CarvoraColors.gold),
              ),
              items: _services
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedService = val);
              },
            ),
            const SizedBox(height: 20),

            // Date & Slot Selection
            const Text(
              'RESERVATION DATE & TIME',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: CarvoraColors.cyanAccent,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: CarvoraColors.surfaceHighlight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: CarvoraColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: CarvoraColors.gold),
                          const SizedBox(width: 10),
                          Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timeSlots.map((slot) {
                final isSelected = slot == _selectedTimeSlot;
                return ChoiceChip(
                  label: Text(
                    slot,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.black : CarvoraColors.textSecondary,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: CarvoraColors.gold,
                  backgroundColor: CarvoraColors.surfaceHighlight,
                  onSelected: (val) {
                    if (val) setState(() => _selectedTimeSlot = slot);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Contact Info
            const Text(
              'CLIENT DETAILS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: CarvoraColors.cyanAccent,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline, color: CarvoraColors.gold),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email_outlined, color: CarvoraColors.gold),
              ),
              validator: (v) => (v == null || !v.contains('@')) ? 'Valid email required' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Direct Phone / WhatsApp',
                prefixIcon: Icon(Icons.phone_outlined, color: CarvoraColors.gold),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Phone required' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Specific Enhancements & Target Specifications (Optional)',
                hintText: 'e.g., custom matte gold weave, high-downforce wing profile, track alignment...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.calendar_month, size: 20),
                label: const Text('CONFIRM BESPOKE CONSULTATION'),
              ),
            ),

            // Past Consultations list
            if (consultations.isNotEmpty) ...[
              const SizedBox(height: 36),
              const Text(
                'YOUR ACTIVE RESERVATIONS',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ...consultations.map((c) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: CarvoraColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: CarvoraColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.vehicleMakeModel,
                              style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${c.serviceInterest} • ${c.timeSlot}',
                              style: const TextStyle(fontSize: 12, color: CarvoraColors.textSecondary),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: CarvoraColors.surfaceHighlight,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: CarvoraColors.gold.withValues(alpha: 0.6)),
                          ),
                          child: const Text(
                            'CONFIRMED',
                            style: TextStyle(
                              color: CarvoraColors.gold,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
