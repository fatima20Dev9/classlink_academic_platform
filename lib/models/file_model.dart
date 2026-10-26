class FileModel {
  String url;
  String name;
  double size;
  String type;

  FileModel({
    required this.url,
    required this.name,
    required this.size,
    required this.type,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      url: json['url'] ?? '',
      name: json['name'] ?? '',
      size: (json['size'] ?? 0).toDouble(),
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "url": url,
      "name": name,
      "size": size,
      "type": type,
    };
  }

  String get formattedSize {
    if (size <= 0) return '';

    if (size < 1024) {
      return '${size.toStringAsFixed(0)} B';
    }

    if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)} KB';
    }

    return '${(size / 1024 / 1024).toStringAsFixed(1)} MB';
  }
}