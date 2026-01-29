import 'package:flutter/material.dart';
import 'package:innovative_agro_aid/feature/user/widgets/animated_wave_container.dart';
import '../../../../../core/const/network_img.dart';
import '../../../../../core/utils/error_image.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 800;
    return AnimatedWaveContainer(
      color: Colors.green,
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isSmallScreen
                    ? const SizedBox.shrink()
                    : RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                      colors: [Colors.white, Colors.grey],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds),
                                child: const Text(
                                  'Innovative Agro Aid',
                                  style: TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(
                              text: '\n',
                              style: TextStyle(fontSize: 8),
                            ),
                            const TextSpan(
                              text: 'Quality Products for a ',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                            WidgetSpan(
                              child: Text(
                                'Better Tomorrow',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: 250,
                  child: Image.network(
                    NetworkImg.logo,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return ErrorImage(error: error);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
