import 'package:flutter/material.dart';
import 'nutzungs_tracker.dart';
import 'constants/app_texts.dart';
import 'core/app_styles.dart';

class StatistikenSeite extends StatefulWidget {
  const StatistikenSeite({super.key});

  @override
  State<StatistikenSeite> createState() => _StatistikenSeiteState();
}

class _StatistikenSeiteState extends State<StatistikenSeite> {
  Map<String, dynamic> _statistiken = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistiken();
  }

  Future<void> _loadStatistiken() async {
    setState(() => _isLoading = true);
    final stats = await NutzungsTracker.getStatistiken();
    if (mounted) {
      setState(() {
        _statistiken = stats;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text(
          "Deine Praxis",
          style: AppStyles.headingStyle.copyWith(fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppStyles.softBrown, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppStyles.softBrown),
            onPressed: () => _showTrackingInfo(context),
            tooltip: 'Über deine Statistiken',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppStyles.primaryOrange),
            )
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Datenschutz-Hinweis (prominent)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppStyles.sageGreen.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppStyles.sageGreen.withOpacity(0.1),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        color: AppStyles.sageGreen,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Deine Statistiken sind privat und nur für dich sichtbar. Sie werden lokal gespeichert.',
                          style: AppStyles.bodyStyle.copyWith(
                            fontSize: 13,
                            color: AppStyles.sageGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Streak-Anzeige
                if ((_statistiken['streak'] ?? 0) > 0)
                  _buildStreakCard(streak: _statistiken['streak'] ?? 0),
                
                const SizedBox(height: 24),
                
                // Wochenübersicht
                _buildWochenUebersicht(wochenDaten: _statistiken['wochenDaten'] ?? {}),
                
                const SizedBox(height: 24),
                
                // Stat-Karten Grid-like
                _buildStatCard(
                  icon: Icons.timer_outlined,
                  title: "Gehörte Minuten",
                  value: "${_statistiken['gesamtMinuten'] ?? 0}",
                  subtitle: "Insgesamt",
                  color: AppStyles.sageGreen,
                ),
                const SizedBox(height: 16),
                
                if ((_statistiken['durchschnittsSitzung'] ?? 0) > 0)
                  _buildStatCard(
                    icon: Icons.access_time,
                    title: "Ø Sitzungslänge",
                    value: "${_statistiken['durchschnittsSitzung']} Min",
                    subtitle: "Durchschnitt",
                    color: AppStyles.primaryOrange,
                  ),
                
                const SizedBox(height: 16),
                
                _buildStatCard(
                  icon: Icons.library_music_outlined,
                  title: "Gehörte Übungen",
                  value: "${_statistiken['anzahlGehoerte'] ?? 0}",
                  subtitle: "Verschiedene Audios",
                  color: AppStyles.softBrown,
                ),
                const SizedBox(height: 16),
                
                if (_statistiken['lieblingsUebung'] != null)
                  _buildStatCard(
                    icon: Icons.favorite_outline,
                    title: "Lieblingsübung",
                    value: _statistiken['lieblingsUebung'],
                    subtitle: "Häufigste Wahl",
                    color: AppStyles.primaryOrange,
                  ),
                
                const SizedBox(height: 24),
                
                // Übungsverteilung
                if ((_statistiken['uebungsVerteilung'] as Map?)?.isNotEmpty ?? false)
                  _buildUebungsVerteilung(
                    verteilung: _statistiken['uebungsVerteilung'] as Map<String, int>,
                  ),
                
                const SizedBox(height: 40),
                
                // Motivations-Text
                _buildMotivationBox(),
                const SizedBox(height: 100), // Platz für Floating Nav
              ],
            ),
    );
  }

  Widget _buildStreakCard({required int streak}) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppStyles.primaryOrange,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppStyles.primaryOrange.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_fire_department, color: Colors.white, size: 36),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Deine Serie', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('$streak ${streak == 1 ? "Tag" : "Tage"}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWochenUebersicht({required Map<String, int> wochenDaten}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Diese Woche', style: AppStyles.subTitleStyle),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'].map((day) {
                final minuten = wochenDaten[day] ?? 0;
                final hasActivity = minuten > 0;
                final isToday = _isToday(day);
                
                return Column(
                  children: [
                    Text(day, style: AppStyles.bodyStyle.copyWith(
                      fontSize: 12, 
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday ? AppStyles.primaryOrange : AppStyles.softBrown.withOpacity(0.5),
                    )),
                    const SizedBox(height: 12),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: hasActivity ? AppStyles.sageGreen : AppStyles.bgColor,
                        shape: BoxShape.circle,
                        border: isToday ? Border.all(color: AppStyles.primaryOrange, width: 2) : null,
                      ),
                      child: hasActivity ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({required IconData icon, required String title, required String value, required String subtitle, required Color color}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppStyles.bodyStyle.copyWith(fontSize: 13, color: AppStyles.softBrown.withOpacity(0.6))),
                  const SizedBox(height: 4),
                  Text(value, style: AppStyles.subTitleStyle.copyWith(fontSize: 18, color: color)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUebungsVerteilung({required Map<String, int> verteilung}) {
    final sortedEntries = verteilung.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Übungsverteilung', style: AppStyles.subTitleStyle),
            const SizedBox(height: 24),
            ...sortedEntries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(entry.key, style: AppStyles.bodyStyle.copyWith(fontWeight: FontWeight.w500))),
                      Text('${entry.value}%', style: AppStyles.bodyStyle.copyWith(fontWeight: FontWeight.bold, color: AppStyles.sageGreen)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: entry.value / 100,
                      minHeight: 8,
                      backgroundColor: AppStyles.bgColor,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppStyles.sageGreen),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationBox() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppStyles.primaryOrange.withOpacity(0.1), width: 1.5),
      ),
      child: Column(
        children: [
          const Icon(Icons.spa_outlined, size: 40, color: AppStyles.sageGreen),
          const SizedBox(height: 16),
          Text("Jeder Moment zählt", style: AppStyles.headingStyle.copyWith(fontSize: 18)),
          const SizedBox(height: 12),
          Text(
            "Deine tägliche Praxis ist ein Geschenk an dich selbst. Bleib dran, auch wenn es nur wenige Minuten sind.",
            textAlign: TextAlign.center,
            style: AppStyles.bodyStyle.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }

  void _showTrackingInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppTexts.trackingInfoTitle, style: AppStyles.headingStyle.copyWith(fontSize: 20)),
        content: Text(AppTexts.trackingInfoText, style: AppStyles.bodyStyle),
        backgroundColor: AppStyles.bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Verstanden", style: AppStyles.bodyStyle.copyWith(fontWeight: FontWeight.bold, color: AppStyles.primaryOrange)),
          ),
        ],
      ),
    );
  }

  bool _isToday(String dayName) {
    final now = DateTime.now();
    final todayName = NutzungsTracker.getDayName(now.weekday);
    return dayName == todayName;
  }
}
