/// Zentrale App-Konfiguration
/// 
/// Enthält alle sensiblen Daten und Endpoints
/// In Production sollten diese Werte aus Environment-Variablen geladen werden
class AppConfig {
  // Appwrite Configuration
  static const String appwriteEndpoint = 'https://fra.cloud.appwrite.io/v1';
  static const String appwriteProjectId = '696befd00018180d10ff';
  
  // Database IDs (werden nach Appwrite-Setup ausgefüllt)
  static const String databaseId = 'mbsr_database'; // TODO: Nach Erstellung in Appwrite anpassen
  
  // Collection IDs
  static const String usersCollectionId = 'users';
  static const String kursDatenCollectionId = 'kurs_daten';
  
  // Storage Bucket IDs
  static const String contentBucketId = 'mbsr_content';
  static const String audiosBucketId = 'mbsr_content';
  static const String pdfsBucketId = 'mbsr_content';
  
  // App-spezifische Konstanten
  static const String appName = 'MBSR Achtsamkeitstraining';
  static const String mbsrRole = 'mbsr';
  
  // Verhindere Instanziierung
  AppConfig._();
}
