import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import 'widgets/category_chip_widget.dart';
import 'widgets/empty_search_widget.dart';
import 'widgets/filter_bottom_sheet_widget.dart';
import 'widgets/product_card_widget.dart';
import 'widgets/search_bar_widget.dart';

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _selectedCategory = 'All';
  String _searchQuery = '';
  Map<String, dynamic> _currentFilters = {};
  List<Map<String, dynamic>> _filteredProducts = [];
  int _cartItemCount = 3;

  // Mock data for products
  final List<Map<String, dynamic>> _allProducts = [
    {
      "id": 1,
      "name": "Classic Samosa",
      "category": "Samosa",
      "price": "₹25",
      "image":
          "https://images.unsplash.com/photo-1666162676616-a316eead59de",
      "semanticLabel":
          "Golden brown triangular samosas with crispy pastry shell filled with spiced potatoes and peas",
      "rating": 4.5,
      "isVeg": true,
      "spiceLevel": "Medium",
      "description":
          "Crispy golden samosas filled with spiced potatoes and green peas, served hot with mint chutney."
    },
    {
      "id": 2,
      "name": "Mumbai Vada Pav",
      "category": "Vada Pav",
      "price": "₹35",
      "image":
          "https://images.unsplash.com/photo-1707958718719-530f11bd7e56",
      "semanticLabel":
          "Traditional Mumbai vada pav with golden fried potato dumpling in soft bread bun with chutneys",
      "rating": 4.8,
      "isVeg": true,
      "spiceLevel": "Hot",
      "description":
          "Mumbai's iconic street food - spiced potato fritter in a soft bun with tangy and spicy chutneys."
    },
    {
      "id": 3,
      "name": "Sweet Jalebi",
      "category": "Jalebi",
      "price": "₹45",
      "image":
          "https://images.unsplash.com/photo-1706785743444-e1ccf0373193",
      "semanticLabel":
          "Orange spiral-shaped jalebis soaked in sugar syrup, crispy and sweet Indian dessert",
      "rating": 4.3,
      "isVeg": true,
      "spiceLevel": "",
      "description":
          "Crispy spiral-shaped sweet treats soaked in sugar syrup, perfect for satisfying your sweet tooth."
    },
    {
      "id": 4,
      "name": "Aloo Patties",
      "category": "Patties",
      "price": "₹30",
      "image":
          "https://images.unsplash.com/photo-1638690239774-2fcf6ad3db02",
      "semanticLabel":
          "Golden brown round potato patties with crispy exterior and soft spiced potato filling",
      "rating": 4.2,
      "isVeg": true,
      "spiceLevel": "Mild",
      "description":
          "Crispy potato patties with aromatic spices, served with tangy tamarind chutney."
    },
    // {
    //   "id": 5,
    //   "name": "Cheese Samosa",
    //   "category": "Samosa",
    //   "price": "₹40",
    //   "image":
    //       "https://images.unsplash.com/photo-1666162676616-a316eead59de",
    //   "semanticLabel":
    //       "Triangular samosas with melted cheese filling, golden brown and crispy pastry shell",
    //   "rating": 4.6,
    //   "isVeg": true,
    //   "spiceLevel": "Mild",
    //   "description":
    //       "Fusion samosas filled with melted cheese and mild spices, a modern twist on the classic."
    // },
    // {
    //   "id": 6,
    //   "name": "Schezwan Vada Pav",
    //   "category": "Vada Pav",
    //   "price": "₹45",
    //   "image":
    //       "https://images.unsplash.com/photo-1707958718719-530f11bd7e56",
    //   "semanticLabel":
    //       "Spicy Schezwan vada pav with red chili sauce coating on potato fritter in soft bun",
    //   "rating": 4.4,
    //   "isVeg": true,
    //   "spiceLevel": "Hot",
    //   "description":
    //       "Spicy fusion vada pav with Schezwan sauce, adding a Chinese twist to Mumbai's favorite snack."
    // },
    // {
    //   "id": 7,
    //   "name": "Mini Jalebi",
    //   "category": "Jalebi",
    //   "price": "₹35",
    //   "image":
    //       "https://images.unsplash.com/photo-1706785743444-e1ccf0373193",
    //   "semanticLabel":
    //       "Small bite-sized orange jalebis in syrup, perfect portion sweet Indian dessert spirals",
    //   "rating": 4.1,
    //   "isVeg": true,
    //   "spiceLevel": "",
    //   "description":
    //       "Bite-sized jalebis perfect for sharing, crispy and sweet with the right amount of syrup."
    // },
    // {
    //   "id": 8,
    //   "name": "Paneer Patties",
    //   "category": "Patties",
    //   "price": "₹50",
    //   "image":
    //       "https://images.unsplash.com/photo-1704282712173-01d87dc787db",
    //   "semanticLabel":
    //       "Golden brown paneer patties with cottage cheese and vegetable filling, crispy exterior",
    //   "rating": 4.7,
    //   "isVeg": true,
    //   "spiceLevel": "Medium",
    //   "description":
    //       "Rich paneer patties with cottage cheese and vegetables, a protein-rich snack option."
    // }
  ];

  // Search suggestions
  final List<String> _searchSuggestions = [
    'Samosa',
    'Vada Pav',
    'Jalebi',
    'Patties',
    // 'Cheese Samosa',
    // 'Mumbai Vada Pav',
    // 'Sweet Jalebi',
    // 'Aloo Patties',
    // 'Schezwan',
    // 'Paneer',
    // 'Spicy',
    // 'Sweet',
    // 'Crispy'
  ];

  // Categories
  final List<String> _categories = [
    'All',
    'Samosa',
    'Vada Pav',
    'Jalebi',
    'Patties'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredProducts = List.from(_allProducts);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    _filterProducts();
  }

  void _filterProducts() {
    List<Map<String, dynamic>> filtered = List.from(_allProducts);

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where(
              (product) => (product['category'] as String) == _selectedCategory)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        final name = (product['name'] as String).toLowerCase();
        final category = (product['category'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || category.contains(query);
      }).toList();
    }

    // Apply additional filters
    if (_currentFilters.isNotEmpty) {
      filtered = filtered.where((product) {
        // Price filter
        final priceStr = (product['price'] as String).replaceAll('₹', '');
        final price = double.tryParse(priceStr) ?? 0.0;
        final minPrice = (_currentFilters['minPrice'] as double?) ?? 0.0;
        final maxPrice =
            (_currentFilters['maxPrice'] as double?) ?? double.infinity;
        if (price < minPrice || price > maxPrice) return false;

        // Spice level filter
        final spiceLevel = (_currentFilters['spiceLevel'] as String?) ?? 'All';
        if (spiceLevel != 'All' &&
            (product['spiceLevel'] as String) != spiceLevel) {
          return false;
        }

        // Vegetarian filter
        final vegetarianOnly =
            (_currentFilters['vegetarianOnly'] as bool?) ?? false;
        if (vegetarianOnly && !(product['isVeg'] as bool)) return false;

        // Rating filter
        final minRating = (_currentFilters['minRating'] as double?) ?? 0.0;
        final rating = ((product['rating'] as num?) ?? 0.0).toDouble();
        if (rating < minRating) return false;

        return true;
      }).toList();
    }

    setState(() {
      _filteredProducts = filtered;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterProducts();
  }

  void _onFilterTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _currentFilters,
        onApplyFilters: (filters) {
          setState(() {
            _currentFilters = filters;
          });
          _filterProducts();
        },
      ),
    );
  }

  void _onProductTap(Map<String, dynamic> product) {
    Navigator.pushNamed(
      context,
      '/product-detail-screen',
      arguments: product,
    );
  }

  void _onFavorite(Map<String, dynamic> product) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to favorites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onShare(Map<String, dynamic> product) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${product['name']} via WhatsApp'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedCategory = 'All';
      _currentFilters.clear();
    });
    _filterProducts();
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _filteredProducts = List.from(_allProducts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        variant: AppBarVariant.centered,
        title: 'Vada Pav Express',
        actions: [
          Stack(
            children: [
              IconButton(
                icon: CustomIconWidget(
                  iconName: 'shopping_cart_outlined',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, '/shopping-cart-screen');
                },
              ),
              if (_cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 4.w,
                      minHeight: 4.w,
                    ),
                    child: Text(
                      _cartItemCount.toString(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 8.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: AppTheme.lightTheme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Catalog'),
                Tab(text: 'Cart'),
                Tab(text: 'Profile'),
              ],
            ),
          ),
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Catalog Tab
                _buildCatalogTab(),
                // Cart Tab (Placeholder)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'shopping_cart',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20.w,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Cart Screen',
                        style: AppTheme.lightTheme.textTheme.headlineSmall,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Navigate to cart for full functionality',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Profile Tab (Placeholder)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'person',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20.w,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Profile Screen',
                        style: AppTheme.lightTheme.textTheme.headlineSmall,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'User profile and settings',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(
        variant: BottomBarVariant.standard,
        currentIndex: 0,
      ),
      floatingActionButton: _filteredProducts.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pushNamed(context, '/shopping-cart-screen');
              },
              child: Stack(
                children: [
                  CustomIconWidget(
                    iconName: 'shopping_cart',
                    color: Colors.white,
                    size: 24,
                  ),
                  if (_cartItemCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 4.w,
                          minHeight: 4.w,
                        ),
                        child: Text(
                          _cartItemCount.toString(),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 8.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildCatalogTab() {
    return Column(
      children: [
        // Search Bar and Categories
        Container(
          color: AppTheme.lightTheme.colorScheme.surface,
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              // Search Bar
              SearchBarWidget(
                controller: _searchController,
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                  _filterProducts();
                },
                onFilterTap: _onFilterTap,
                suggestions: _searchSuggestions,
              ),
              SizedBox(height: 2.h),
              // Categories
              SizedBox(
                height: 5.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return CategoryChipWidget(
                      category: category,
                      isSelected: _selectedCategory == category,
                      onTap: () => _onCategorySelected(category),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Products Grid
        Expanded(
          child: _filteredProducts.isEmpty
              ? EmptySearchWidget(
                  searchQuery: _searchQuery,
                  onClearSearch: _clearSearch,
                )
              : RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(4.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 3.w,
                      mainAxisSpacing: 3.w,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return ProductCardWidget(
                        product: product,
                        onTap: () => _onProductTap(product),
                        onFavorite: () => _onFavorite(product),
                        onShare: () => _onShare(product),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
