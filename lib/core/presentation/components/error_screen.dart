import 'package:flutter/material.dart';
import 'package:movie_app/core/presentation/components/error_text.dart';

import 'package:movie_app/core/resources/app_colors.dart';
import 'package:movie_app/core/resources/app_strings.dart';
import 'package:movie_app/core/resources/app_values.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required this.onTryAgainPressed,
  });

  final Function() onTryAgainPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppPadding.p18),
            child:Icon(
              Icons.wifi_off_outlined,
              color: AppColors.error,
              size: 30.0,
            ),
          ),
          const ErrorText(),
          const SizedBox(height: AppSize.s15),
          ElevatedButton(
            onPressed: onTryAgainPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s30),
              ),
            ),
            child: Text(
              AppStrings.tryAgain,
              style: textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
