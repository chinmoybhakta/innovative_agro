import 'package:flutter/material.dart';

class ErrorImage extends StatelessWidget {
  final Object? error;
  final ImageChunkEvent? loadingProgress;
  final bool isLoading;

  const ErrorImage({
    super.key,
    this.error,
    this.loadingProgress,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Show loading indicator if loading
    if (isLoading) {
      return _buildLoadingWidget(loadingProgress);
    }

    // Show error widget if there's an error
    return _buildErrorWidget(error);
  }

  Widget _buildLoadingWidget(ImageChunkEvent? progress) {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: progress != null && progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              'Loading image...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            if (progress != null && progress.expectedTotalBytes != null)
              Text(
                '${(progress.cumulativeBytesLoaded / progress.expectedTotalBytes! * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 10),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(Object? error) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.broken_image,
            color: Colors.grey,
            size: 40,
          ),
          const SizedBox(height: 8),
          const Text(
            'Failed to load',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                error.toString(),
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}