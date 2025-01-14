class Report {
  final String id; // Changed to String to match ObjectId
  final int userId;
  final String description;
  final String category;
  final Geolocation geolocation;
  final String authority;
  final ImageData image;
  final bool resolved;
  final int createdAt;

  Report({
    required this.id,
    required this.userId,
    required this.description,
    required this.category,
    required this.geolocation,
    required this.authority,
    required this.image,
    required this.resolved,
    required this.createdAt,
  });

  // Factory constructor for creating a new Report instance from a map.
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['_id'],
      userId: json['user_id'],
      description: json['description'],
      category: json['category'],
      geolocation: Geolocation.fromJson(json['geolocation']),
      authority: json['authority'],
      image: ImageData.fromJson(json['image']),
      resolved: json['resolved'],
      createdAt: json['created_at'],
    );
  }

  // Method to convert a Report instance into a map.
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'description': description,
      'category': category,
      'geolocation': geolocation.toJson(),
      'authority': authority,
      'image': image.toJson(),
      'resolved': resolved,
      'created_at': createdAt,
    };
  }
}

class Geolocation {
  final String type;
  final Geometry geometry;

  Geolocation({
    required this.type,
    required this.geometry,
  });

  factory Geolocation.fromJson(Map<String, dynamic> json) {
    return Geolocation(
      type: json['type'],
      geometry: Geometry.fromJson(json['geometry']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'geometry': geometry.toJson(),
    };
  }
}

class Geometry {
  final String type;
  final List<double> coordinates;

  Geometry({
    required this.type,
    required this.coordinates,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      type: json['type'],
      coordinates: (json['coordinates'] as List).cast<double>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}

class ImageData {
  final String url;
  final String imageName;
  final List<int> dimensions;
  final ImageGeolocation geolocation;
  final int fileSize;

  ImageData({
    required this.url,
    required this.imageName,
    required this.dimensions,
    required this.geolocation,
    required this.fileSize,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      url: json['url'],
      imageName: json['image_name'],
      dimensions: (json['dimensions'] as List).cast<int>(),
      geolocation: ImageGeolocation.fromJson(json['geolocation']),
      fileSize: json['file_size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'image_name': imageName,
      'dimensions': dimensions,
      'geolocation': geolocation.toJson(),
      'file_size': fileSize,
    };
  }
}

class ImageGeolocation {
  final double lat;
  final double lon;

  ImageGeolocation({
    required this.lat,
    required this.lon,
  });

  factory ImageGeolocation.fromJson(Map<String, dynamic> json) {
    return ImageGeolocation(
      lat: json['Lat'],
      lon: json['Lon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Lat': lat,
      'Lon': lon,
    };
  }
}
