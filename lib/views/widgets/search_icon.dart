import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/bloc/search_anim/search_anim_cubit.dart';
import 'package:todo_app/helpers/theme/app_colors.dart';

class SearchIcon extends StatefulWidget {
  const SearchIcon({super.key});
  static TextEditingController searchController = TextEditingController();

  @override
  State<SearchIcon> createState() => _SearchIconState();
}

class _SearchIconState extends State<SearchIcon> with TickerProviderStateMixin {
  late AnimationController moveController;
  late Animation<double> topAnimation;
  late Animation<double> leftAnimation;

  bool isOpen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    topAnimation = Tween<double>(
      begin: 52.h,
      end: 125.h,
    ).animate(CurvedAnimation(parent: moveController, curve: Curves.easeInOut));

    leftAnimation = Tween<double>(
      begin: 330.w,
      end: 20.w,
    ).animate(CurvedAnimation(parent: moveController, curve: Curves.easeInOut));

    // نسمع حالة الانيميشن
    moveController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => isOpen = true);
      }
      if (status == AnimationStatus.reverse ||
          status == AnimationStatus.dismissed) {
        setState(() => isOpen = false);
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    moveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: moveController,
      builder: (context, child) {
        return Positioned(
          top: topAnimation.value,
          left: leftAnimation.value,
          child: AnimatedContainer(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 1000),
            width: isOpen ? MediaQuery.of(context).size.width - 40.w : 50.h,
            height: 50.h,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: isOpen
                  ? AppColors.buttonColor
                  : AppColors.secondaryBackGround,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black12,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: isOpen
                ? Material(
                    color: Colors.transparent,
                    child: TextField(
                      controller: SearchIcon.searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryBackGround,
                        ),
                        border: InputBorder.none,

                        // الأيقونة الشمال
                        prefixIcon: Icon(
                          Icons.search,
                          size: 22.sp,
                          color: Colors.grey,
                        ),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 40.w,
                          minHeight: 40.h,
                        ),

                        // الأيقونة اليمين
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            setState(() {
                              isOpen = false;
                            });
                            await Future.delayed(
                              const Duration(milliseconds: 1000),
                            );
                            context.read<SearchAnimCubit>().makeItClose();
                            SearchIcon.searchController.clear();
                            moveController.reverse();
                          },
                          child: Icon(
                            Icons.close,
                            size: 22.sp,
                            color: AppColors.secondaryBackGround,
                          ),
                        ),
                        suffixIconConstraints: BoxConstraints(
                          minWidth: 40.w,
                          minHeight: 40.h,
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      context.read<SearchAnimCubit>().makeItOpen();
                      moveController.forward();
                    },
                    child: const Icon(Icons.search, size: 30),
                  ),
          ),
        );
      },
    );
  }
}
