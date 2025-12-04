/// Configuration file for API environment
///
/// Change these values to switch between local and production environments
class AppConfig {
  // ⚙️ CONFIGURACIÓN PRINCIPAL
  // Cambia esto para cambiar entre local y producción
  static const Environment currentEnvironment = Environment.production;

  // 🔧 URL del backend según el entorno
  static String get apiBaseUrl {
    switch (currentEnvironment) {
      case Environment.local:
        return 'http://10.0.2.2:8000/api/v1'; // Emulador Android
      case Environment.localIOS:
        return 'http://localhost:8000/api/v1'; // Simulador iOS
      case Environment.localDevice:
        return 'http://192.168.1.100:8000/api/v1'; // Cambia la IP por la tuya
      case Environment.production:
        return 'https://profile-service-nango-fas.homeservergv.com/api/v1';
    }
  }

  // 📊 Configuración de debug
  static bool get isDebug => currentEnvironment != Environment.production;

  // 📝 Logs
  static bool get enableLogs => isDebug;
}

/// Environments disponibles
enum Environment {
  local,        // Desarrollo local en emulador Android
  localIOS,     // Desarrollo local en simulador iOS
  localDevice,  // Desarrollo local en dispositivo físico
  production,   // Producción
}

