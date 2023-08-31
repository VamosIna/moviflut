import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/domain/entities/media.dart';
import 'package:movie_app/core/domain/entities/media_details.dart';
import 'package:movie_app/core/presentation/components/slider_card_image.dart';

import 'package:movie_app/core/resources/app_colors.dart';
import 'package:movie_app/core/resources/app_strings.dart';
import 'package:movie_app/core/resources/app_values.dart';
import 'package:movie_app/features/favorites/presentation/controllers/favorites_list_bloc/favorites_list_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsCard extends StatefulWidget {
  const DetailsCard({
    required this.mediaDetails,
    required this.detailsWidget,
    super.key,
  });

  final MediaDetails mediaDetails;
  final Widget detailsWidget;

  @override
  State<DetailsCard> createState() => _DetailsCardState();
}

class _DetailsCardState extends State<DetailsCard> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    context
        .read<FavoritesListBloc>()
        .add(CheckItemAddedEvent(tmdbId: widget.mediaDetails.tmdbID));
    return Stack(
      children: [
        SliderDetailCardImage(imageUrl: widget.mediaDetails.backdropUrl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
          child: SizedBox(
            height: size.height * 0.35,
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppPadding.p8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.mediaDetails.title,
                          maxLines: 2,
                          style: textTheme.titleMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: AppPadding.p4,
                            bottom: AppPadding.p6,
                          ),
                          child: widget.detailsWidget,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rate_rounded,
                              color: AppColors.ratingIconColor,
                              size: AppSize.s18,
                            ),
                            Text(
                              '${widget.mediaDetails.voteAverage} ',
                              style: textTheme.bodyMedium,
                            ),
                            Text(
                              widget.mediaDetails.voteCount,
                              style: textTheme.bodySmall,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (widget.mediaDetails.trailerUrl.isNotEmpty) ...[
                    InkWell(
                      onTap: () async {
                        final url = Uri.parse(widget.mediaDetails.trailerUrl);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                      child: Container(
                        height: AppSize.s40,
                        width: AppSize.s40,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            top: AppPadding.p50,
            left: AppPadding.p16,
            right: AppPadding.p16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(AppPadding.p8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.iconContainerColor,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.secondaryText,
                    size: AppSize.s20,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  widget.mediaDetails.isAdded
                      ? context
                          .read<FavoritesListBloc>()
                          .add(RemoveFavoriteListItemEvent(widget.mediaDetails.id!))
                      : context.read<FavoritesListBloc>().add(
                            AddFavoriteListItemEvent(
                                media: Media.fromMediaDetails(widget.mediaDetails)),
                          );
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.error,
                    content: Text(
                        style: textTheme.titleMedium,
                        widget.mediaDetails.isAdded != true ? AppStrings.addFavorites : AppStrings.removeFavorites),
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.all(AppPadding.p8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.iconContainerColor,
                  ),
                  child: BlocConsumer<FavoritesListBloc, FavoritesListState>(
                    listener: (context, state) {
                      if (state.status ==
                          FavoritesListRequestStatus.itemAdded) {
                        widget.mediaDetails.id = state.id;
                        widget.mediaDetails.isAdded = true;
                      } else if (state.status ==
                          FavoritesListRequestStatus.itemRemoved) {
                        widget.mediaDetails.id = null;
                        widget.mediaDetails.isAdded = false;
                      } else if (state.status ==
                              FavoritesListRequestStatus.isItemAdded &&
                          state.id != -1) {
                        widget.mediaDetails.id = state.id;
                        widget.mediaDetails.isAdded = true;
                      }
                    },
                    builder: (context, state) {
                      return Icon(
                        Icons.favorite,
                        color: widget.mediaDetails.isAdded
                            ? AppColors.primary
                            : AppColors.secondaryText,
                        size: AppSize.s20,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
