import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app/core/resources/app_theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(ThemeState(
            themeData: appThemeData[AppTheme.lightTheme]!,
            appTheme: AppTheme.lightTheme)) {
    on<ThemeChanged>((event, emit) {
      emit(
        ThemeState(
            themeData: appThemeData[event.theme]!, appTheme: event.theme),
      );
    });
  }
}
