# CineLog

Aplicación móvil para registrar y gestionar películas vistas, en progreso y pendientes. Desarrollada con Flutter como proyecto del curso de Programación Móvil.

## Funcionalidades

- Registro e inicio de sesión con Supabase Auth
- Listado de películas populares desde TMDB
- Búsqueda de películas
- Estado por película: visto, viendo, pendiente
- Rating de 1 a 5 estrellas por película
- Reseñas de texto por película
- Perfil de usuario con estadísticas
- Foto de perfil con upload a Supabase Storage

## Arquitectura

```
lib/
├── cubits/         # Estado (BLoC/Cubit)
├── repositories/   # Capa de acceso a datos
├── services/       # Clientes externos (TMDB)
├── models/         # Modelos de datos
├── views/          # Pantallas
├── widgets/        # Componentes reutilizables
└── router/         # Navegación (GoRouter)
```

## Stack

- Flutter + Dart
- Supabase (Auth, Database, Storage)
- TMDB API
- flutter_bloc
- go_router
- dio

## Configuración

1. Clona el repositorio
2. Copia `lib/env.example.dart` a `lib/env.dart`
3. Llena las credenciales en `lib/env.dart`
4. Ejecuta `flutter pub get`
5. Ejecuta `flutter run`

## Variables de entorno

Crea `lib/env.dart` basándote en `lib/env.example.dart`:

```dart
const supabaseUrl = 'TU_SUPABASE_URL';
const supabaseAnonKey = 'TU_SUPABASE_ANON_KEY';
const tmdbBearerToken = 'TU_TMDB_BEARER_TOKEN';
```
