class Lines {
  int? id;
  double? disc;
  String? fromDate;
  String? toDate;
  Lines({Lines? model});

  Map<String, dynamic> toJsonDisc() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['disc'] = this.disc;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    return data;
  }

  Map toJson() => {
    'id': id,
    'disc': disc,
    'fromDate': fromDate,
    'toDate': toDate
  };

  Lines.fromJson(Map json) {
    id = json['id'];
    disc = json['disc'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
  }
}
