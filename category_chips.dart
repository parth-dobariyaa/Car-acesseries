import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/sample_accessories.dart';
import '../providers/carvora_provider.dart';
import '../theme/carvora_theme.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarvoraProvider>();
    final selected = provider.selectedCategory;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: kCarCategories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final cat = kCarCategories[index];
          final isSelected = cat == selected;

          return InkWell(
            onTap: () => provider.setSelectedCategory(cat),
            borderRadius: BorderRadius.circular(22),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [
                          CarvoraColors.goldLight,
                          CarvoraColors.gold,
                        ],
                      )
                    : null,
                color: isSelected ? null : CarvoraColors.surfaceHighlight,
                border: Border.all(
                  color: isSelected ? CarvoraColors.gold : CarvoraColors.border,
                  width: 1.2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: CarvoraColors.gold.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  color: isSelected ? Colors.black : CarvoraColors.textSecondary,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
