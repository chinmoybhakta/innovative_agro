import 'dart:math';

import 'package:flutter/material.dart';
import 'package:innovative_agro_aid/core/utils/error_image.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;
  const ImageCarousel({super.key, required this.images});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return const SizedBox(
        width: 260,
        child: Center(child: Icon(Icons.image_not_supported)),
      );
    }

    return SizedBox(
      width: 260,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PageView.builder(
                  controller: _controller,
                  itemCount: widget.images.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (_, i) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        widget.images[i],
                        fit: BoxFit.fitWidth,
                        errorBuilder: (context, error, stackTrace) {
                          return ErrorImage(error: error);
                        },
                      ),
                    );
                  },
                ),

                // LEFT ARROW
                _arrow(Icons.chevron_left, () {
                  if (_index > 0) {
                    _controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                }, left: 0),

                // RIGHT ARROW
                _arrow(Icons.chevron_right, () {
                  if (_index < widget.images.length - 1) {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                }, right: 0),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // INDICATORS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
                  (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _index == i ? 10 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _index == i ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _arrow(IconData icon, VoidCallback onTap,
      {double? left, double? right}) {
    return Positioned(
      left: left,
      right: right,
      top: 0,
      bottom: 0,
      child: IconButton(
        icon: Icon(icon, size: 28, color: Colors.black87),
        onPressed: onTap,
      ),
    );
  }
}
