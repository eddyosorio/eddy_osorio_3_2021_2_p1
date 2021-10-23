import 'package:eddy_osorio_3_2021_2_p1/models/data_anime.dart';

class AnimeGenerated {
  bool success=false;
  List<DataAnime> datas=[];

  AnimeGenerated({required this.success, required this.datas});

  AnimeGenerated.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      datas = [];
      json['data'].forEach((v) {
        datas.add(new DataAnime.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.datas != null) {
      data['data'] = this.datas.map((v) => v.toJson()).toList();
    }
    return data;
  }
}