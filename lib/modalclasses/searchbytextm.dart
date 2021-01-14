class SearchByTextM {
  String nextPageToken;
  List<SearchByTextResults> results;
  String status;

  SearchByTextM({this.nextPageToken, this.results, this.status});

  SearchByTextM.fromJson(Map<String, dynamic> json) {
    nextPageToken = json['next_page_token'];
    if (json['results'] != null) {
      results = new List<SearchByTextResults>();
      json['results'].forEach((v) {
        results.add(new SearchByTextResults.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['next_page_token'] = this.nextPageToken;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class SearchByTextResults {
  String businessStatus;
  String formattedAddress;
  Geometry geometry;
  String icon;
  String name;
  List<Photos> photos;
  String placeId;
  PlusCode plusCode;
  num rating;
  String reference;
  List<String> types;
  num userRatingsTotal;
  OpeningHours openingHours;

  SearchByTextResults(
      {this.businessStatus,
      this.formattedAddress,
      this.geometry,
      this.icon,
      this.name,
      this.photos,
      this.placeId,
      this.plusCode,
      this.rating,
      this.reference,
      this.types,
      this.userRatingsTotal,
      this.openingHours});

  SearchByTextResults.fromJson(Map<String, dynamic> json) {
    businessStatus = json['business_status'];
    formattedAddress = json['formatted_address'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    icon = json['icon'];
    name = json['name'];
    if (json['photos'] != null) {
      photos = new List<Photos>();
      json['photos'].forEach((v) {
        photos.add(new Photos.fromJson(v));
      });
    }
    placeId = json['place_id'];
    plusCode = json['plus_code'] != null
        ? new PlusCode.fromJson(json['plus_code'])
        : null;
    rating = json['rating'];
    reference = json['reference'];
    types = json['types'].cast<String>();
    userRatingsTotal = json['user_ratings_total'];
    openingHours = json['opening_hours'] != null
        ? new OpeningHours.fromJson(json['opening_hours'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_status'] = this.businessStatus;
    data['formatted_address'] = this.formattedAddress;
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    data['icon'] = this.icon;
    data['name'] = this.name;
    if (this.photos != null) {
      data['photos'] = this.photos.map((v) => v.toJson()).toList();
    }
    data['place_id'] = this.placeId;
    if (this.plusCode != null) {
      data['plus_code'] = this.plusCode.toJson();
    }
    data['rating'] = this.rating;
    data['reference'] = this.reference;
    data['types'] = this.types;
    data['user_ratings_total'] = this.userRatingsTotal;
    if (this.openingHours != null) {
      data['opening_hours'] = this.openingHours.toJson();
    }
    return data;
  }
}

class Geometry {
  LocationM location;
  Viewport viewport;

  Geometry({this.location, this.viewport});

  Geometry.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new LocationM.fromJson(json['location'])
        : null;
    viewport = json['viewport'] != null
        ? new Viewport.fromJson(json['viewport'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    if (this.viewport != null) {
      data['viewport'] = this.viewport.toJson();
    }
    return data;
  }
}

class LocationM {
  num lat;
  num lng;

  LocationM({this.lat, this.lng});

  LocationM.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Viewport {
  LocationM northeast;
  LocationM southwest;

  Viewport({this.northeast, this.southwest});

  Viewport.fromJson(Map<String, dynamic> json) {
    northeast = json['northeast'] != null
        ? new LocationM.fromJson(json['northeast'])
        : null;
    southwest = json['southwest'] != null
        ? new LocationM.fromJson(json['southwest'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.northeast != null) {
      data['northeast'] = this.northeast.toJson();
    }
    if (this.southwest != null) {
      data['southwest'] = this.southwest.toJson();
    }
    return data;
  }
}

class Photos {
  num height;
  List<String> htmlAttributions;
  String photoReference;
  num width;

  Photos({this.height, this.htmlAttributions, this.photoReference, this.width});

  Photos.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    htmlAttributions = json['html_attributions'].cast<String>();
    photoReference = json['photo_reference'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['html_attributions'] = this.htmlAttributions;
    data['photo_reference'] = this.photoReference;
    data['width'] = this.width;
    return data;
  }
}

class PlusCode {
  String compoundCode;
  String globalCode;

  PlusCode({this.compoundCode, this.globalCode});

  PlusCode.fromJson(Map<String, dynamic> json) {
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['compound_code'] = this.compoundCode;
    data['global_code'] = this.globalCode;
    return data;
  }
}

class OpeningHours {
  bool openNow;

  OpeningHours({this.openNow});

  OpeningHours.fromJson(Map<String, dynamic> json) {
    openNow = json['open_now'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['open_now'] = this.openNow;
    return data;
  }
}
