class PhotoModel {
  PhotoModel({
    required this.id,
    required this.imageUrl,
    required this.fileSize,
    required this.createdAt,
    required this.isFavorite,
    required this.isAi,
  });

  final String id;
  final String imageUrl;
  final double fileSize;
  final DateTime createdAt;
  final bool isFavorite;
  final bool isAi;

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    final image = (json['image'] ?? json['url'] ?? json['photoUrl'] ?? json['secureUrl'] ?? json['path'] ?? '').toString();
    final sizeVal = json['fileSize'] ?? json['size'] ?? json['bytes'] ?? 0;
    double sizeMb = 0.0;
    if (sizeVal is num) {
      sizeMb = sizeVal > 1024 ? sizeVal / (1024 * 1024) : sizeVal.toDouble();
    } else if (sizeVal is String) {
      sizeMb = double.tryParse(sizeVal) ?? 0.0;
    }

    return PhotoModel(
      id: (json['_id'] ?? json['id'] ?? json['uuid'] ?? '').toString(),
      imageUrl: image,
      fileSize: sizeMb > 0 ? sizeMb : 2.4,
      createdAt: DateTime.tryParse((json['createdAt'] ?? json['updatedAt'] ?? json['date'] ?? '').toString()) ?? DateTime.now(),
      isFavorite: json['isFavorite'] == true || json['favorite'] == true,
      isAi: json['isAi'] == true || json['ai'] == true || image.contains('ai-images'),
    );
  }

  String get fileSizeLabel => '${fileSize.toStringAsFixed(1)} MB';

  String get dateLabel {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[createdAt.month - 1]} ${createdAt.day.toString().padLeft(2, '0')}';
  }
}
