# MediConnect

MediConnect es una aplicación móvil desarrollada en Flutter que permite la gestión y autenticación de usuarios con roles de doctor y paciente.

## Tabla de Contenidos

- [MediConnect](#mediconnect)
  - [Tabla de Contenidos](#tabla-de-contenidos)
  - [Requisitos Previos](#requisitos-previos)
  - [Instalación](#instalación)
  - [Ejecución Local](#ejecución-local)
    - [Android/iOS](#androidios)
    - [Web](#web)
  - [Estructura del Proyecto](#estructura-del-proyecto)
  - [Comandos Útiles](#comandos-útiles)
  - [Solución de Problemas](#solución-de-problemas)
  - [Licencia](#licencia)

---

## Requisitos Previos

Antes de comenzar, asegúrate de tener instalado lo siguiente:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versión recomendada: 3.x o superior)
- [Dart SDK](https://dart.dev/get-dart) (normalmente incluido con Flutter)
- Un editor de código como [Visual Studio Code](https://code.visualstudio.com/) o [Android Studio](https://developer.android.com/studio)
- [Git](https://git-scm.com/) para clonar el repositorio
- Emulador de Android/iOS o un dispositivo físico para pruebas

## Instalación

1. **Clona el repositorio:**

   ```sh
   git clone https://github.com/tu-usuario/medi_connect.git
   cd medi_connect
   ```

2. **Instala las dependencias:**

   ```sh
   flutter pub get
   ```

3. **(Opcional) Configura un emulador o conecta tu dispositivo físico.**

## Ejecución Local

### Android/iOS

1. **Ejecuta la aplicación:**

   ```sh
   flutter run
   ```

   Esto detectará automáticamente un emulador o dispositivo conectado.

2. **Selecciona el dispositivo** en caso de tener varios disponibles.

### Web

1. **Ejecuta en modo web:**

   ```sh
   flutter run -d chrome
   ```

   Esto abrirá la aplicación en tu navegador predeterminado.

## Estructura del Proyecto

```
lib/
  cubits/           # Lógica de estado (BLoC/Cubit)
  controllers/      # Controladores de lógica de negocio
  models/           # Modelos de datos
  functions/        # Funciones auxiliares
  screens/          # Pantallas principales (UI)
  widgets/          # Widgets reutilizables
  constants/        # Colores, estilos, etc.
  main.dart         # Punto de entrada de la app
assets/             # Imágenes y recursos estáticos
android/            # Proyecto nativo Android
ios/                # Proyecto nativo iOS
web/                # Configuración para web
```

## Comandos Útiles

- **Actualizar dependencias:**  
  ```sh
  flutter pub upgrade
  ```

- **Analizar el código:**  
  ```sh
  flutter analyze
  ```

- **Ejecutar pruebas:**  
  ```sh
  flutter test
  ```

- **Construir APK:**  
  ```sh
  flutter build apk --release
  ```

## Solución de Problemas

- Si tienes problemas con dependencias, ejecuta:
  ```sh
  flutter clean
  flutter pub get
  ```

- Si el emulador no aparece, asegúrate de que esté iniciado o conecta un dispositivo físico.

- Consulta la [documentación oficial de Flutter](https://docs.flutter.dev/) para más detalles.

## Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo