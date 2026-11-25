import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/models/photo_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/gallery_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final GalleryController _galleryController;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _galleryController = Get.find<GalleryController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBg,
      body: SafeArea(
        child: IndexedStack(
          index: _index,
          children: [
            _HomeTab(controller: _galleryController),
            _GalleryTab(controller: _galleryController),
            const _PlaceholderTab(title: 'Favorites'),
            const _PlaceholderTab(title: 'Profile'),
          ],
        ),
      ),
      floatingActionButton: _index == 0
          ? null
          : FloatingActionButton(
              backgroundColor: AppColors.primary,
              elevation: 6,
              onPressed: () {},
              child: const Icon(Icons.add, color: Colors.white),
            ),
      floatingActionButtonLocation: _index == 0
          ? null
          : FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _index == 0
          ? null
          : BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              color: Colors.white,
              child: SizedBox(
                height: 68.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(icon: Icons.home_rounded, label: 'Home', selected: _index == 0, onTap: () => setState(() => _index = 0)),
                    _NavItem(icon: Icons.photo_library_outlined, label: 'Gallery', selected: _index == 1, onTap: () => setState(() => _index = 1)),
                    SizedBox(width: 40.w),
                    _NavItem(icon: Icons.favorite_border_rounded, label: 'Favorites', selected: _index == 2, onTap: () => setState(() => _index = 2)),
                    _NavItem(icon: Icons.person_outline_rounded, label: 'Profile', selected: _index == 3, onTap: () => setState(() => _index = 3)),
                  ],
                ),
              ),
            ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({required this.controller});

  final GalleryController controller;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back', style: AppTextStyles.subtitle),
                      SizedBox(height: 2.h),
                      Text('My Gallery', style: AppTextStyles.title),
                    ],
                  ),
                ),
                Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(Icons.notifications_none_rounded,
                      color: AppColors.textDark, size: 22.sp),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: 'Total Photos',
                        value: '${controller.photos.length}',
                        icon: Icons.photo_library_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _SummaryCard(
                        title: 'Storage Used',
                        value: '${controller.totalStorageMb.toStringAsFixed(1)} MB',
                        icon: Icons.cloud_outlined,
                        color: const Color(0xFF00B894),
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 24.h),
            Text('Recent Uploads',
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            SizedBox(height: 14.h),
            Obx(() => _buildPhotoState(controller, maxItems: 4)),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class _GalleryTab extends StatelessWidget {
  const _GalleryTab({required this.controller});

  final GalleryController controller;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            sliver: SliverToBoxAdapter(
              child: Text('Gallery',
                  style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverToBoxAdapter(
              child: Obx(() => _buildPhotoState(controller)),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildPhotoState(GalleryController controller, {int? maxItems}) {
  if (controller.isLoading.value) {
    return const Center(child: CircularProgressIndicator());
  }
  if (controller.hasError) {
    return Column(
      children: [
        Text(controller.errorMessage.value,
            style: TextStyle(color: Colors.red, fontSize: 13.sp)),
        SizedBox(height: 8.h),
        TextButton(
          onPressed: controller.fetchPhotos,
          child: const Text('Retry'),
        ),
      ],
    );
  }
  if (controller.isEmpty) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(
        child: Text('No photos yet',
            style: TextStyle(color: AppColors.textGrey, fontSize: 14.sp)),
      ),
    );
  }
  final items = maxItems == null
      ? controller.photos
      : controller.photos.take(maxItems).toList();
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 0.78,
    ),
    itemCount: items.length,
    itemBuilder: (context, i) => _PhotoCard(photo: items[i]),
  );
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 22.sp),
          ),
          SizedBox(height: 12.h),
          Text(value,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          SizedBox(height: 2.h),
          Text(title, style: AppTextStyles.small),
        ],
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final PhotoModel photo;

  const _PhotoCard({required this.photo});

  @override
  Widget build(BuildContext context) {
    final colors = photo.isAi
        ? AppColors.grad4
        : (photo.id.hashCode % 2 == 0 ? AppColors.grad1 : AppColors.grad2);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (photo.imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                      child: Image.network(
                        photo.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(Icons.image_outlined,
                              color: Colors.white.withValues(alpha: 0.8), size: 36.sp),
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Icon(Icons.image_outlined,
                          color: Colors.white.withValues(alpha: 0.8), size: 36.sp),
                    ),
                  if (photo.isAi)
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome, color: Colors.white, size: 12.sp),
                            SizedBox(width: 4.w),
                            Text('AI',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        photo.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: AppColors.primary,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(photo.fileSizeLabel,
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
                Text(photo.dateLabel,
                    style: TextStyle(fontSize: 11.sp, color: AppColors.textGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title,
          style: TextStyle(fontSize: 18.sp, color: AppColors.textGrey)),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem(
      {required this.icon,
      required this.label,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textGrey;
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20.sp),
            SizedBox(height: 1.h),
            Text(label,
                style: TextStyle(
                    fontSize: 10.sp,
                    color: color,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
