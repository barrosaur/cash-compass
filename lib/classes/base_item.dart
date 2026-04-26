import 'package:hive/hive.dart';
part 'base_item.g.dart';

abstract class BaseItem extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String imgAsset;
  @HiveField(2)
  final String id;

  BaseItem({
    required this.name,
    required this.imgAsset,
    required this.id,
  });
}

@HiveType(typeId: 2)
class Account extends BaseItem {
  Account({
    required super.name,
    required super.imgAsset,
    required super.id,
  });
}

@HiveType(typeId: 3)
class Category extends BaseItem {
  Category({
    required super.name,
    required super.imgAsset,
    required super.id,
  });
}
