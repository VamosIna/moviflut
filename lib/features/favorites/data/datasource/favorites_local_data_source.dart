import 'package:hive_flutter/hive_flutter.dart';

import 'package:movie_app/features/favorites/data/models/favorite_item_model.dart';

abstract class FavoritesListLocalDataSource {
  Future<List<FavoritelistItemModel>> getFavoriteListItems();
  Future<List<FavoritelistItemModel>> searchFavoriteListItems(String q);
  Future<int> addFavoriteListItem(FavoritelistItemModel item);
  Future<void> removeFavoriteListItem(int index);
  Future<int> isItemAdded(int tmdbID);
}

class FavoriteslistLocalDataSourceImpl extends FavoritesListLocalDataSource {
  final Box _box = Hive.box('items');

  @override
  Future<List<FavoritelistItemModel>> getFavoriteListItems() async {
    return _box.values
        .map((e) => FavoritelistItemModel.fromEntity(e))
        .toList()
        .reversed
        .toList();
  }
  @override
  Future<List<FavoritelistItemModel>> searchFavoriteListItems(String q) async {
    return _box.values
        .map((e) => FavoritelistItemModel.fromEntity(e)).where((element) => element.title.toLowerCase().contains("$q"))
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<int> addFavoriteListItem(FavoritelistItemModel item) async {
    return await _box.add(item);
  }

  @override
  Future<void> removeFavoriteListItem(int index) async {
    await _box.deleteAt(index);
  }

  @override
  Future<int> isItemAdded(int tmdbID) async {
    return _box.values.toList().indexWhere((e) => e.tmdbID == tmdbID);
  }
}
