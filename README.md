#  Taller Personal - Gestión de Mantenimiento de Vehículos (TFG)

Bienvenido a **Taller Personal**, una aplicación móvil desarrollada con el framework Flutter, diseñada específicamente para llevar un control exhaustivo del mantenimiento preventivo de todo tipo de vehículos, basándose en el kilometraje recorrido por los mismos.

Este proyecto ha sido desarrollado minuciosamente como Trabajo de Fin de Grado (TFG) para el Ciclo Formativo de Grado Superior en Desarrollo de Aplicaciones Multiplataforma (DAM).

---

## Características Principales

La aplicación ha sido concebida con el objetivo de ofrecer una experiencia Premium y simplificada al usuario final. Entre sus funciones clave destacan:

- **Autenticación Segura (Supabase Auth)**: Sistema de registro e inicio de sesión moderno y protegido, garantizando que cada conductor únicamente pueda acceder y gestionar sus propios vehículos.
- **Gestión Avanzada de Múltiples Vehículos**: Permite registrar uno o varios vehículos, almacenando datos vitales como la marca, el modelo, el año de fabricación, y el kilometraje actualizado en todo momento.
- **Componentes Personalizables**: El mantenimiento no es genérico; la app permite hacer un seguimiento individual pormenorizado de las distintas piezas y líquidos del vehículo (por ejemplo: aceite del motor, filtros de habitáculo, pastillas de freno, neumáticos, correas de distribución, etc.).
- **Semáforo de Estado Inteligente (Smart Status)**: Integra un algoritmo visual tremendamente útil que emplea un sistema de colores tipo semáforo (Verde / Amarillo / Rojo) que avisa al conductor de manera intuitiva basándose en el cálculo automático del desgaste de las piezas frente a su intervalo de cambio recomendado.
- **Historial Completo de Mantenimiento**: Registro cronológico inmutable de todas y cada una de las intervenciones mecánicas o revisiones que ha sufrido el vehículo.
- **Estadísticas Analíticas**: Representaciones gráficas del mantenimiento y cálculo de los Indicadores Clave de Rendimiento (KPIs) sobre el uso general del automóvil.
- **Soporte Multiidioma Nativo**: La aplicación está diseñada pensando en la accesibilidad internacional, contando con soporte para los idiomas: Español, Inglés, Francés, Portugués, Italiano y Alemán.
- **Personalización Visual (Temas Dinámicos)**: Soporte absoluto y fluido para alteraciones de "Modo Claro" y "Modo Oscuro" adaptándose a las preferencias visuales del usuario del sistema basándose en las líneas de diseño Material 3.
- **Sincronización en la Nube con Supabase**: Toda la información de vehículos, componentes, e históricos de mantenimiento se sincronizan usando una robusta base de datos remota en Supabase, aplicando Políticas de Seguridad por Nivel de Fila (Row Level Security - RLS) para garantizar la total privacidad de los datos personales.

---

## Arquitectura del Software

Este proyecto hace gala de las mejores prácticas de programación orientada a la mantenibilidad y escalabilidad, empleando una **Arquitectura Limpia (Clean Architecture)** separada de manera lógica en distintas capas:

1. **`core/`**: Funciones, enrutamiento estricto (`GoRouter`), temas visuales de la aplicación y constantes transversales.
2. **`domain/`**: Corazón del negocio. Aquí residen las interfaces de los repositorios que dictaminan cómo debe comportarse el acoplamiento de los datos sin depender de qué base de datos se esté usando.
3. **`data/`**: Capa de infraestructura profunda. Contiene los Data Access Objects (DAOs) que dialogan directamente de forma ruda con `Supabase`. También contiene los Modelos de datos estructurados en Dart.
4. **`providers/`**: Capa de inyección de dependencias y Control de Estado reactivo mediante el poderoso y seguro paquete **Riverpod**.
5. **`presentation/`**: Capa puramente visual y de usuario. Alberga todas las Pantallas e interfaces (`pantallas/`) así como los componentes reutilizables de UI (`widgets/`).

---

## Requisitos Previos para el Desarrollo y Ejecución

Para poder compilar y ejecutar esta aplicación en tu propia máquina, necesitarás disponer de:
- **Flutter SDK**: Versión ^3.35.0 (o la versión más reciente del SDK de Flutter que garantice estabilidad).
- **Dart SDK**: Versión ^3.9.0 minimum.
- Un entorno de desarrollo local como Android Studio, Visual Studio Code o IntelliJ, con un emulador de iOS/Android configurado o un dispositivo físico conectado en modo depuración (Developer Mode).

---

## Instrucciones Paso a Paso para la Instalación

1. **Clonar el proyecto:** Descarga el repositorio fuente en un directorio de tu elección.
2. **Obtener dependencias:** Abre un terminal en la raíz del proyecto y ejecuta el comando `flutter pub get`. Esto decargará todos los paquetes necesarios enumerados en el archivo `pubspec.yaml` (como Supabase, Riverpod, GoRouter, etc).
3. **Generar Archivos de Idioma:** Dado que el proyecto soporta múltiples idiomas, deberás ejecutar `flutter gen-l10n`. Esto compilará de forma automática los archivos localizados requeridos a partir de los diccionarios base (`.arb`).
4. **Disfruta del proyecto:** Finalmente, arranca la aplicación usando el comando `flutter run` o a través del depurador nativo de tu editor de código.

---

## Sobre el Icono Personalizado de la App

El proyecto viene preparado de fábrica con el paquete `flutter_launcher_icons` para la rápida gestión de iconografía en todos los sistemas operativos. Si deseas restaurar o modificar el icono provisto con la app original:
1. Reemplaza o cerciórate de que se encuentra guardada tu imagen de preferencia en la ruta `assets/icon/app_icon.png`.
2. Dirígete a tu consola, en la carpeta general de la app, e invoca el generador:
   ```bash
   dart run flutter_launcher_icons
   ```
Esto redimensionará y configurará automáticamente el icono para las compilaciones nativas de Android, Windows e iOS.

---

[Documentacion Supabase CronJob.pdf](https://github.com/user-attachments/files/28025677/Documentacion.Supabase.CronJob.pdf)

