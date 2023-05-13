class DiaryModel {
  // // id : 유일 아이디 값
  // final String id;
  // // title : 제목
  // final String title;
  // // writer : 작성자
  // final String writer;
  // // weather : 날씨
  // final String weather;
  // // hashTags : 해시태그 리스트
  // final List<String> hashTags;
  // // postDate : 표출 일자 -> 다이어리의 표출 일자, 사용자는 해당 값으로 ordering을 진행할 예정
  // final DateTime postDate;
  // // thumnail : 썸네일 -> S3에 저장된 이미지, vid 의 경로
  // final String thumnail;
  // // category : 카테고리 -> 카테고리를 통해서 다이어리 리스트 페이지에서 필터링을 진행할 예정
  // final String category;
  // // isShown : 표출 여부
  // final bool isShown;
  // // regDTime : 등록 일자 -> 추후 mongoDB default 값 사용 예정
  // final DateTime regDTime;
  // // modDTime : 수정 일자 -> 추후 mongoDB default 값 사용 예정
  // final DateTime modDTime;

  // id : 유일 아이디 값
  String id;
  // title : 제목
  String title;
  // writer : 작성자
  String writer;
  // weather : 날씨
  String weather;
  // hashTags : 해시태그 리스트
  List<String> hashTags;
  // postDate : 표출 일자 -> 다이어리의 표출 일자, 사용자는 해당 값으로 ordering을 진행할 예정
  DateTime postDate;
  // thumnail : 썸네일 -> S3에 저장된 이미지, vid 의 경로
  String thumnail;
  // category : 카테고리 -> 카테고리를 통해서 다이어리 리스트 페이지에서 필터링을 진행할 예정
  String category;
  // isShown : 표출 여부
  bool isShown;
  // regDTime : 등록 일자 -> 추후 mongoDB default 값 사용 예정
  DateTime regDTime;
  // modDTime : 수정 일자 -> 추후 mongoDB default 값 사용 예정
  DateTime modDTime;

  DiaryModel({
    required this.id,
    required this.title,
    required this.writer,
    required this.weather,
    required this.hashTags,
    required this.postDate,
    required this.thumnail,
    required this.category,
    required this.isShown,
    required this.regDTime,
    required this.modDTime,
  });

  factory DiaryModel.empty() => DiaryModel(
        id: '',
        title: '',
        writer: '',
        weather: '',
        hashTags: [],
        postDate: DateTime.now(),
        thumnail: '',
        category: '',
        isShown: true,
        regDTime: DateTime.now(),
        modDTime: DateTime.now(),
      );
}

class DiaryDetailModel extends DiaryModel {
  // // txts : 텍스트 리스트
  // final List<String> txts;
  // // imgs : 이미지 리스트
  // final List<String> imgs;
  // // vids : 비디오 리스트 -> 초기에는 직접 로딩하지 않고
  // final List<String> vids;
  // // contentOrder : 컨텐츠 순서
  // // 추후 markdown 형식으로 저장할 예정
  // // 현재는 위 3가지 txt,img,vid의 표출 순서를 정의
  // final List<String> contentOrder;

  // txts : 텍스트 리스트
  List<String> txts;
  // imgs : 이미지 리스트
  List<String> imgs;
  // vids : 비디오 리스트 -> 초기에는 직접 로딩하지 않고
  List<String> vids;
  // contentOrder : 컨텐츠 순서
  // 추후 markdown 형식으로 저장할 예정
  // 현재는 위 3가지 txt,img,vid의 표출 순서를 정의
  List<String> contentOrder;

  DiaryDetailModel({
    required super.id,
    required super.title,
    required super.writer,
    required super.weather,
    required super.hashTags,
    required super.postDate,
    required super.thumnail,
    required super.category,
    required super.isShown,
    required super.regDTime,
    required super.modDTime,
    required this.txts,
    required this.imgs,
    required this.vids,
    required this.contentOrder,
  });

  factory DiaryDetailModel.empty() => DiaryDetailModel(
        id: '',
        title: '',
        writer: '',
        weather: '',
        hashTags: [],
        postDate: DateTime.now(),
        thumnail: '',
        category: '',
        isShown: true,
        regDTime: DateTime.now(),
        modDTime: DateTime.now(),
        txts: [],
        imgs: [],
        vids: [],
        contentOrder: [],
      );

  DiaryDetailModel copyWith({
    String? id,
    String? title,
    String? writer,
    String? weather,
    List<String>? hashTags,
    DateTime? postDate,
    String? thumnail,
    String? category,
    bool? isShown,
    DateTime? regDTime,
    DateTime? modDTime,
    List<String>? txts,
    List<String>? imgs,
    List<String>? vids,
    List<String>? contentOrder,
  }) {
    return DiaryDetailModel(
      id: id ?? this.id,
      title: title ?? this.title,
      writer: writer ?? this.writer,
      weather: weather ?? this.weather,
      hashTags: hashTags ?? this.hashTags,
      postDate: postDate ?? this.postDate,
      thumnail: thumnail ?? this.thumnail,
      category: category ?? this.category,
      isShown: isShown ?? this.isShown,
      regDTime: regDTime ?? this.regDTime,
      modDTime: modDTime ?? this.modDTime,
      txts: txts ?? this.txts,
      imgs: imgs ?? this.imgs,
      vids: vids ?? this.vids,
      contentOrder: contentOrder ?? this.contentOrder,
    );
  }
}
