import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UpiAppsGrid extends StatelessWidget {
  final Function(String) onUpiAppSelected;

  const UpiAppsGrid({
    super.key,
    required this.onUpiAppSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> upiApps = [
      {
        "name": "PhonePe",
        "icon":
            "https://img.rocket.new/generatedImages/rocket_gen_img_17d6e81a4-1763311371833.png",
        "semanticLabel": "PhonePe logo with purple background and white text",
        "packageName": "com.phonepe.app",
      },
      {
        "name": "Google Pay",
        "icon":
            "https://img.rocket.new/generatedImages/rocket_gen_img_163255792-1763311372078.png",
        "semanticLabel": "Google Pay logo with colorful G and Pay text",
        "packageName": "com.google.android.apps.nfc.payment",
      },
      {
        "name": "Paytm",
        "icon":
            "https://img.rocket.new/generatedImages/rocket_gen_img_19ce0e4f1-1763311371204.png",
        "semanticLabel": "Paytm logo with blue background and white text",
        "packageName": "net.one97.paytm",
      },
      {
        "name": "BHIM UPI",
        "icon":
            "https://img.rocket.new/generatedImages/rocket_gen_img_17f805bac-1763311373530.png",
        "semanticLabel": "BHIM UPI logo with orange and blue colors",
        "packageName": "in.org.npci.upiapp",
      },
      {
        "name": "Amazon Pay",
        "icon":
            "https://img.rocket.new/generatedImages/rocket_gen_img_17b1fac73-1763311372022.png",
        "semanticLabel": "Amazon Pay logo with orange text on white background",
        "packageName": "in.amazon.mShop.android.shopping",
      },
      {
        "name": "Mobikwik",
        "icon":
            "https://img.rocket.new/generatedImages/rocket_gen_img_1987a4cfe-1763311372081.png",
        "semanticLabel": "Mobikwik logo with blue and orange colors",
        "packageName": "com.mobikwik_new",
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose UPI App",
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.2,
            ),
            itemCount: upiApps.length,
            itemBuilder: (context, index) {
              final app = upiApps[index];
              return InkWell(
                onTap: () => onUpiAppSelected(app["name"] as String),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustomImageWidget(
                          imageUrl: app["icon"] as String,
                          width: 10.w,
                          height: 10.w,
                          fit: BoxFit.contain,
                          semanticLabel: app["semanticLabel"] as String,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        app["name"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
