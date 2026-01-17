import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'audio_service.dart';
import 'services/connectivity_service.dart';
import 'core/app_config.dart';
import 'core/app_styles.dart';

class WochenDetailSeite extends StatefulWidget {
  final String wochenNummer;
  final String titel;
  final List<Map<String, String>> audios;
  final List<Map<String, String>> pdfs;
  final List<String> wochenAufgaben;

  const WochenDetailSeite({
    super.key,
    required this.wochenNummer,
    required this.titel,
    required this.audios,
    required this.pdfs,
    this.wochenAufgaben = const [],
  });

  @override
  State<WochenDetailSeite> createState() => _WochenDetailSeiteState();
}

class _WochenDetailSeiteState extends State<WochenDetailSeite> {
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text(
          widget.wochenNummer,
          style: AppStyles.headingStyle.copyWith(fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppStyles.softBrown, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Offline-Banner
          StreamBuilder<bool>(
            stream: ConnectivityService.onlineStream,
            initialData: ConnectivityService.isOnline,
            builder: (context, snapshot) {
              final isOnline = snapshot.data ?? true;
              if (isOnline) return const SizedBox.shrink();

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off,
                      size: 18,
                      color: Colors.orange.shade800,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Offline - Audios können nicht geladen werden',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 120), // Platz für Player & Floating Nav
              children: [
                Text(
                  widget.titel,
                  style: AppStyles.titleStyle,
                ),
                const SizedBox(height: 32),

                // NEU: Wochenaufgaben Sektion
                if (widget.wochenAufgaben.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppStyles.primaryOrange.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: AppStyles.primaryOrange.withOpacity(0.1),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.assignment_outlined,
                              color: AppStyles.primaryOrange,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Deine Übungen",
                              style: AppStyles.headingStyle.copyWith(
                                fontSize: 18,
                                color: AppStyles.primaryOrange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ...widget.wochenAufgaben.map(
                          (aufgabe) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 2),
                                  child: const Icon(
                                    Icons.check_circle_outline,
                                    color: AppStyles.sageGreen,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    aufgabe,
                                    style: AppStyles.bodyStyle.copyWith(
                                      height: 1.6,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],

                if (widget.pdfs.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 16),
                    child: Text(
                      "UNTERLAGEN",
                      style: AppStyles.bodyStyle.copyWith(
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppStyles.softBrown.withOpacity(0.5),
                      ),
                    ),
                  ),
                  ...widget.pdfs.map((pdf) => _buildPdfCard(pdf)),
                  const SizedBox(height: 40),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: StreamBuilder<AudioServiceStatus>(
        stream: _audioService.statusStream,
        builder: (context, snapshot) {
          final isVisible = _audioService.currentAppwriteId != null;
          return isVisible ? _playerBar() : const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPdfCard(Map<String, String> pdf) {
    final appwriteId = pdf['appwrite_id'];
    final url = '${AppConfig.appwriteEndpoint}/storage/buckets/${AppConfig.pdfsBucketId}/files/$appwriteId/view?project=${AppConfig.appwriteProjectId}';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(url)),
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppStyles.softBrown.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: AppStyles.softBrown,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  pdf['title']!,
                  style: AppStyles.subTitleStyle,
                ),
              ),
              const Icon(Icons.open_in_new, color: AppStyles.borderColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _playerBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 100), // Schwebend über BottomNav
      decoration: BoxDecoration(
        color: const Color(0xFFFBF7F2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppStyles.primaryOrange.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _audioService.currentTitle ?? '',
                  style: AppStyles.subTitleStyle.copyWith(fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              StreamBuilder<AudioServiceStatus>(
                stream: _audioService.statusStream,
                builder: (context, snapshot) {
                  final isPlaying = _audioService.status == AudioServiceStatus.playing;
                  return IconButton(
                    icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                    iconSize: 40,
                    color: AppStyles.primaryOrange,
                    onPressed: () {
                      if (isPlaying) {
                        _audioService.pause();
                      } else {
                        if (_audioService.currentAppwriteId != null) {
                          _audioService.play({
                            'appwrite_id': _audioService.currentAppwriteId!,
                            'title': _audioService.currentTitle!,
                          });
                        }
                      }
                    },
                  );
                },
              ),
            ],
          ),
          StreamBuilder<Duration>(
            stream: _audioService.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = _audioService.duration ?? Duration.zero;
              return Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                    ),
                    child: Slider(
                      activeColor: AppStyles.primaryOrange,
                      inactiveColor: AppStyles.primaryOrange.withOpacity(0.1),
                      value: position.inSeconds.toDouble(),
                      max: duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 1.0,
                      onChanged: (value) {
                        _audioService.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(position), style: const TextStyle(fontSize: 10)),
                        Text(_formatDuration(duration), style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final min = d.inMinutes.remainder(60);
    final sec = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$min:$sec";
  }
}
