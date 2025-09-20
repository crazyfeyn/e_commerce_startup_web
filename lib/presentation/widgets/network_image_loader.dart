import 'dart:typed_data';
import 'package:e_commerce_startup_web/core/utils/app_colors.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_service.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Oddiy xotira keshi (faqat sahifa ochiq turgan payt)
class _MemoryImageCache {
  static final Map<String, Uint8List> _cache = {};

  static Uint8List? get(String url) => _cache[url];

  static void set(String url, Uint8List bytes) => _cache[url] = bytes;
}

/// Oldingi `NetworkImageLoader` widgetini shu faylga qo‘shib ishlatish kerak.
/// (shu koddan oldin biz yozgan versiyani qo‘ying)

class ImageCarousel extends StatefulWidget {
  final List<String> urls;

  const ImageCarousel({super.key, required this.urls});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          PageView.builder(
            itemCount: widget.urls.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: double.infinity,
                child: NetworkImageLoader(
                  url: "${NetworkService.getService}${NetworkService.apiFileDownload(widget.urls[index])}",
                ),
              );
            },
          ),

          Positioned(
            bottom: 4,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: widget.urls.length,
              effect: WormEffect(
                activeDotColor: AppColors.primary700,
                dotColor: Colors.grey.shade400,
                dotHeight: 8,
                dotWidth: 8,
                // expansionFactor: 3,
                spacing: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class NetworkImageLoader extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;

  const NetworkImageLoader({
    super.key,
    required this.url,
    this.width,
    this.height,
  });

  @override
  State<NetworkImageLoader> createState() => _NetworkImageLoaderState();
}

class _NetworkImageLoaderState extends State<NetworkImageLoader> {
  Uint8List? _imageBytes;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    // Avval cache dan tekshiramiz
    final cached = _MemoryImageCache.get(widget.url);
    if (cached != null) {
      _imageBytes = cached;
      _isLoading = false;
    } else {
      _downloadImage();
    }
  }

  Future<void> _downloadImage() async {
    try {
      final response = await Dio().get<List<int>>(
        widget.url,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = Uint8List.fromList(response.data!);

      // Cache ga yozib qo‘yamiz
      _MemoryImageCache.set(widget.url, bytes);

      setState(() {
        _imageBytes = bytes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_hasError || _imageBytes == null) {
      return const Icon(Icons.error, size: 50, color: Colors.red);
    }
    return Image.memory(
      _imageBytes!,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.cover,
    );
  }
}
