import 'package:flutter/material.dart';
import 'package:movie_app/core/domain/entities/media.dart';
import 'package:movie_app/core/presentation/components/slider_card_image.dart';
import 'package:movie_app/core/utils/functions.dart';
import 'package:movie_app/core/resources/app_values.dart';

class SliderCard extends StatelessWidget {
  const SliderCard({
    super.key,
    required this.media,
    required this.itemIndex,
  });

  final Media media;
  final int itemIndex;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        navigateToDetailsView(context, media);
      },
      child: Stack(
        children: [
          SliderCardImage(imageUrl: media.backdropUrl),
          Padding(
            padding: const EdgeInsets.only(
              right: AppPadding.p10,
              left: AppPadding.p10,
              bottom: AppPadding.p2,
            ),
            child: SizedBox(
              height: size.height * 0.50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    media.title,
                    maxLines: 2,
                    style: textTheme.titleMedium,
                  ),
                  Text(
                    media.releaseDate,
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
