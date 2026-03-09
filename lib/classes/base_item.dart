// The base class for the category and account class
// Both will have the same structure

abstract class BaseItem {
  final String name;
  final String imgAsset;
  final String id;

  const BaseItem({
    required this.name,
    required this.imgAsset,
    required this.id,
  });
}

// Account class
class Account extends BaseItem {
  const Account({
    required super.name,
    required super.imgAsset,
    required super.id,
  });
}

// Category class
class Category extends BaseItem {
  const Category({
    required super.name,
    required super.imgAsset,
    required super.id,
  });
}
