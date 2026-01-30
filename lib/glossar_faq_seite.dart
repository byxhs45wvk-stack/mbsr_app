import 'package:flutter/material.dart';
import 'core/app_styles.dart';
import 'widgets/decorative_blobs.dart';

class GlossarFaqSeite extends StatelessWidget {
  const GlossarFaqSeite({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppStyles.bgColor,
        appBar: AppBar(
          title: Text(
            "Wissen & Hilfe",
            style: AppStyles.headingStyle.copyWith(fontSize: 18),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppStyles.softBrown, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelPadding: EdgeInsets.symmetric(horizontal: AppStyles.spacingM),
            labelColor: AppStyles.textDark,
          unselectedLabelColor: AppStyles.textDark.withOpacity(0.8),
          indicatorColor: AppStyles.accentCyan,
          indicatorWeight: 4,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: AppStyles.subTitleStyle.copyWith(fontWeight: AppStyles.fontWeightBold),
            tabs: const [
              Tab(text: "Glossar"),
              Tab(text: "Häufige Fragen"),
            ],
          ),
        ),
        body: DecorativeBlobs(
          child: TabBarView(
            children: [
              _buildGlossarList(context),
              _buildFaqList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlossarList(BuildContext context) {
    final terms = [
      {
        'term': 'Achtsamkeit (Mindfulness)',
        'def': 'Bewusstsein, das durch absichtsvolles Aufmerken im gegenwärtigen Moment entsteht, nicht-wertend, im Dienst von Weisheit, Selbstverständnis, Freundlichkeit und Mitgefühl.',
      },
      {
        'term': 'Operationale Definition',
        'def': 'Praktikable Arbeitsdefinition, die klärt, was im Kurs mit Achtsamkeit gemeint ist (siehe Mindfulness-Definition im Curriculum).',
      },
      {
        'term': 'Anker (Anchor)',
        'def': 'Gewählter Aufmerksamkeitsfokus (z. B. Atem, Körperkontaktpunkte, Geräusche, visueller Punkt), zu dem man immer wieder zurückkehrt.',
      },
      {
        'term': 'Fokussierte Aufmerksamkeit (Focused Attention)',
        'def': 'Praxisform, bei der Aufmerksamkeit wiederholt auf einen Anker ausgerichtet und sanft zurückgeführt wird.',
      },
      {
        'term': 'Körper-Scan (Body Scan)',
        'def': 'Formale Praxis, bei der Aufmerksamkeit systematisch durch Körperregionen wandert; in Woche 1 zentral und zunächst ggf. verkürzt eingeführt.',
      },
      {
        'term': 'Formale Praxis',
        'def': 'Geplante Übungszeiten (z. B. Body Scan, Sitzmeditation, Gehmeditation, achtsame Bewegungen).',
      },
      {
        'term': 'Informelle Praxis',
        'def': 'Alltagsmomente als Übungsfeld (z. B. eine Tätigkeit pro Tag mit voller Präsenz, inkl. Bemerken von Abschweifen).',
      },
      {
        'term': 'Achtsames Essen / Essmeditation (Eating Meditation)',
        'def': 'Übung zur Wahrnehmungsdifferenzierung und zum Einstieg in Autopilot vs. Gewahrsein.',
      },
      {
        'term': 'Achtsame Bewegung / Yoga (Mindful Movement / Hatha Yoga)',
        'def': 'Bewegungssequenzen als formale Praxis, mit Anpassungen (sitzend/stehend/liegend) und sorgfältigem Aufbau zur Vermeidung von Verletzungen.',
      },
      {
        'term': 'Stehende Sequenz (Standing Yoga Sequence)',
        'def': 'Lässt sich über mehrere Termine stückweise aufbauen, damit Teilnehmende die Posen schrittweise kennenlernen.',
      },
      {
        'term': 'Einladende Sprache (Invitational Language)',
        'def': 'Anleitungsstil, der Wahlfreiheit und Selbstwirksamkeit betont (z. B. "Sie könnten ..., wenn es für Sie stimmig ist ..."), statt Druck oder Normierung.',
      },
      {
        'term': 'Selbstwirksamkeit (Agency)',
        'def': 'Erfahrung, selbst regulierend entscheiden zu können (z. B. Intensität, Haltung, Pausieren, Abwandeln).',
      },
      {
        'term': 'Container (Holding Environment)',
        'def': 'Der klare Kursrahmen (Zeit, Vereinbarungen, Sicherheit, Haltung der Lehrenden), der Übung und Austausch trägt.',
      },
      {
        'term': 'Vereinbarungen (Agreements for Participation)',
        'def': 'Gemeinsame Absprachen zu Praxis, Vertraulichkeit, respektvoller Kommunikation etc.',
      },
      {
        'term': 'Ankommen (Opening Practice)',
        'def': 'Kurze Praxis (oft 5-10 Min.) zu Beginn, als Übergang vom Doing ins Being.',
      },
      {
        'term': 'Wandernder Geist (Wandering Mind)',
        'def': 'Normales Abschweifen der Aufmerksamkeit; wird explizit als universelle Erfahrung aufgegriffen.',
      },
      {
        'term': 'Freundlichkeit (Friendliness)',
        'def': 'Grundhaltung, mit der auch Schwieriges (Widerstand, Langeweile, Unruhe) betrachtet wird.',
      },
      {
        'term': 'Mitgefühl (Compassion)',
        'def': 'Bereits in der Mindfulness-Definition als Ziel- oder Wirkraum benannt, nicht als Zusatz, sondern als Teil der Ausrichtung.',
      },
      {
        'term': 'Tun-Modus / Sein-Modus (Doing Mode / Being Mode)',
        'def': 'Wechsel von funktionalem Tun (Problemlösen) hin zu gegenwärtigem Sein (Gewahrsein) - im Kurs wiederholt erfahrungsbasiert eingeübt.',
      },
      {
        'term': 'Wahrnehmung (Perception)',
        'def': 'Leitmotiv von Termin 2: Wahrnehmungsmuster beeinflussen Stress, Entscheidungen und Praxisbindung.',
      },
      {
        'term': 'Kreatives Antworten (Creative Responding)',
        'def': 'Alternative zu Autopilot-Reaktion: innehalten, wahrnehmen, Wahlmöglichkeiten erkennen.',
      },
      {
        'term': '9-Dots / 9-Punkte-Übung (Nine-Dots Puzzle)',
        'def': 'Erfahrungsübung zu Denkrahmen, Begrenzungen von Wahrnehmung und gewohnheitsmäßigen Lösungsversuchen; in manchen Kontexten ggf. weniger passend.',
      },
      {
        'term': 'Dialog (Small/Large Group Dialogue)',
        'def': 'Praxisbezogener Austausch in Kleingruppe oder Plenum, inklusive achtsam sprechen und zuhören als Praxis.',
      },
      {
        'term': 'Erforschender Dialog (Inquiry)',
        'def': 'Lehrende unterstützen Teilnehmende, direkte Erfahrung (Körper, Gefühle, Gedanken) zu erkunden statt zu interpretieren oder zu bewerten.',
      },
      {
        'term': 'Unbehagen (Discomfort)',
        'def': 'Discomfort wird als oft hilfreicherer Begriff als "pain" erwähnt (Konnotationen, Spielraum).',
      },
      {
        'term': 'Widerstand / Resistenz',
        'def': 'Erwartbare Reaktion in Praxisprozessen; wird normalisiert und als Untersuchungsgegenstand genutzt.',
      },
      {
        'term': 'Schläfrigkeit / Müdigkeit',
        'def': 'Typische Praxisreaktion, wird im Austausch aufgegriffen und nicht als Fehler gerahmt.',
      },
      {
        'term': 'Stressoren / Belastungen (Stressors)',
        'def': 'Lebensumstände, die im Orientierungsgespräch mit betrachtet werden (Passung, Ressourcen, Timing).',
      },
      {
        'term': 'Orientierungsgespräch (Orientation & Individual Meeting)',
        'def': 'Verpflichtende Orientierung inkl. Einzelgespräch als erfahrungsbasierte Klärung von Kursanforderungen, Passung und Praxisplanung.',
      },
      {
        'term': 'Kontraindikation (counter-indicated)',
        'def': 'Fälle, in denen MBSR zu einem Zeitpunkt nicht passend ist; dann Empfehlung alternativer Ressourcen oder Behandlungen.',
      },
      {
        'term': 'Kompetenzrahmen (Scope of Practice)',
        'def': 'Lehrende bleiben im eigenen Kompetenzbereich und verweisen bei klinischen Themen an qualifizierte Fachpersonen.',
      },
      {
        'term': 'Volles Spektrum (Full Catastrophe)',
        'def': 'Kabat-Zinn-Rahmung: das ganze Spektrum menschlicher Erfahrung (angenehm/unangenehm/neutral) wird als Übungsfeld verstanden.',
      },
      {
        'term': 'Tag der Achtsamkeit (All-Day Session)',
        'def': 'Längerer Übungstag mit Kontinuität von Gewahrsein über formale Praxis und Übergänge hinweg.',
      },
      {
        'term': 'Kontinuität von Gewahrsein',
        'def': 'Leitprinzip des Übungstags: möglichst nahtlose Aufmerksamkeit über Aktivitäten und Übergänge hinweg.',
      },
      {
        'term': 'Gehmeditation (Mindful Walking)',
        'def': 'Formale Praxis, häufig im All-Day-Kontext und/oder als Variation zur Sitzpraxis integriert.',
      },
      {
        'term': 'Berg-/See-Meditation (Mountain/Lake Meditation)',
        'def': 'Metaphern- oder Vorstellungspraktiken, die am All-Day-Tag als mögliche Ergänzungen genannt werden.',
      },
      {
        'term': 'Loving-Kindness (Metta)',
        'def': 'Wird als besonders wichtig für den All-Day-Tag hervorgehoben.',
      },
      {
        'term': 'Online vs. Präsenz',
        'def': 'Online-MBSR ist kompatibel, bringt aber eigene Herausforderungen; 2025 wird keine definitive Vergleichsforschung zwischen Formaten konstatiert.',
      },
      {
        'term': 'Verkörperung (Embodiment)',
        'def': 'Qualität des Lehrens aus Praxis heraus (nicht mechanisch), als zentraler Wirkfaktor der Kursleitung betont.',
      },
      {
        'term': 'Autopilot',
        'def': 'Der Zustand, in dem wir Dinge automatisch tun, ohne uns dessen bewusst zu sein.',
      },
      {
        'term': 'Anfängergeist',
        'def': 'Eine Haltung der Offenheit, Dinge so zu sehen, als wäre es das erste Mal.',
      },
      {
        'term': 'Reaktionsmuster',
        'def': 'Gewohnheitsmäßige, oft unbewusste Reaktionen auf Stress oder schwierige Situationen.',
      },
    ];
    final sortedTerms = [...terms]
      ..sort((a, b) => (a['term'] ?? '').compareTo(b['term'] ?? ''));

    return ListView.separated(
      padding: AppStyles.listPadding,
      itemCount: sortedTerms.length,
      separatorBuilder: (context, index) => AppStyles.spacingMBox,
      itemBuilder: (context, index) {
        final item = sortedTerms[index];
        return _buildExpansionCard(
          context: context,
          title: item['term']!,
          body: item['def']!,
        );
      },
    );
  }

  Widget _buildFaqList(BuildContext context) {
    final faqs = [
      {
        'q': 'Was ist in diesem Kurs mit Achtsamkeit gemeint?',
        'a': 'Achtsamkeit meint ein absichtsvolles, gegenwärtiges und nicht-wertendes Gewahrsein – ausgerichtet auf Selbstverständnis, Weisheit, Freundlichkeit und Mitgefühl.',
      },
      {
        'q': 'Wie viel Zeit brauche ich pro Woche für die Praxis?',
        'a': 'Es gibt formale Übungen (z. B. Body Scan, Sitzmeditation, achtsame Bewegung) und informelle Praxis im Alltag; die Regelmäßigkeit ist wichtiger als perfekt.',
      },
      {
        'q': 'Was, wenn ich beim Üben dauernd abschweife?',
        'a': 'Das ist normal (wandering mind). Entscheidend ist das Wieder-Bemerken und sanfte Zurückkehren – genau das trainiert Achtsamkeit.',
      },
      {
        'q': 'Was mache ich bei Unruhe, starken Gefühlen oder Überforderung in der Praxis?',
        'a': 'Du kannst Intensität reduzieren, die Übung pausieren und dich melden; Kursleitende ermutigen, auf eigene Signale zu hören und Optionen zu nutzen.',
      },
      {
        'q': 'Was ist das Orientierungsgespräch – und warum ist es verpflichtend?',
        'a': 'Es klärt erfahrungsbasiert Kursanforderungen, Passung, Ressourcen und Praxisplanung und unterstützt ein sicheres Lernsetting.',
      },
      {
        'q': 'Kann es Gründe geben, warum ich MBSR gerade nicht machen sollte?',
        'a': 'Ja, es gibt Situationen, in denen der Kurs zu viel sein kann; dann werden Alternativen und Unterstützungsangebote empfohlen.',
      },
      {
        'q': 'Was bedeutet einladende Sprache in Anleitungen?',
        'a': 'Du bekommst Vorschläge statt Anweisungen; Wahlmöglichkeiten und Selbstbestimmung stehen im Vordergrund (z. B. anpassen, stoppen, variieren).',
      },
      {
        'q': 'Gibt es Yoga – auch wenn ich körperliche Einschränkungen habe?',
        'a': 'Ja. Bewegungen werden schrittweise eingeführt und können sitzend/stehend/liegend angepasst werden; Sicherheit hat Priorität.',
      },
      {
        'q': 'Warum sprechen wir über Wahrnehmung (Perception) und Denkmuster?',
        'a': 'Weil Wahrnehmungsgewohnheiten Stressreaktionen und Handlungen prägen; im Kurs wird das erfahrungsbasiert (u. a. über Übungen wie 9-Dots) sichtbar gemacht.',
      },
      {
        'q': 'Was ist der Zweck von Kleingruppen- und Plenumsdialogen?',
        'a': 'Austausch hilft, Erfahrungen zu normalisieren und zu differenzieren; zugleich ist achtsames Sprechen und Zuhören selbst Praxis.',
      },
      {
        'q': 'Was ist der Tag der Achtsamkeit (All-Day) – und warum ist er so wichtig?',
        'a': 'Ein längerer Übungstag, der Kontinuität von Gewahrsein über formale Praxis, Übergänge und Alltagsmomente hinweg stärkt.',
      },
      {
        'q': 'Welche Übungen kommen am All-Day typischerweise vor?',
        'a': 'Sitzpraxis, Body Scan, Gehmeditation und achtsame Bewegung; ergänzt u. a. durch Berg-/See-Meditation und Loving-Kindness.',
      },
      {
        'q': 'Online oder in Präsenz – macht das einen Unterschied?',
        'a': 'Beide Formate sind kompatibel mit den Kernzielen; online braucht zusätzliche didaktische/technische Kompetenz, und 2025 wird noch keine definitive Vergleichsforschung berichtet.',
      },
      {
        'q': 'Was ist die Rolle der Kursleitung?',
        'a': 'MBSR lebt davon, dass Lehrende die Praxis verkörpern und aus eigener Erfahrung unterrichten – nicht kochbuchartig oder rein didaktisch.',
      },
      {
        'q': 'Was, wenn ich bei psychischen Themen Beratung brauche?',
        'a': 'Lehrende bleiben im Kompetenzrahmen und verweisen klinische Beratung an qualifizierte, lizenzierte Fachpersonen; bei Bedarf wird das aktiv unterstützt.',
      },
    ];

    return ListView.separated(
      padding: AppStyles.listPadding,
      itemCount: faqs.length,
      separatorBuilder: (context, index) => AppStyles.spacingMBox,
      itemBuilder: (context, index) {
        final item = faqs[index];
        return _buildExpansionCard(
          context: context,
          title: item['q']!,
          body: item['a']!,
        );
      },
    );
  }

  Widget _buildExpansionCard({
    required BuildContext context,
    required String title,
    required String body,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyles.successGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        border: Border.all(color: AppStyles.successGreen.withOpacity(0.2)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(
            horizontal: AppStyles.spacingL,
            vertical: AppStyles.spacingS,
          ),
          childrenPadding: EdgeInsets.fromLTRB(
            AppStyles.spacingL,
            0,
            AppStyles.spacingL,
            AppStyles.spacingL,
          ),
          iconColor: AppStyles.textDark,
          collapsedIconColor: AppStyles.textDark.withOpacity(0.9),
          title: Text(
            title,
            style: AppStyles.subTitleStyle,
          ),
          children: [
            Text(
              body,
              style: AppStyles.bodyStyle,
            ),
          ],
        ),
      ),
    );
  }
}
