import 'package:flutter/material.dart';
import 'wochen_detail_seite.dart';
import 'vertiefung_seite.dart';
import 'profil_seite.dart';
import 'tag_der_achtsamkeit_seite.dart';
import 'app_daten.dart';
import 'mediathek_seite.dart';
import 'web_utils.dart' show setRoute;
import 'services/connectivity_service.dart';
import 'core/app_styles.dart';

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
  
  // Navigator Key für den Kurs-Tab (um BottomNav sichtbar zu halten)
  final GlobalKey<NavigatorState> _kursNavigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    // URL beim Start synchronisieren
    _updateUrl(_currentIndex);
  }

  void _updateUrl(int index) {
    switch (index) {
      case 0:
        setRoute('/home');
        break;
      case 1:
        setRoute('/mediathek');
        break;
      case 2:
        setRoute('/vertiefung');
        break;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
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
        title: Text(
          "MBSR Kurs",
          style: AppStyles.headingStyle,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person_outline,
              color: AppStyles.softBrown,
              size: 28,
            ),
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
              // Offline-Banner (nur wenn offline)
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
                        Icon(
                          Icons.wifi_off,
                          size: 18,
                          color: Colors.orange.shade800,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Keine Internetverbindung',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.orange.shade900,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              // Hauptinhalt
              Expanded(child: pages[_currentIndex]),
            ],
          ),
          // Floating Bottom Navigation Bar
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

  Widget _buildFloatingBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
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
          backgroundColor: Colors.white,
          selectedItemColor: AppStyles.primaryOrange,
          unselectedItemColor: AppStyles.softBrown.withOpacity(0.4),
          showSelectedLabels: true,
          showUnselectedLabels: false,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_numbered),
              label: 'Kurs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music_outlined),
              label: 'Mediathek',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.self_improvement),
              label: 'Vertiefung',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKursPfad() {
    return Navigator(
      key: _kursNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => ListView(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 100), // Platz für Floating Nav
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilterRow(),
                    const SizedBox(height: 16),
                    ...AppDaten.wochenDaten.map((w) => _buildWochenCard(context, w)),
                    const SizedBox(height: 8),
                    _buildTagDerAchtsamkeitCard(context),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        children: [
          const Icon(Icons.self_improvement, color: AppStyles.primaryOrange, size: 48),
          const SizedBox(height: 16),
          Text(
            "Dein MBSR-Kurs",
            style: AppStyles.titleStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "8-Wochen-Achtsamkeitsprogramm",
            style: AppStyles.bodyStyle.copyWith(color: AppStyles.softBrown.withOpacity(0.7)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        "Wochen",
        style: AppStyles.headingStyle.copyWith(fontSize: 18),
      ),
    );
  }

  Widget _buildWochenCard(BuildContext context, Map<String, dynamic> woche) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: AppStyles.cardShape,
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppStyles.sageGreen.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              woche['n'], 
              style: const TextStyle(
                color: AppStyles.sageGreen, 
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        title: Text(
          woche['t'],
          style: AppStyles.subTitleStyle,
        ),
        trailing: const Icon(Icons.chevron_right, color: AppStyles.borderColor),
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
        side: const BorderSide(color: AppStyles.primaryOrange, width: 1.5),
      ),
      elevation: 0,
      color: AppStyles.primaryOrange.withOpacity(0.05),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppStyles.primaryOrange,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.spa, color: Colors.white),
        ),
        title: Text(
          'Tag der Achtsamkeit',
          style: AppStyles.subTitleStyle.copyWith(color: AppStyles.primaryOrange),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppStyles.primaryOrange),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                TagDerAchtsamkeitSeite(daten: AppDaten.tagDerAchtsamkeit),
          ),
        ),
      ),
    );
  }
}
