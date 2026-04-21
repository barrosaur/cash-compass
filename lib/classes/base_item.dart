abstract class BaseItem {
  final String name;
  final String imgAsset;
  final String id;

  BaseItem({
    required this.name,
    required this.imgAsset,
    required this.id,
  });
}

class Account extends BaseItem {
  Account({
    required super.name,
    required super.imgAsset,
    required super.id,
  });
}

class Category extends BaseItem {
  Category({
    required super.name,
    required super.imgAsset,
    required super.id,
  });
}
