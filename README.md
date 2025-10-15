# 📱 Task Manager App - Flutter

Aplicación móvil de gestión de tareas con autenticación JWT, construida con Flutter y BLoC pattern.

## 📋 Tabla de Contenidos

- [Características](#características)
- [Stack Tecnológico](#stack-tecnológico)
- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
- [Configuración](#configuración)
- [Ejecución](#ejecución)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Arquitectura](#arquitectura)
- [Funcionalidades](#funcionalidades)
- [Screenshots](#screenshots)
- [Decisiones Técnicas](#decisiones-técnicas)
- [Troubleshooting](#troubleshooting)

---

## ✨ Características

- ✅ Autenticación completa (Login/Registro)
- ✅ Persistencia de sesión (Auto-login)
- ✅ CRUD completo de tareas
- ✅ Toggle rápido de estado (completado/pendiente)
- ✅ Estadísticas de tareas
- ✅ Pull to refresh
- ✅ Validaciones de formularios
- ✅ Manejo de errores robusto
- ✅ Optimistic updates (UI rápida)
- ✅ Material Design 3
- ✅ Tema claro y oscuro
- ✅ Componentes reutilizables
- ✅ Logging completo
- ✅ Confirmaciones de acciones destructivas

---

## 🛠️ Stack Tecnológico

| Tecnología             | Versión | Uso                     |
| ---------------------- | ------- | ----------------------- |
| Flutter                | 3.35.6  | Framework móvil         |
| Dart                   | 3.9.2   | Lenguaje                |
| flutter_bloc           | ^8.1.6  | State management        |
| Dio                    | ^5.7.0  | HTTP client             |
| flutter_secure_storage | ^9.2.2  | Storage seguro (tokens) |
| shared_preferences     | ^2.3.3  | Preferencias locales    |
| equatable              | ^2.0.7  | Comparación de objetos  |
| intl                   | ^0.20.1 | Formateo de fechas      |
| logger                 | ^2.5.0  | Logging                 |

---

## 📦 Requisitos Previos

### Software Necesario

- Flutter SDK >= 3.35.6
- Dart SDK >= 3.9.2
- Android Studio / Xcode (según plataforma)
- VS Code (opcional, recomendado)

### Backend Requerido

Esta app requiere que el backend esté corriendo:

```bash
# Backend debe estar en: http://localhost:3000/api
# Ver ../task-manager-backend/README.md para instrucciones
```

### Dispositivos/Emuladores

- **iOS**: Xcode con Simulador iOS
- **Android**: Android Studio con Emulador
- **Dispositivo físico**: Conectado vía USB con modo desarrollador

---

## 🚀 Instalación

### Paso 1: Verificar Flutter

```bash
# Verificar instalación
flutter doctor

# Debería mostrar:
# [✓] Flutter
# [✓] Android toolchain (para Android)
# [✓] Xcode (para iOS)
# [✓] VS Code / Android Studio
```

### Paso 2: Clonar e Instalar Dependencias

```bash
# Clonar repositorio
git clone <repository-url>
cd task_manager_app

# Instalar dependencias
flutter pub get

# Verificar que no hay errores
flutter analyze
```

### Paso 3: Configurar Backend URL

Edita `lib/core/constants/api_constants.dart`:

```dart
// Para iOS Simulator
static const String baseUrl = 'http://localhost:3000/api';

// Para Android Emulator
static const String baseUrl = 'http://10.0.2.2:3000/api';

// Para dispositivo físico (reemplaza con tu IP)
static const String baseUrl = 'http://192.168.1.100:3000/api';
```

---

## ⚙️ Configuración

### Backend

Asegúrate que el backend esté corriendo:

```bash
cd ../task-manager-backend
npm run docker
```

Verifica que esté accesible:

```bash
curl http://localhost:3000/api/health
# Debe retornar: {"status":"ok",...}
```

---

## 🏃 Ejecución

### Listar Dispositivos Disponibles

```bash
flutter devices
```

### Ejecutar en iOS Simulator

```bash
# Abrir simulator
open -a Simulator

# Ejecutar app
flutter run

# O especificar dispositivo
flutter run -d "iPhone 16 Pro"
```

### Ejecutar en Android Emulator

```bash
# Listar emuladores
flutter emulators

# Lanzar emulador
flutter emulators --launch <emulator_id>

# Ejecutar app
flutter run
```

### Ejecutar en Dispositivo Físico

```bash
# Conectar dispositivo vía USB
# Habilitar modo desarrollador en el dispositivo

# Verificar conexión
flutter devices

# Ejecutar
flutter run
```

### Modo Release (Producción)

```bash
# Android APK
flutter build apk --release

# iOS IPA (requiere certificados)
flutter build ios --release
```

---

## 📁 Estructura del Proyecto

```
lib/
├── core/                           # Funcionalidades compartidas
│   ├── constants/
│   │   ├── api_constants.dart     # URLs y endpoints del backend
│   │   └── storage_constants.dart # Keys de almacenamiento
│   ├── models/
│   │   ├── user_model.dart        # Modelo de usuario
│   │   ├── task_model.dart        # Modelo de tarea
│   │   └── auth_response_model.dart # Respuesta de autenticación
│   ├── services/
│   │   ├── http_service.dart      # Cliente HTTP (Dio)
│   │   └── storage_service.dart   # Almacenamiento local
│   ├── theme/
│   │   └── app_theme.dart         # Temas Material Design
│   └── widgets/                   # Widgets reutilizables
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       └── loading_overlay.dart
│
├── features/                       # Features por dominio
│   ├── auth/                       # Autenticación
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       └── pages/
│   │           ├── splash_page.dart
│   │           ├── login_page.dart
│   │           └── register_page.dart
│   │
│   └── tasks/                      # Gestión de tareas
│       ├── data/
│       │   └── repositories/
│       │       └── tasks_repository.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── tasks_bloc.dart
│           │   ├── tasks_event.dart
│           │   └── tasks_state.dart
│           ├── pages/
│           │   └── home_page.dart
│           └── widgets/
│               ├── task_item.dart
│               └── task_form_dialog.dart
│
└── main.dart                       # Entry point
```

---

## 🏗️ Arquitectura

### Clean Architecture + BLoC Pattern

```
┌─────────────────────────────────────────────┐
│            Presentation Layer               │
│  (Pages, Widgets, BLoC)                     │
│  - UI Components                            │
│  - BLoC (Business Logic)                    │
│  - Events & States                          │
└────────────────┬────────────────────────────┘
                 │
┌────────────────▼────────────────────────────┐
│              Data Layer                     │
│  (Repositories)                             │
│  - AuthRepository                           │
│  - TasksRepository                          │
└────────────────┬────────────────────────────┘
                 │
┌────────────────▼────────────────────────────┐
│             Core Layer                      │
│  (Services, Models, Utils)                  │
│  - HttpService (Dio)                        │
│  - StorageService                           │
│  - Models (User, Task)                      │
│  - Widgets reutilizables                    │
└─────────────────────────────────────────────┘
```

### Flujo de Datos (BLoC)

```
User Action
    ↓
Event (TaskCreateRequested)
    ↓
BLoC.on<Event>
    ↓
Repository.createTask()
    ↓
HttpService.post()
    ↓
Backend API
    ↓
Response/Error
    ↓
emit(State) → TasksLoaded
    ↓
UI actualiza automáticamente
```

---

## 🎯 Funcionalidades

### Autenticación

#### Login

- Email y contraseña con validaciones
- Mensajes de error claros
- Loading state durante autenticación
- Auto-navegación al Home

#### Registro

- Nombre, email y contraseña
- Confirmación de contraseña
- Validaciones en tiempo real
- Registro automático de sesión

#### Persistencia

- Token JWT guardado en Secure Storage
- Auto-login al abrir la app
- Splash screen con verificación
- Logout con confirmación

### Gestión de Tareas

#### Listar Tareas

- Lista ordenada por fecha (más recientes primero)
- Indicador visual de completado (tachado)
- Pull to refresh para actualizar
- Estado vacío informativo

#### Crear Tarea

- Dialog modal con formulario
- Título (requerido)
- Descripción (opcional)
- Validaciones antes de enviar

#### Editar Tarea

- Click en tarea para abrir dialog
- Editar título, descripción y estado
- Actualización inmediata

#### Toggle Completado

- Click en checkbox
- Cambio instantáneo (optimistic update)
- Sincronización con backend

#### Eliminar Tarea

- Menu de opciones (3 puntos)
- Confirmación antes de eliminar
- Eliminación optimista

#### Estadísticas

- Card en la parte superior
- Total de tareas
- Tareas completadas
- Tareas pendientes
- Iconos con colores distintivos

---

## 📱 Screenshots

_(Agrega capturas de pantalla aquí)_

### Pantalla de Login

- Campos de email y contraseña
- Botón de inicio de sesión
- Link a registro

### Pantalla de Registro

- Formulario completo
- Validaciones visuales
- Confirmación de contraseña

### Home - Lista de Tareas

- Estadísticas en card
- Lista de tareas con checkbox
- FAB para nueva tarea
- Pull to refresh

### Dialog Crear/Editar

- Formulario modal
- Campos validados
- Botones de acción

---

## 🔐 Credenciales de Prueba

Si el backend tiene datos seed, puedes usar:

**Email:** `john.doe@example.com`  
**Password:** `password123`

O crear tu propia cuenta usando el registro.

---

## 🎨 Decisiones Técnicas

### 1. BLoC Pattern

**Decisión:** Usar BLoC para gestión de estado.

**Razones:**

- ✅ Separación clara de UI y lógica de negocio
- ✅ Testeable fácilmente
- ✅ Escalable para apps grandes
- ✅ Reactive programming
- ✅ Single source of truth

**Implementación:**

- `AuthBloc`: Gestiona autenticación y sesión
- `TasksBloc`: Gestiona CRUD de tareas
- Estados inmutables con Equatable
- Eventos para cada acción de usuario

### 2. Clean Architecture

**Decisión:** Arquitectura en capas (core/features).

**Estructura:**

- `core/`: Código compartido (services, models, widgets)
- `features/`: Módulos por dominio (auth, tasks)
- Cada feature tiene: data, presentation

**Ventajas:**

- ✅ Modularidad
- ✅ Reutilización
- ✅ Mantenibilidad
- ✅ Testability

### 3. Dio vs http

**Decisión:** Usar **Dio** para requests HTTP.

**Razones:**

- ✅ Interceptors para tokens automáticos
- ✅ Manejo de errores robusto
- ✅ Timeouts configurables
- ✅ Logging built-in
- ✅ Request/Response transformers

### 4. Secure Storage

**Decisión:** `flutter_secure_storage` para tokens JWT.

**Razones:**

- ✅ Encriptación nativa (Keychain en iOS, KeyStore en Android)
- ✅ Protección contra acceso no autorizado
- ✅ Persistente entre sesiones
- ✅ No accesible desde otras apps

### 5. Optimistic Updates

**Decisión:** UI actualiza antes de confirmar con backend.

**Beneficios:**

- ✅ UX más rápida y fluida
- ✅ App se siente instantánea
- ✅ Rollback automático en caso de error

**Implementación:**

- Toggle: UI cambia inmediatamente
- Delete: Item se elimina de lista
- Si falla: Revert + snackbar error

### 6. Material Design 3

**Decisión:** `useMaterial3: true`

**Características:**

- ✅ Nuevos componentes MD3
- ✅ Color schemes semánticos
- ✅ Elevaciones sutiles
- ✅ Bordes redondeados
- ✅ Tema claro/oscuro automático

---

## 🚀 Ejecutar la App

### 1. Levantar Backend

```bash
cd ../task-manager-backend
npm run docker
```

### 2. Ejecutar Flutter

```bash
cd task_manager_app

# iOS Simulator
flutter run -d "iPhone 16 Pro"

# Android Emulator
flutter run -d emulator-5554

# Cualquier dispositivo disponible
flutter run
```

---

## 📡 Configuración de API

### URLs según Plataforma

Edita `lib/core/constants/api_constants.dart`:

```dart
// iOS Simulator
static const String baseUrl = 'http://localhost:3000/api';

// Android Emulator
static const String baseUrl = 'http://10.0.2.2:3000/api';

// Dispositivo Físico (reemplaza con tu IP local)
static const String baseUrl = 'http://192.168.1.100:3000/api';
```

### Obtener tu IP Local

**macOS/Linux:**

```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

**Windows:**

```bash
ipconfig
```

---

## 🧪 Cómo Usar la App

### Flujo de Uso

1. **Abrir App** → Splash Screen
2. **Primera vez:**

   - Login o Registro
   - Crear cuenta nueva
   - Automáticamente va a Home

3. **Sesión activa:**

   - Auto-login automático
   - Directo a Home

4. **Home - Gestión de Tareas:**

   - Ver estadísticas (total, completadas, pendientes)
   - Ver lista de tareas
   - Click checkbox → Toggle completado
   - Click tarea → Editar
   - Menu (⋮) → Editar/Eliminar
   - FAB (+) → Crear nueva tarea
   - Pull down → Refrescar

5. **Logout:**
   - Click botón logout (AppBar)
   - Confirmar
   - Volver a Login

---

## 🎨 Componentes Reutilizables

### CustomTextField

```dart
CustomTextField(
  controller: controller,
  label: 'Email',
  prefixIcon: Icon(Icons.email),
  validator: (value) => value?.isEmpty == true ? 'Requerido' : null,
)
```

### CustomButton

```dart
CustomButton(
  text: 'Guardar',
  onPressed: () {},
  isLoading: false,
  icon: Icons.save,
)
```

### LoadingOverlay

```dart
LoadingOverlay(
  isLoading: true,
  message: 'Cargando...',
  child: YourWidget(),
)
```

---

## 🔄 Estados de la App

### AuthBloc

| Estado                | Descripción               |
| --------------------- | ------------------------- |
| `AuthInitial`         | Estado inicial            |
| `AuthLoading`         | Procesando login/registro |
| `AuthAuthenticated`   | Usuario logueado          |
| `AuthUnauthenticated` | Sin sesión activa         |
| `AuthError`           | Error en autenticación    |

### TasksBloc

| Estado                 | Descripción          |
| ---------------------- | -------------------- |
| `TasksInitial`         | Estado inicial       |
| `TasksLoading`         | Cargando tareas      |
| `TasksLoaded`          | Tareas cargadas      |
| `TaskOperationLoading` | Operación en proceso |
| `TasksError`           | Error en operación   |

---

## 📝 Scripts Útiles

```bash
# Desarrollo
flutter run                    # Ejecutar en modo debug
flutter run --release          # Ejecutar en modo release

# Análisis
flutter analyze                # Análisis estático
flutter test                   # Ejecutar tests

# Build
flutter build apk              # Build APK (Android)
flutter build ios              # Build iOS
flutter build appbundle        # Build AAB (Google Play)

# Limpieza
flutter clean                  # Limpiar build
flutter pub get                # Reinstalar dependencias

# Otros
flutter pub outdated           # Ver dependencias desactualizadas
flutter pub upgrade            # Actualizar dependencias
flutter doctor                 # Diagnóstico del entorno
```

---

## 🐛 Troubleshooting

### Error: No se puede conectar al backend

**Síntoma:** "Error de conexión" al hacer login

**Solución:**

1. Verificar que backend esté corriendo: `curl http://localhost:3000/api/health`
2. Verificar URL en `api_constants.dart` según tu plataforma
3. Para Android: Usar `http://10.0.2.2:3000/api`
4. Para dispositivo físico: Usar IP local (ambos en misma red WiFi)

### Error: "Unauthorized" constante

**Síntoma:** Token no se envía

**Solución:**

1. Verificar que el token se guarde: Ver logs en consola
2. Reiniciar app completamente (hot restart no es suficiente)
3. Limpiar storage: Desinstalar y reinstalar app

### Error: Pantalla blanca al iniciar

**Síntoma:** App se queda en blanco

**Solución:**

```bash
flutter clean
flutter pub get
flutter run
```

### Hot Reload no funciona

**Síntoma:** Cambios no se reflejan

**Solución:**

- Press `R` (Hot Restart) en lugar de `r` (Hot Reload)
- Para cambios en main(), models o servicios, requiere Hot Restart

### Errores de compilación iOS

**Síntoma:** Build falla en Xcode

**Solución:**

```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter clean
flutter run
```

---

## 🔐 Seguridad

### Implementado

- ✅ JWT Tokens en Secure Storage (Keychain/KeyStore)
- ✅ Tokens no accesibles por otras apps
- ✅ HTTPS ready (cambiar baseUrl a https)
- ✅ Validaciones de formularios
- ✅ Sanitización de inputs

### Recomendaciones para Producción

- ⚠️ Usar HTTPS en producción
- ⚠️ Implementar certificate pinning
- ⚠️ Ofuscar código (ProGuard en Android)
- ⚠️ Habilitar code obfuscation en iOS
- ⚠️ Validar certificados SSL

---

## 📊 Dependencias Principales

### Estado y Navegación

- **flutter_bloc**: State management
- **equatable**: Comparación de objetos

### Networking

- **dio**: Cliente HTTP
- **logger**: Logging

### Storage

- **flutter_secure_storage**: Tokens seguros
- **shared_preferences**: Preferencias locales

### Utils

- **intl**: Formateo de fechas y números

---

## 🧩 Convenciones de Código

Ver `AGENTS.md` para reglas del proyecto:

- ✅ Actuar como desarrollador senior
- ✅ Construir componentes reutilizables
- ✅ Usar Material Design
- ✅ Usar BLoC para gestión de estado

---

## ⭐ Funcionalidad Opcional Implementada: Filtros de Tareas

Se implementaron **filtros interactivos** para mejorar la experiencia del usuario.

### Características:

- ✅ **Filtro "Todas"** - Muestra todas las tareas (📋)
- ✅ **Filtro "Completadas"** - Solo tareas terminadas (✅ verde)
- ✅ **Filtro "Pendientes"** - Solo tareas por hacer (⏳ naranja)
- ✅ **Contadores dinámicos** - Cada chip muestra la cantidad
- ✅ **Cambio instantáneo** - Filtrado en cliente (sin backend)
- ✅ **UI Material Design** - FilterChips con iconos y colores

### ¿Por qué filtros?

- 🎯 **UX**: Ayuda a enfocarse cuando hay muchas tareas
- ⚡ **Performance**: Filtrado local (instantáneo)
- 📊 **Visual**: Colores semánticos (verde = bien, naranja = pendiente)
- 🔮 **Escalable**: Base para búsqueda y más filtros

**Ver:** `FUNCIONALIDAD_OPCIONAL.md` en la raíz del proyecto para detalles completos.

---

## 🎯 Próximas Características

- [ ] Búsqueda de tareas
- [ ] Categorías/etiquetas
- [ ] Fechas límite
- [ ] Notificaciones push
- [ ] Sincronización offline
- [ ] Modo oscuro manual (switch)
- [ ] Compartir tareas
- [ ] Exportar tareas

---

## 🧪 Testing

```bash
# Ejecutar todos los tests
flutter test

# Con coverage
flutter test --coverage

# Ver coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 📦 Build para Producción

### Android (APK)

```bash
# Release APK
flutter build apk --release

# Ubicación:
# build/app/outputs/flutter-apk/app-release.apk
```

### Android (App Bundle - Google Play)

```bash
flutter build appbundle --release

# Ubicación:
# build/app/outputs/bundle/release/app-release.aab
```

### iOS (IPA)

```bash
# Requiere certificados de Apple Developer
flutter build ios --release

# Luego abrir en Xcode para archivar
open ios/Runner.xcworkspace
```

---

## 📄 Licencia

UNLICENSED - Proyecto de prueba técnica

---

## 👨‍💻 Autor

Desarrollado como parte de una prueba técnica Full Stack Developer para Sappito Tech.

**Stack:**

- Backend: NestJS + PostgreSQL + Docker
- Frontend: Flutter + BLoC + Material Design

---

## 🙏 Recursos

- [Flutter Documentation](https://docs.flutter.dev/)
- [BLoC Library](https://bloclibrary.dev/)
- [Material Design 3](https://m3.material.io/)
- [Dio Documentation](https://pub.dev/packages/dio)

---

## 📞 Soporte

Para reportar bugs o solicitar features, por favor abre un issue en el repositorio.

---

## ✅ Checklist de Desarrollo

- [x] Proyecto Flutter creado
- [x] Dependencias instaladas
- [x] Arquitectura definida
- [x] Autenticación implementada
- [x] Persistencia de sesión
- [x] CRUD de tareas completo
- [x] UI Material Design
- [x] Validaciones de formularios
- [x] Manejo de errores
- [x] Loading states
- [x] Componentes reutilizables
- [x] Integración con backend
- [x] Optimistic updates
- [x] Pull to refresh
- [ ] Tests unitarios
- [ ] Tests de integración
- [ ] Screenshots
- [ ] Deploy APK/IPA

---

## 🎊 ¡Listo para Usar!

La aplicación está completamente funcional y lista para ser probada.

**Ejecuta:**

```bash
flutter run
```

**Y disfruta de la app!** 🚀
