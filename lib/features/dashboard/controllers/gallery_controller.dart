import 'package:get/get.dart';
import '../../../core/models/photo_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';

class GalleryController extends GetxController {
  GalleryController({ApiClient? apiClient, TokenStorage? tokenStorage})
      : _apiClient = apiClient ?? ApiClient(),
        _tokenStorage = tokenStorage ?? TokenStorage();

  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  final photos = <PhotoModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  bool get hasError => errorMessage.value.isNotEmpty;
  bool get isEmpty => photos.isEmpty && !isLoading.value && !hasError;

  double get totalStorageMb =>
      photos.fold<double>(0, (sum, photo) => sum + photo.fileSize);

  @override
  void onInit() {
    super.onInit();
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final token = await _tokenStorage.getToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = 'Please log in to view your gallery.';
        return;
      }
      final response = await _apiClient.getMyPhotos(token);
      if (response.success && response.data != null) {
        photos.assignAll(response.data!.map(PhotoModel.fromJson).toList());
      } else {
        errorMessage.value = response.message;
      }
    } catch (_) {
      errorMessage.value = 'Failed to load photos. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> refresh() => fetchPhotos();
}
