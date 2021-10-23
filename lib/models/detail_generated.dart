import 'data_detail.dart';

class DetailGenerated {
  bool success=false;
  String img="";
  int totalFacts=0;
  List<DataDetail> details=[];

  DetailGenerated({required this.success, required this.img, required this.totalFacts, required this.details});

  DetailGenerated.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    img = json['img'];
    totalFacts = json['total_facts'];
    if (json['data'] != null) {
      details = [];
      json['data'].forEach((v) {
        details.add(new DataDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['img'] = this.img;
    data['total_facts'] = this.totalFacts;
    if (this.details != null) {
      data['data'] = this.details.map((v) => v.toJson()).toList();
    }
    return data;
  }
}