import 'package:flutter/material.dart';
import 'package:movie_app/core/resources/app_colors.dart';
import 'package:movie_app/core/resources/app_strings.dart';
import 'package:movie_app/core/resources/app_values.dart';

class EmptyFavoritesListText extends StatelessWidget {
  const EmptyFavoritesListText({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.favoritesListIsEmpty,
                style: textTheme.titleMedium,
              ),
              Icon(
                Icons.favorite,
                color: AppColors.primary,
                size: AppSize.s20,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: AppPadding.p6),
            child: Text(
              AppStrings.favoritesListText,
              style: textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
