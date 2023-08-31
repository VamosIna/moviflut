import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/presentation/components/error_text.dart';
import 'package:movie_app/core/presentation/components/loading_indicator.dart';
import 'package:movie_app/core/resources/app_colors.dart';
import 'package:movie_app/core/resources/app_strings.dart';
import 'package:movie_app/core/resources/app_values.dart';
import 'package:movie_app/core/services/service_locator.dart';
import 'package:movie_app/features/search/presentation/components/no_results.dart';
import 'package:movie_app/features/search/presentation/components/search_grid_view.dart';
import 'package:movie_app/features/search/presentation/components/search_text.dart';
import 'package:movie_app/features/search/presentation/controllers/search_bloc/search_bloc.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SearchBloc>(),
      child: const SearchWidget(),
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(
            top: AppPadding.p12,
            left: AppPadding.p16,
            right: AppPadding.p16,
          ),
          child: Column(
            children: [
              SearchBar(),
              BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  switch (state.status) {
                    case SearchRequestStatus.empty:
                      return const SearchText();
                    case SearchRequestStatus.loading:
                      return const Expanded(child: LoadingIndicator());
                    case SearchRequestStatus.loaded:
                      return SearchGridView(results: state.searchResults);
                    case SearchRequestStatus.error:
                      return const Expanded(child: ErrorText());
                    case SearchRequestStatus.noResults:
                      return const NoResults();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class SearchBar extends StatefulWidget {
  const SearchBar({
    super.key,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Form(
      child: TextFormField(
        controller: _textController,
        cursorColor: AppColors.primaryText,
        cursorWidth: AppSize.s1,
        style: textTheme.bodyLarge,
        onChanged: (title) {
          context.read<SearchBloc>().add(GetSearchResultsEvent(title));
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
              context.read<SearchBloc>().add(const GetSearchResultsEvent(''));
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
    );
  }
}
