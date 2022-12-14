import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/get_walk_detail.dart';

class getWalkList extends generalResponse {
  WalkList? walkList;

  getWalkList(int statusCode, String message, WalkList walkList)
      : super(statusCode, message) {
    this.walkList = walkList;
  }

  getWalkList.fromJson(Map<String, dynamic> json)
      : super(json['statusCode'], json['message']) {
    walkList = json['walkList'] != null
        ? new WalkList.fromJson(json['walkList'])
        : null;
  }
}

class WalkList {
  List<Detail>? content;
  String? pageable;
  bool? last;
  int? totalElements;
  int? totalPages;
  int? number;
  int? size;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  WalkList(
      {this.content,
      this.pageable,
      this.last,
      this.totalElements,
      this.totalPages,
      this.number,
      this.size,
      this.sort,
      this.numberOfElements,
      this.first,
      this.empty});

  WalkList.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <Detail>[];
      json['content'].forEach((v) {
        print(Detail.fromJson(v));
        content!.add(Detail.fromJson(v));
      });
    }
    pageable = json['pageable'];
    last = json['last'];
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    number = json['number'];
    size = json['size'];
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    numberOfElements = json['numberOfElements'];
    first = json['first'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data['pageable'] = this.pageable;
    data['last'] = this.last;
    data['totalElements'] = this.totalElements;
    data['totalPages'] = this.totalPages;
    data['number'] = this.number;
    data['size'] = this.size;
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    data['numberOfElements'] = this.numberOfElements;
    data['first'] = this.first;
    data['empty'] = this.empty;
    return data;
  }
}

class Sort {
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Sort({this.empty, this.sorted, this.unsorted});

  Sort.fromJson(Map<String, dynamic> json) {
    empty = json['empty'];
    sorted = json['sorted'];
    unsorted = json['unsorted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empty'] = this.empty;
    data['sorted'] = this.sorted;
    data['unsorted'] = this.unsorted;
    return data;
  }
}
