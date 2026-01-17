import 'package:flutter/material.dart';
import 'app_daten.dart';
import 'audio_service.dart';
import 'services/connectivity_service.dart';
import 'constants/app_texts.dart';
import 'core/app_styles.dart';

class MediathekSeite extends StatefulWidget {
  const MediathekSeite({super.key});

  @override
  State<MediathekSeite> createState() => _MediathekSeiteState();
}

class _MediathekSeiteState extends State<MediathekSeite> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final AudioService _audioService = AudioService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _play(Map<String, String> audio) async {
    try {
      await _audioService.play(audio);
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Fehler beim Laden des Audios. Bitte Internetverbindung prüfen.",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAudioInfo(Map<String, String> audio) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppStyles.bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppStyles.softBrown.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(audio['title']!, style: AppStyles.headingStyle),
            const SizedBox(height: 16),
            Text(
              audio['description'] ?? "Keine Beschreibung verfügbar.",
              style: AppStyles.bodyStyle.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> audios = AppDaten.getAlleAudios();

    if (_searchQuery.isNotEmpty) {
      audios = audios
          .where(
            (a) =>
                a['title']!.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Header mit Info-Button
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mediathek', style: AppStyles.headingStyle),
                IconButton(
                  icon: const Icon(
                    Icons.info_outline,
                    color: AppStyles.softBrown,
                  ),
                  onPressed: () => _showTrackingInfo(context),
                  tooltip: 'Über das Tracking',
                ),
              ],
            ),
          ),
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
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: TextField(
              controller: _searchController,
              style: AppStyles.bodyStyle,
              decoration: InputDecoration(
                hintText: "Suchen...",
                hintStyle: AppStyles.bodyStyle.copyWith(
                  color: AppStyles.softBrown.withOpacity(0.5),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppStyles.softBrown,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: AppStyles.primaryOrange,
                    width: 1.5,
                  ),
                ),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: audios.length,
              padding: const EdgeInsets.fromLTRB(
                24,
                8,
                24,
                120,
              ), // Platz für Player & Floating Nav
              itemBuilder: (context, i) {
                final audio = audios[i];
                final String audioId = audio['appwrite_id'] ?? '';

                return StreamBuilder<AudioServiceStatus>(
                  stream: _audioService.statusStream,
                  builder: (context, snapshot) {
                    final bool isCurrent =
                        _audioService.currentAppwriteId == audioId;
                    final bool isPlaying =
                        isCurrent &&
                        _audioService.status == AudioServiceStatus.playing;
                    final bool isLoading =
                        isCurrent &&
                        _audioService.status == AudioServiceStatus.loading;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 0,
                      color: Colors.white,
                      shape: AppStyles.cardShape.copyWith(
                        side: BorderSide(
                          color: isCurrent
                              ? AppStyles.primaryOrange.withOpacity(0.5)
                              : Colors.grey.withOpacity(0.15),
                          width: isCurrent ? 2 : 1.5,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => _play(audio),
                        borderRadius: BorderRadius.circular(28),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              // Play/Pause Button
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: isPlaying
                                      ? AppStyles.primaryOrange
                                      : AppStyles.primaryOrange.withOpacity(
                                          0.1,
                                        ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : Icon(
                                          isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: isPlaying
                                              ? Colors.white
                                              : AppStyles.primaryOrange,
                                          size: 32,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              // Title & Duration
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      audio['title']!,
                                      style: AppStyles.subTitleStyle.copyWith(
                                        color: isCurrent
                                            ? AppStyles.primaryOrange
                                            : AppStyles.softBrown,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 14,
                                          color: AppStyles.softBrown
                                              .withOpacity(0.5),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '• ${audio['duration'] ?? ''}',
                                          style: AppStyles.bodyStyle.copyWith(
                                            color: AppStyles.softBrown
                                                .withOpacity(0.6),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Info Button
                              if (audio['description'] != null &&
                                  audio['description']!.isNotEmpty)
                                IconButton(
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: AppStyles.softBrown.withOpacity(0.4),
                                  ),
                                  onPressed: () => _showAudioInfo(audio),
                                ),
                              // Indicator for playing
                              if (isPlaying)
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: AppStyles.primaryOrange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: StreamBuilder<AudioServiceStatus>(
        stream: _audioService.statusStream,
        builder: (context, snapshot) {
          if (_audioService.currentAppwriteId == null)
            return const SizedBox.shrink();
          return _playerBar();
        },
      ),
    );
  }

  Widget _playerBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        100,
      ), // Schwebend über BottomNav
      decoration: BoxDecoration(
        color: AppStyles.bgColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppStyles.primaryOrange.withOpacity(0.2),
          width: 1.5,
        ),
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
                  final isPlaying =
                      _audioService.status == AudioServiceStatus.playing;
                  return IconButton(
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                    ),
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
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 14,
                      ),
                    ),
                    child: Slider(
                      activeColor: AppStyles.primaryOrange,
                      inactiveColor: AppStyles.primaryOrange.withOpacity(0.1),
                      value: position.inSeconds.toDouble(),
                      max: duration.inSeconds > 0
                          ? duration.inSeconds.toDouble()
                          : 1.0,
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
                        Text(
                          _formatDuration(position),
                          style: const TextStyle(fontSize: 10),
                        ),
                        Text(
                          _formatDuration(duration),
                          style: const TextStyle(fontSize: 10),
                        ),
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

  /// Zeigt Tracking-Info-Dialog
  void _showTrackingInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppTexts.trackingInfoTitle,
          style: AppStyles.headingStyle.copyWith(fontSize: 20),
        ),
        content: Text(AppTexts.trackingInfoText, style: AppStyles.bodyStyle),
        backgroundColor: AppStyles.bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Verstanden",
              style: AppStyles.bodyStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: AppStyles.primaryOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
