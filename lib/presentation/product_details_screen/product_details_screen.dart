import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import 'widgets/action_buttons.dart';
import 'widgets/customer_reviews_section.dart';
import 'widgets/expandable_section.dart';
import 'widgets/product_image_carousel.dart';
import 'widgets/product_info_section.dart';
import 'widgets/quantity_selector.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedQuantity = 1;
  bool _isInCart = false;
  late Map<String, dynamic> _selectedProduct;

  final List<Map<String, dynamic>> _products = [
    {
      "id": 1,
      "name": "Classic Vada Pav",
      "hindiName": "वड़ा पाव",
      "price": "₹25",
      "rating": 4.5,
      "reviewCount": 128,
      "spiceLevel": "Medium",
      "prepTime": 15,
      "inStock": true,
      "description":
          "Mumbai's iconic street food - a spiced potato fritter served in a soft bun with tangy chutneys. Made with fresh potatoes, aromatic spices, and served hot with our signature green and tamarind chutneys.",
      "ingredients": [
        "Potatoes",
        "Gram flour",
        "Green chilies",
        "Ginger",
        "Garlic",
        "Turmeric",
        "Mustard seeds",
        "Curry leaves",
        "Pav bread",
        "Green chutney",
        "Tamarind chutney"
      ],
      "allergens": ["Gluten", "May contain traces of nuts"],
      "nutritionalInfo": {
        "calories": 320,
        "protein": "8g",
        "carbs": "45g",
        "fat": "12g",
        "fiber": "4g"
      },
      "images": [
        "https://images.pexels.com/photos/5560763/pexels-photo-5560763.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/7625056/pexels-photo-7625056.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/5560764/pexels-photo-5560764.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
      ],
      "semanticLabels": [
        "Golden brown vada pav served on a white plate with green and brown chutneys on the side",
        "Close-up view of crispy vada fritter with visible spices and herbs inside soft pav bread",
        "Traditional Mumbai street food vada pav with fresh green chutney and fried green chilies"
      ]
    },
    {
      "id": 2,
      "name": "Crispy Samosa",
      "hindiName": "समोसा",
      "price": "₹20",
      "rating": 4.3,
      "reviewCount": 95,
      "spiceLevel": "Mild",
      "prepTime": 12,
      "inStock": false,
      "description":
          "Golden triangular pastries filled with spiced potatoes and peas. Our samosas are made with a crispy outer layer and a flavorful filling that's perfectly seasoned with traditional Indian spices.",
      "ingredients": [
        "All-purpose flour",
        "Potatoes",
        "Green peas",
        "Cumin seeds",
        "Coriander seeds",
        "Garam masala",
        "Green chilies",
        "Ginger",
        "Oil for frying"
      ],
      "allergens": ["Gluten"],
      "nutritionalInfo": {
        "calories": 280,
        "protein": "6g",
        "carbs": "35g",
        "fat": "14g",
        "fiber": "3g"
      },
      "images": [
        "https://images.pexels.com/photos/14477877/pexels-photo-14477877.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "https://images.pexels.com/photos/5560761/pexels-photo-5560761.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
      ],
      "semanticLabels": [
        "Golden brown triangular samosas arranged on a wooden plate with mint chutney",
        "Close-up of crispy samosa showing flaky pastry texture with potato and pea filling visible"
      ]
    }
  ];

  final List<Map<String, dynamic>> _customerReviews = [
    {
      "id": 1,
      "userName": "Priya Sharma",
      "userAvatar":
          "https://images.unsplash.com/photo-1727740443703-11eace1e0d9e",
      "userAvatarLabel":
          "Young Indian woman with long black hair smiling at camera wearing traditional earrings",
      "rating": 5,
      "date": "2 days ago",
      "comment":
          "Absolutely authentic taste! Reminds me of Mumbai street food. The vada was perfectly crispy and the chutneys were spot on. Will definitely order again!",
      "helpfulCount": 12,
      "notHelpfulCount": 0,
      "isHelpful": false,
      "isNotHelpful": false
    },
    {
      "id": 2,
      "userName": "Rajesh Kumar",
      "userAvatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1aac31f10-1762274345319.png",
      "userAvatarLabel":
          "Middle-aged Indian man with mustache wearing white shirt and smiling",
      "rating": 4,
      "date": "1 week ago",
      "comment":
          "Good quality and taste. The delivery was quick and the food was still warm. Only suggestion would be to make the green chutney a bit more spicy.",
      "helpfulCount": 8,
      "notHelpfulCount": 1,
      "isHelpful": false,
      "isNotHelpful": false
    },
    {
      "id": 3,
      "userName": "Anita Patel",
      "userAvatar":
          "https://images.unsplash.com/photo-1617593461584-4d51cc5cff4c",
      "userAvatarLabel":
          "Elderly Indian woman with gray hair wearing colorful traditional sari and smiling warmly",
      "rating": 5,
      "date": "2 weeks ago",
      "comment":
          "My kids loved it! Perfect for evening snacks. The portion size is good and the price is very reasonable. Highly recommended for families.",
      "helpfulCount": 15,
      "notHelpfulCount": 0,
      "isHelpful": false,
      "isNotHelpful": false
    },
    {
      "id": 4,
      "userName": "Vikram Singh",
      "userAvatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_135d145a1-1762274454200.png",
      "userAvatarLabel":
          "Young Indian man with beard wearing casual blue shirt and looking confident",
      "rating": 4,
      "date": "3 weeks ago",
      "comment":
          "Great taste and quality. The packaging was excellent and kept the food fresh. Would love to see more variety in chutneys.",
      "helpfulCount": 6,
      "notHelpfulCount": 2,
      "isHelpful": false,
      "isNotHelpful": false
    }
  ];

  @override
  void initState() {
    super.initState();
    _selectedProduct = _products.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductImageCarousel(
                    images: (_selectedProduct['images'] as List).cast<String>(),
                    semanticLabels: (_selectedProduct['semanticLabels'] as List)
                        .cast<String>(),
                  ),
                  ProductInfoSection(product: _selectedProduct),
                  _buildDescriptionSection(),
                  _buildNutritionalInfoSection(),
                  _buildIngredientsSection(),
                  QuantitySelector(
                    initialQuantity: _selectedQuantity,
                    maxQuantity: 10,
                    onQuantityChanged: (quantity) {
                      setState(() {
                        _selectedQuantity = quantity;
                      });
                    },
                  ),
                  CustomerReviewsSection(
                    reviews: _customerReviews,
                    averageRating: _selectedProduct['rating'] as double,
                    totalReviews: _selectedProduct['reviewCount'] as int,
                  ),
                  SizedBox(height: 10.h), // Space for bottom buttons
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ActionButtons(
        product: _selectedProduct,
        quantity: _selectedQuantity,
        isInCart: _isInCart,
        onAddToCart: _handleAddToCart,
        onBuyNow: _handleBuyNow,
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ExpandableSection(
        title: 'Description',
        initiallyExpanded: true,
        content: Text(
          _selectedProduct['description'] as String,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                height: 1.5,
              ),
        ),
      ),
    );
  }

  Widget _buildNutritionalInfoSection() {
    final nutritionalInfo =
        _selectedProduct['nutritionalInfo'] as Map<String, dynamic>;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ExpandableSection(
        title: 'Nutritional Information',
        content: Column(
          children: [
            _buildNutritionRow(
                'Calories', nutritionalInfo['calories'].toString()),
            _buildNutritionRow('Protein', nutritionalInfo['protein'] as String),
            _buildNutritionRow(
                'Carbohydrates', nutritionalInfo['carbs'] as String),
            _buildNutritionRow('Fat', nutritionalInfo['fat'] as String),
            _buildNutritionRow('Fiber', nutritionalInfo['fiber'] as String),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsSection() {
    final ingredients =
        (_selectedProduct['ingredients'] as List).cast<String>();
    final allergens = (_selectedProduct['allergens'] as List).cast<String>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ExpandableSection(
        title: 'Ingredients & Allergens',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingredients:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: ingredients.map((ingredient) {
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    ingredient,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 2.h),
            Text(
              'Allergens:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.errorLight,
                  ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: allergens.map((allergen) {
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.errorLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.errorLight.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'warning',
                        color: AppTheme.errorLight,
                        size: 12,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        allergen,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.errorLight,
                            ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAddToCart() {
    setState(() {
      _isInCart = true;
    });

    // Here you would typically add the item to cart in your state management
    // For now, we'll just show a success message
  }

  void _handleBuyNow() {
    HapticFeedback.mediumImpact();

    // Add to cart first
    _handleAddToCart();

    // Navigate to checkout
    Navigator.pushNamed(context, '/checkout-screen');
  }
}
