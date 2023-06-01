abstract class IModelPagination {}

abstract class IModelWithId extends IModelPagination {
  final String id;
  IModelWithId({required this.id});
}

abstract class IModelWithPostDTAndPostDateInd extends IModelPagination {
  final DateTime postDT;
  final int postDateInd;

  IModelWithPostDTAndPostDateInd(
      {required this.postDT, required this.postDateInd});
}
