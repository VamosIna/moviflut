import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/domain/entities/media.dart';
import 'package:movie_app/core/presentation/components/animation_list.dart';
import 'package:movie_app/core/presentation/components/custom_app_bar.dart';
import 'package:movie_app/core/presentation/components/error_screen.dart';
import 'package:movie_app/core/presentation/components/loading_indicator.dart';
import 'package:movie_app/core/presentation/components/vertical_listview_card.dart';
import 'package:movie_app/core/resources/app_colors.dart';
import 'package:movie_app/core/resources/app_strings.dart';
import 'package:movie_app/core/resources/app_values.dart';
import 'package:movie_app/core/services/service_locator.dart';
import 'package:movie_app/features/favorites/presentation/components/empty_favorites_list_text.dart';
import 'package:movie_app/features/favorites/presentation/controllers/favorites_list_bloc/favorites_list_bloc.dart';
import 'package:movie_app/features/search/presentation/components/search_bar.dart';

class FavoritesListView extends StatefulWidget {
  const FavoritesListView({super.key});

  @override
  State<FavoritesListView> createState() => _FavoritesListViewState();
}

class _FavoritesListViewState extends State<FavoritesListView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocProvider(
      create: (context) =>
          sl<FavoritesListBloc>()..add(SearchFavoriteListItemEvent(media: "")),
      child: Scaffold(
        appBar: const CustomAppBar(
          title: AppStrings.favorites,
        ),
        body: BlocBuilder<FavoritesListBloc, FavoritesListState>(
          builder: (context, state) {
            if (state.status == FavoritesListRequestStatus.loading) {
              return const LoadingIndicator();
            } else if (state.status == FavoritesListRequestStatus.loaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppMargin.m8),
                    child: Form(
                      child: TextFormField(
                        controller: _textController,
                        cursorColor: AppColors.primaryText,
                        cursorWidth: AppSize.s1,
                        style: textTheme.bodyLarge,
                        onChanged: (title) {
                          context.read<FavoritesListBloc>().add(SearchFavoriteListItemEvent(media: title));
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.primaryText,
                            ),
                            borderRadius: BorderRadius.circular(AppSize.s8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.primaryText,
                            ),
                            borderRadius: BorderRadius.circular(AppSize.s8),
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: AppColors.primaryText,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              _textController.text = '';
                              context.read<FavoritesListBloc>().add(SearchFavoriteListItemEvent(media: ''));
                            },
                            child: const Icon(
                              Icons.clear_rounded,
                              color: AppColors.primaryText,
                            ),
                          ),
                          hintText: AppStrings.searchHint,
                          hintStyle: textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                        height: MediaQuery.of(context).size.height *0.65,
                        margin: EdgeInsets.symmetric(horizontal: AppMargin.m8,vertical: AppMargin.m8),
                        child: FavoriteListWidget(items: state.items)),
                  ),
                ],
              );
            } else if (state.status == FavoritesListRequestStatus.empty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: TextFormField(
                        controller: _textController,
                        cursorColor: AppColors.primaryText,
                        cursorWidth: AppSize.s1,
                        style: textTheme.bodyLarge,
                        onChanged: (title) {
                          context.read<FavoritesListBloc>().add(SearchFavoriteListItemEvent(media: title));
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.primaryText,
                            ),
                            borderRadius: BorderRadius.circular(AppSize.s8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.primaryText,
                            ),
                            borderRadius: BorderRadius.circular(AppSize.s8),
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: AppColors.primaryText,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              _textController.text = '';
                              context.read<FavoritesListBloc>().add(SearchFavoriteListItemEvent(media: ''));
                            },
                            child: const Icon(
                              Icons.clear_rounded,
                              color: AppColors.primaryText,
                            ),
                          ),
                          hintText: AppStrings.searchHint,
                          hintStyle: textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: EmptyFavoritesListText()),
                ],
              );
              // return const EmptyFavoritesListText();
            } else {
              return ErrorScreen(
                onTryAgainPressed: () {
                  context
                      .read<FavoritesListBloc>()
                      .add(GetFavoritesListItemsEvent());
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class FavoriteListWidget extends StatelessWidget {
  const FavoriteListWidget({
    super.key,
    required this.items,
  });

  final List<Media> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p12,
        vertical: AppPadding.p6,
      ),
      itemBuilder: (context, index) {
        return AnimationListWidget(
            isVertical: true,
            index: index,
            child: VerticalListViewCard(media: items[index]));
      },
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSize.s10),
    );
  }
}
class FavoriteListHorizontalWidget extends StatelessWidget {
  const FavoriteListHorizontalWidget({
    super.key,
    required this.items,
  });

  final List<Media> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p12,
        vertical: AppPadding.p6,
      ),
      itemBuilder: (context, index) {
        return AnimationListWidget(
            isVertical: false,
            index: index,
            child: VerticalListViewCard(media: items[index]));
      },
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSize.s10),
    );
  }
}

