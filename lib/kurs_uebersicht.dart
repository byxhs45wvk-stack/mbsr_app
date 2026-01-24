import 'package:flutter/material.dart';
import 'wochen_detail_seite.dart';
import 'vertiefung_seite.dart';
import 'profil_seite.dart';
import 'tag_der_achtsamkeit_seite.dart';
import 'app_daten.dart';
import 'mediathek_seite.dart';
import 'web_utils.dart' show setRoute;
import 'services/connectivity_service.dart';
import 'package:flutter/services.dart';
import 'core/app_styles.dart';
import 'audio_service.dart';
import 'widgets/ambient_background.dart';
import 'widgets/animated_play_button.dart';
import 'widgets/decorative_blobs.dart';
import 'widgets/subtle_divider.dart';

class KursUebersicht extends StatefulWidget {
  final String kursTyp;
  final int initialIndex;

  const KursUebersicht({
    super.key,
    this.kursTyp = "MBSR",
    this.initialIndex = 0,
  });

  @override
  State<KursUebersicht> createState() => _KursUebersichtState();
}

class _KursUebersichtState extends State<KursUebersicht> {
  late int _currentIndex;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  final GlobalKey<NavigatorState> _kursNavigatorKey = GlobalKey<NavigatorState>();
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _updateUrl(_currentIndex);
  }

  void _updateUrl(int index) {
    switch (index) {
      case 0: setRoute('/home'); break;
      case 1: setRoute('/mediathek'); break;
      case 2: setRoute('/vertiefung'); break;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Öffnet den Full-Screen Player im Headspace-Stil
  void _showFullPlayer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: AppStyles.bgColor,
      barrierColor: Colors.black.withOpacity(0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.95,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => _buildFullPlayerContent(),
      ),
    ).whenComplete(() {
      // WICHTIG: Stoppe Audio, wenn Player geschlossen wird
      _audioService.stop();
    });
  }

  Widget _buildFullPlayerContent() {
    return AmbientBackground(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppStyles.spacingXL),
        child: Column(
        children: [
          AppStyles.spacingMBox,
          // Header mit Handle und Schließen-Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Handle/Indicator
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppStyles.softBrown.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          // Schließen-Button oben rechts
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: AppStyles.textDark.withOpacity(0.6),
                size: AppStyles.iconSizeL,
              ),
              onPressed: () {
                _audioService.stop(); // Audio stoppen
                Navigator.of(context).pop(); // Modal schließen
              },
              tooltip: 'Schließen & Stoppen',
            ),
          ),
          AppStyles.spacingLBox,
          
          // Cover/Icon Area
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: AppStyles.primaryOrange.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.self_improvement,
                  size: 120,
                  color: AppStyles.primaryOrange,
                ),
              ),
            ),
          ),
          
          AppStyles.spacingXXLBox,
          
          // Title & Description
          Text(
            _audioService.currentTitle ?? 'Audio',
            style: AppStyles.titleStyle.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          AppStyles.spacingSBox,
          Text(
            "Achtsamkeitspraxis",
            style: AppStyles.bodyStyle.copyWith(
              color: AppStyles.softBrown.withOpacity(0.6),
              letterSpacing: 1.2,
            ),
          ),
          
          AppStyles.spacingXXLBox,
          
          // Progress Area
          StreamBuilder<Duration>(
            stream: _audioService.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = _audioService.duration ?? Duration.zero;
              
              return Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 6,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                      activeTrackColor: AppStyles.primaryOrange,
                      inactiveTrackColor: AppStyles.primaryOrange.withOpacity(0.1),
                      thumbColor: AppStyles.primaryOrange,
                    ),
                    child: Slider(
                      value: position.inSeconds.toDouble(),
                      max: duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 1.0,
                      onChanged: (value) {
                        HapticFeedback.selectionClick();
                        _audioService.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(position), style: AppStyles.bodyStyle.copyWith(fontSize: 12)),
                        Text(_formatDuration(duration), style: AppStyles.bodyStyle.copyWith(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          
          AppStyles.spacingXLBox,
          
          // Controls Area
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Back 10s
              AnimatedIconButton(
                icon: Icons.replay_10,
                iconSize: 36,
                color: AppStyles.softBrown,
                tooltip: '10 Sekunden zurück',
                onPressed: () {
                  final newPos = _audioService.position - const Duration(seconds: 10);
                  _audioService.seek(newPos < Duration.zero ? Duration.zero : newPos);
                },
              ),
              AppStyles.spacingLHorizontal,
              // Play/Pause Large
              StreamBuilder<AudioServiceStatus>(
                stream: _audioService.statusStream,
                builder: (context, snapshot) {
                  final isPlaying = _audioService.status == AudioServiceStatus.playing;
                  return AnimatedPlayButton(
                    isPlaying: isPlaying,
                    size: 56,
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
              AppStyles.spacingLHorizontal,
              // Forward 30s
              AnimatedIconButton(
                icon: Icons.forward_30,
                iconSize: 36,
                color: AppStyles.softBrown,
                tooltip: '30 Sekunden vor',
                onPressed: () {
                  final newPos = _audioService.position + const Duration(seconds: 30);
                  final duration = _audioService.duration ?? Duration.zero;
                  _audioService.seek(newPos > duration ? duration : newPos);
                },
              ),
            ],
          ),
          
          const Spacer(),
          AppStyles.spacingXXLBox,
        ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildKursPfad(),
      const MediathekSeite(),
      VertiefungSeite(
        tagDerAchtsamkeit: AppDaten.tagDerAchtsamkeit,
        zusatzUebungen: AppDaten.zusatzUebungen,
      ),
    ];

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text("MBSR Kurs", style: AppStyles.headingStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: AppStyles.softBrown, size: AppStyles.iconSizeL),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilSeite()),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              StreamBuilder<bool>(
                stream: ConnectivityService.onlineStream,
                initialData: ConnectivityService.isOnline,
                builder: (context, snapshot) {
                  final isOnline = snapshot.data ?? true;
                  if (isOnline) return const SizedBox.shrink();
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, size: 18, color: Colors.orange.shade800),
                        const SizedBox(width: 8),
                        Text(
                          'Keine Internetverbindung',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.orange.shade900),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Expanded(child: pages[_currentIndex]),
            ],
          ),
          
          // Globaler Mini-Player-Balken
          StreamBuilder<AudioServiceStatus>(
            stream: _audioService.statusStream,
            builder: (context, snapshot) {
              if (_audioService.currentAppwriteId == null) return const SizedBox.shrink();
              return Positioned(
                left: 20,
                right: 20,
                bottom: 110,
                child: GestureDetector(
                  onTap: _showFullPlayer, // Öffnet den großen Player
                  child: _buildMiniPlayerBar(),
                ),
              );
            },
          ),

          // Floating Nav
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: _buildFloatingBottomNav(),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniPlayerBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: AppStyles.glassBlur,
        child: Container(
          decoration: BoxDecoration(
            color: AppStyles.glassBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppStyles.glassBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
          Row(
            children: [
              // Kleines Vorschaubild/Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppStyles.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.self_improvement, color: AppStyles.primaryOrange, size: AppStyles.iconSizeM),
              ),
              AppStyles.spacingMHorizontal,
              // Titel
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _audioService.currentTitle ?? '',
                      style: AppStyles.subTitleStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Tippen für Details",
                      style: AppStyles.bodyStyle.copyWith(fontSize: 11, color: AppStyles.softBrown.withOpacity(0.5)),
                    ),
                  ],
                ),
              ),
              // Play/Pause Mini
              StreamBuilder<AudioServiceStatus>(
                stream: _audioService.statusStream,
                builder: (context, snapshot) {
                  final isPlaying = _audioService.status == AudioServiceStatus.playing;
                  return AnimatedPlayButton(
                    isPlaying: isPlaying,
                    size: 40,
                    showShadow: false,
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
          // Mini Progress Bar ganz unten
          AppStyles.spacingSBox,
          StreamBuilder<Duration>(
            stream: _audioService.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = _audioService.duration ?? Duration.zero;
              final progress = duration.inSeconds > 0 ? position.inSeconds / duration.inSeconds : 0.0;
              
              return Container(
                height: 3,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppStyles.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppStyles.primaryOrange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              );
            },
          ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final min = d.inMinutes.remainder(60);
    final sec = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  Widget _buildFloatingBottomNav() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35),
      child: BackdropFilter(
        filter: AppStyles.glassBlur,
        child: Container(
          decoration: BoxDecoration(
            color: AppStyles.glassBackground,
            borderRadius: BorderRadius.circular(35),
            border: Border.all(color: AppStyles.glassBorder, width: 1.5),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
                _updateUrl(index);
              },
              backgroundColor: Colors.transparent,
          selectedItemColor: AppStyles.primaryOrange,
          unselectedItemColor: AppStyles.softBrown.withOpacity(0.4),
          showSelectedLabels: true,
          showUnselectedLabels: false,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.format_list_numbered), label: 'Kurs'),
            BottomNavigationBarItem(icon: Icon(Icons.library_music_outlined), label: 'Mediathek'),
            BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'Vertiefung'),
          ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKursPfad() {
    return Navigator(
      key: _kursNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => DecorativeBlobs(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 180), // Mehr Platz für Mini-Player
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFilterRow(),
                      const SubtleDivider(),
                      ...AppDaten.wochenDaten.asMap().entries.map((entry) {
                        final index = entry.key;
                        final woche = entry.value;
                        return _buildWochenCard(context, woche, index);
                      }),
                      AppStyles.spacingSBox,
                      _buildTagDerAchtsamkeitCard(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(AppStyles.spacingL, AppStyles.spacingM, AppStyles.spacingL, AppStyles.spacingXL),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppStyles.primaryOrange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.self_improvement,
              color: AppStyles.primaryOrange,
              size: AppStyles.iconSizeXL,
            ),
          ),
          SizedBox(height: AppStyles.spacingL + AppStyles.spacingS), // 20px
          Text("Dein MBSR-Kurs", style: AppStyles.titleStyle, textAlign: TextAlign.center),
          AppStyles.spacingSBox,
          Text(
            "8-Wochen-Achtsamkeitsprogramm",
            style: AppStyles.bodyStyle.copyWith(
              color: AppStyles.textDark.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: EdgeInsets.only(left: AppStyles.spacingS, bottom: AppStyles.spacingS),
      child: Text("Wochen", style: AppStyles.headingStyle.copyWith(fontSize: 18)),
    );
  }

  Widget _buildWochenCard(BuildContext context, Map<String, dynamic> woche, int index) {
    // Einheitlicher Grünton für alle Wochen-Karten
    final cardColor = AppStyles.successGreen;
    
    return Card(
      margin: EdgeInsets.only(bottom: AppStyles.spacingM),
      shape: AppStyles.cardShape,
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: AppStyles.spacingL, vertical: AppStyles.spacingM - AppStyles.spacingS),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: cardColor.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: cardColor.withOpacity(0.3), width: 2),
          ),
          child: Center(
            child: Text(
              woche['n'], 
              style: TextStyle(
                color: cardColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        title: Text(woche['t'], style: AppStyles.subTitleStyle),
        trailing: Icon(Icons.chevron_right, color: AppStyles.borderColor, size: AppStyles.iconSizeM),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WochenDetailSeite(
              wochenNummer: "Woche ${woche['n']}",
              titel: woche['t'],
              audios: const [], 
              pdfs: List<Map<String, String>>.from(woche['pdfs']),
              wochenAufgaben: List<String>.from(woche['wochenAufgaben'] ?? []),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagDerAchtsamkeitCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: AppStyles.cardShape.copyWith(
        side: BorderSide(
          color: AppStyles.accentPink.withOpacity(0.4),
          width: 2,
        ),
      ),
      elevation: 0,
      color: AppStyles.accentPink.withOpacity(0.08),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppStyles.accentPink, AppStyles.accentCoral],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppStyles.accentPink.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.spa, color: Colors.white),
        ),
        title: Text(
          'Tag der Achtsamkeit',
          style: AppStyles.subTitleStyle.copyWith(
            color: AppStyles.accentPink,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: AppStyles.accentPink, size: AppStyles.iconSizeM),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => TagDerAchtsamkeitSeite(daten: AppDaten.tagDerAchtsamkeit)),
        ),
      ),
    );
  }
}
