class DataDetail {
  int factId=0;
  String fact="";

  DataDetail({required this.factId,required this.fact});

  DataDetail.fromJson(Map<String, dynamic> json) {
    factId = json['fact_id'];
    fact = json['fact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fact_id'] = this.factId;
    data['fact'] = this.fact;
    return data;
  }
}