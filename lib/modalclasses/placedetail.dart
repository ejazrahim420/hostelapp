class PlaceDetailM {
  ResultOfDetailM result;
  String status;

  PlaceDetailM({this.result, this.status});

  PlaceDetailM.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null
        ? new ResultOfDetailM.fromJson(json['result'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class ResultOfDetailM {
  String formattedPhoneNumber;
  String name;
  num rating;
  List<Reviews> reviews;

  ResultOfDetailM(
      {this.formattedPhoneNumber, this.name, this.rating, this.reviews});

  ResultOfDetailM.fromJson(Map<String, dynamic> json) {
    formattedPhoneNumber = json['formatted_phone_number'];
    name = json['name'];
    rating = json['rating'];
    if (json['reviews'] != null) {
      reviews = new List<Reviews>();
      json['reviews'].forEach((v) {
        reviews.add(new Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['formatted_phone_number'] = this.formattedPhoneNumber;
    data['name'] = this.name;
    data['rating'] = this.rating;
    if (this.reviews != null) {
      data['reviews'] = this.reviews.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reviews {
  String authorName;
  String authorUrl;
  String language;
  String profilePhotoUrl;
  int rating;
  String relativeTimeDescription;
  String text;
  int time;

  Reviews(
      {this.authorName,
      this.authorUrl,
      this.language,
      this.profilePhotoUrl,
      this.rating,
      this.relativeTimeDescription,
      this.text,
      this.time});

  Reviews.fromJson(Map<String, dynamic> json) {
    authorName = json['author_name'];
    authorUrl = json['author_url'];
    language = json['language'];
    profilePhotoUrl = json['profile_photo_url'];
    rating = json['rating'];
    relativeTimeDescription = json['relative_time_description'];
    text = json['text'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author_name'] = this.authorName;
    data['author_url'] = this.authorUrl;
    data['language'] = this.language;
    data['profile_photo_url'] = this.profilePhotoUrl;
    data['rating'] = this.rating;
    data['relative_time_description'] = this.relativeTimeDescription;
    data['text'] = this.text;
    data['time'] = this.time;
    return data;
  }
}
