import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/data/models/barcode_product_model.dart';
import 'package:e_commerce_startup_web/presentation/pages/barcode/viewmodel/barcode_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BarcodePage extends StatelessWidget {
  static const String path = '/barcode';

  const BarcodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BarcodeViewmodel(),
      child: Consumer<BarcodeViewmodel>(
        builder: (_, vm, __) => DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: const Color(0xFFF4F6FA),
            appBar: _buildAppBar(),
            body: TabBarView(
              children: [
                _CreateTab(vm: vm),
                _LookupTab(vm: vm),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(49),
        child: Column(
          children: [
            Container(height: 1, color: const Color(0xFFE5E7EB)),
            const TabBar(
              labelColor: Color(0xFFF97316),
              unselectedLabelColor: Color(0xFF6B7280),
              indicatorColor: Color(0xFFF97316),
              indicatorWeight: 2.5,
              labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              tabs: [
                Tab(text: 'Create Product'),
                Tab(text: 'Lookup by Barcode'),
              ],
            ),
          ],
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              CupertinoIcons.barcode,
              size: 18,
              color: Color(0xFFF97316),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Barcode Products',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CREATE TAB
// ─────────────────────────────────────────────────────────────────────────────
class _CreateTab extends StatefulWidget {
  final BarcodeViewmodel vm;
  const _CreateTab({required this.vm});

  @override
  State<_CreateTab> createState() => _CreateTabState();
}

class _CreateTabState extends State<_CreateTab> {
  final _barcodeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _ingredientCtrl = TextEditingController();
  final List<String> _ingredients = [];
  bool _isHalal = false;

  @override
  void dispose() {
    _barcodeCtrl.dispose();
    _nameCtrl.dispose();
    _ingredientCtrl.dispose();
    super.dispose();
  }

  void _addIngredient() {
    final val = _ingredientCtrl.text.trim();
    if (val.isEmpty) return;
    setState(() {
      _ingredients.add(val);
      _ingredientCtrl.clear();
    });
  }

  void _removeIngredient(int i) => setState(() => _ingredients.removeAt(i));

  Future<void> _submit() async {
    if (_barcodeCtrl.text.trim().isEmpty || _nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Barcode and product name are required.'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    await widget.vm.createBarcodeProduct(
      barcode: _barcodeCtrl.text.trim(),
      nameEn: _nameCtrl.text.trim(),
      ingredients: List.from(_ingredients),
      isHalal: _isHalal,
    );

    if (!mounted) return;
    if (widget.vm.formzStatus == FormzSubmissionStatus.success) {
      // clear form
      _barcodeCtrl.clear();
      _nameCtrl.clear();
      setState(() {
        _ingredients.clear();
        _isHalal = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Barcode product created successfully.'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.vm.formzStatus == FormzSubmissionStatus.inProgress;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFF97316), Color(0xFFFB923C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          CupertinoIcons.barcode,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Create Barcode Product',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Barcode
                      _buildTextField(
                        controller: _barcodeCtrl,
                        label: 'Barcode *',
                        hint: 'e.g. 8801234567890',
                        icon: CupertinoIcons.barcode_viewfinder,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Product name
                      _buildTextField(
                        controller: _nameCtrl,
                        label: 'Product Name (English) *',
                        hint: 'e.g. Lotte Choco Pie',
                        icon: CupertinoIcons.tag,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 20),

                      // isHalal toggle
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: _isHalal
                              ? const Color(0xFFF0FDF4)
                              : const Color(0xFFF8F9FC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _isHalal
                                ? const Color(0xFF86EFAC)
                                : const Color(0xFFE5E7EB),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.checkmark_seal,
                              size: 18,
                              color: _isHalal
                                  ? Colors.green.shade600
                                  : Colors.grey.shade400,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Certified Halal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: _isHalal
                                          ? Colors.green.shade700
                                          : const Color(0xFF374151),
                                    ),
                                  ),
                                  Text(
                                    'Admin confirms this product is halal certified',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _isHalal,
                              onChanged: isLoading
                                  ? null
                                  : (v) => setState(() => _isHalal = v),
                              activeColor: Colors.green.shade600,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Ingredients
                      const Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _ingredientCtrl,
                              label: 'Add ingredient',
                              hint: 'e.g. Sugar, Wheat flour...',
                              enabled: !isLoading,
                              onSubmitted: (_) => _addIngredient(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: isLoading ? null : _addIngredient,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFF97316),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Icon(Icons.add, size: 18),
                          ),
                        ],
                      ),
                      if (_ingredients.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(
                            _ingredients.length,
                            (i) => Chip(
                              label: Text(
                                _ingredients[i],
                                style: const TextStyle(fontSize: 12),
                              ),
                              deleteIcon: const Icon(Icons.close, size: 14),
                              onDeleted: isLoading
                                  ? null
                                  : () => _removeIngredient(i),
                              backgroundColor: const Color(0xFFFFF3E0),
                              deleteIconColor: const Color(0xFFF97316),
                              side: const BorderSide(color: Color(0xFFFED7AA)),
                              labelStyle: const TextStyle(
                                color: Color(0xFF92400E),
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: isLoading ? null : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFF97316),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Create Product',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOOKUP TAB
// ─────────────────────────────────────────────────────────────────────────────
class _LookupTab extends StatefulWidget {
  final BarcodeViewmodel vm;
  const _LookupTab({required this.vm});

  @override
  State<_LookupTab> createState() => _LookupTabState();
}

class _LookupTabState extends State<_LookupTab> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        widget.vm.lookupStatus == FormzSubmissionStatus.inProgress;
    final product = widget.vm.lookedUpProduct;
    final isFailure = widget.vm.lookupStatus == FormzSubmissionStatus.failure;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              // Search bar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _searchCtrl,
                        label: 'Barcode',
                        hint: 'Enter barcode number...',
                        icon: CupertinoIcons.search,
                        enabled: !isLoading,
                        onSubmitted: (_) => widget.vm.lookupBarcodeProduct(
                          _searchCtrl.text.trim(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      onPressed: isLoading
                          ? null
                          : () => widget.vm.lookupBarcodeProduct(
                              _searchCtrl.text.trim(),
                            ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFF97316),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Search',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Result
              if (isFailure)
                _buildNotFound()
              else if (product != null)
                _buildProductCard(product),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotFound() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Icon(CupertinoIcons.barcode, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          const Text(
            'Product not found',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No product registered with that barcode.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BarcodeProductModel product) {
    final status = product.halalStatus ?? '';
    final (statusColor, statusBg, statusIcon) = switch (status) {
      'HALAL' => (
        Colors.green.shade700,
        Colors.green.shade50,
        CupertinoIcons.checkmark_seal_fill,
      ),
      'HARAM' => (
        Colors.red.shade700,
        Colors.red.shade50,
        CupertinoIcons.xmark_seal_fill,
      ),
      'SUSPICIOUS' => (
        Colors.orange.shade700,
        Colors.orange.shade50,
        CupertinoIcons.exclamationmark_triangle_fill,
      ),
      _ => (
        Colors.grey.shade600,
        Colors.grey.shade100,
        CupertinoIcons.question_circle_fill,
      ),
    };

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 22),
                const SizedBox(width: 10),
                Text(
                  status.replaceAll('_', ' '),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                if (product.isHalal == true)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Halal Certified',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + barcode
                Text(
                  product.name?.en ?? '—',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.barcode ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 16),

                // Reason
                if (product.reason?.isNotEmpty == true) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: statusColor.withOpacity(0.2)),
                    ),
                    child: Text(
                      product.reason!,
                      style: TextStyle(
                        fontSize: 12,
                        color: statusColor,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Ingredients
                if (product.ingredients?.isNotEmpty == true) ...[
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: product.ingredients!
                        .map(
                          (ing) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Text(
                              ing,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF374151),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED TEXT FIELD BUILDER
// ─────────────────────────────────────────────────────────────────────────────
Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  String? hint,
  IconData? icon,
  bool enabled = true,
  int maxLines = 1,
  void Function(String)? onSubmitted,
}) {
  return TextField(
    controller: controller,
    enabled: enabled,
    maxLines: maxLines,
    onSubmitted: onSubmitted,
    style: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
      labelStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
      prefixIcon: icon != null
          ? Icon(icon, size: 16, color: Colors.grey.shade400)
          : null,
      filled: true,
      fillColor: const Color(0xFFF8F9FC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFF97316), width: 1.5),
      ),
    ),
  );
}
