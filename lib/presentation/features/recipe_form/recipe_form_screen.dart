import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/strings/app_strings.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/recipe_entity.dart';
import '../../../domain/entities/ingredient_entity.dart';
import '../../providers/recipe_provider.dart';
import '../../providers/category_provider.dart';

class RecipeFormScreen extends ConsumerStatefulWidget {
  const RecipeFormScreen({super.key, this.recipeId});
  final int? recipeId;

  @override
  ConsumerState<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends ConsumerState<RecipeFormScreen> {
  final _nameCtrl = TextEditingController();
  final _memoCtrl = TextEditingController();
  int? _selectedCategoryId;
  final List<_IngredientField> _ingredients = [];
  final List<TextEditingController> _steps = [];
  bool _loaded = false;

  bool get _isEdit => widget.recipeId != null;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _memoCtrl.dispose();
    for (final i in _ingredients) {
      i.dispose();
    }
    for (final s in _steps) {
      s.dispose();
    }
    super.dispose();
  }

  void _loadRecipe(RecipeEntity recipe) {
    if (_loaded) return;
    _loaded = true;
    _nameCtrl.text = recipe.name;
    _memoCtrl.text = recipe.memo;
    _selectedCategoryId = recipe.categoryId;
    _ingredients.addAll(recipe.ingredients.map((i) => _IngredientField(
          nameCtrl: TextEditingController(text: i.name),
          amountCtrl: TextEditingController(
            text: i.amount == i.amount.roundToDouble()
                ? i.amount.toInt().toString()
                : i.amount.toString(),
          ),
          unit: i.unit,
        )));
    _steps.addAll(recipe.steps.map((s) => TextEditingController(text: s)));
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    if (_isEdit) {
      ref.watch(recipeDetailProvider(widget.recipeId!)).whenData((recipe) {
        if (recipe != null) _loadRecipe(recipe);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title:
            Text(_isEdit ? AppStrings.editRecipe : AppStrings.addRecipe),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(AppStrings.save),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: AppStrings.recipeNameHint,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          categoriesAsync.when(
            data: (cats) => DropdownButtonFormField<int>(
              value: _selectedCategoryId,
              decoration: const InputDecoration(
                labelText: AppStrings.navCategories,
                border: OutlineInputBorder(),
              ),
              items: cats
                  .map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text('${c.icon} ${c.name}'),
                      ))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _selectedCategoryId = v),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox(),
          ),
          const SizedBox(height: 24),
          Text(AppStrings.ingredients,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ..._ingredients.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _IngredientRow(
                  field: e.value,
                  onRemove: () =>
                      setState(() => _ingredients.removeAt(e.key)),
                ),
              )),
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text(AppStrings.addIngredient),
            onPressed: () => setState(() => _ingredients.add(
                  _IngredientField(
                    nameCtrl: TextEditingController(),
                    amountCtrl: TextEditingController(),
                    unit: AppConstants.ingredientUnits.first,
                  ),
                )),
          ),
          const SizedBox(height: 16),
          Text(AppStrings.steps,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ..._steps.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 13,
                      child: Text('${e.key + 1}',
                          style: const TextStyle(fontSize: 11)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: e.value,
                        decoration: InputDecoration(
                          hintText: '手順 ${e.key + 1}',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () =>
                          setState(() => _steps.removeAt(e.key)),
                    ),
                  ],
                ),
              )),
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text(AppStrings.addStep),
            onPressed: () =>
                setState(() => _steps.add(TextEditingController())),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _memoCtrl,
            decoration: const InputDecoration(
              labelText: AppStrings.memo,
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    final repo = ref.read(recipeRepositoryProvider);
    final recipe = RecipeEntity(
      id: widget.recipeId ?? 0,
      name: name,
      categoryId: _selectedCategoryId ?? 0,
      ingredients: _ingredients
          .map((i) => IngredientEntity(
                name: i.nameCtrl.text.trim(),
                amount: double.tryParse(i.amountCtrl.text) ?? 0,
                unit: i.unit,
              ))
          .where((i) => i.name.isNotEmpty)
          .toList(),
      steps: _steps
          .map((s) => s.text.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
      memo: _memoCtrl.text.trim(),
      isFavorite: false,
      isPreset: false,
      createdAt: DateTime.now(),
    );
    if (_isEdit) {
      await repo.updateRecipe(recipe);
    } else {
      await repo.insertRecipe(recipe);
    }
    ref.invalidate(filteredRecipesProvider);
    if (mounted) Navigator.pop(context);
  }
}

class _IngredientField {
  final TextEditingController nameCtrl;
  final TextEditingController amountCtrl;
  String unit;

  _IngredientField(
      {required this.nameCtrl,
      required this.amountCtrl,
      required this.unit});

  void dispose() {
    nameCtrl.dispose();
    amountCtrl.dispose();
  }
}

class _IngredientRow extends StatefulWidget {
  const _IngredientRow({required this.field, required this.onRemove});
  final _IngredientField field;
  final VoidCallback onRemove;

  @override
  State<_IngredientRow> createState() => _IngredientRowState();
}

class _IngredientRowState extends State<_IngredientRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: widget.field.nameCtrl,
            decoration: const InputDecoration(
              hintText: '材料名',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: widget.field.amountCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: '量',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 4),
        DropdownButton<String>(
          value: widget.field.unit,
          items: AppConstants.ingredientUnits
              .map((u) => DropdownMenuItem(value: u, child: Text(u)))
              .toList(),
          onChanged: (v) => setState(() => widget.field.unit = v!),
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: widget.onRemove,
        ),
      ],
    );
  }
}
