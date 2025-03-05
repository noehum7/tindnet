# 📱 TindNet

TindNet es una aplicación móvil desarrollada en Flutter que permite a los usuarios descubrir empresas locales mediante una interfaz intuitiva de deslizamiento similar a las aplicaciones de citas.


## 🎥 Demo del Proyecto

Mira el funcionamiento completo de la aplicación en este vídeo demostrativo:

[![TindNet Demo](screenshots/thumbnail.png)](https://youtube.com/shorts/8yVEVz2IriU?feature=share "Ver Demo de TindNet")

> 💡 Demostración completa del flujo de uso para clientes y empresas

## 📱 Capturas de Pantalla

<div align="center">
  <table>
    <tr>
      <td align="center">
        <img src="screenshots/home.png" width="200" alt="Pantalla de inicio"/>
        <br>
        <sub><b>Pantalla de Inicio</b></sub>
        <br>
        <sub>Primera vista de la aplicación</sub>
      </td>
      <td align="center">
        <img src="screenshots/login.png" width="200" alt="Pantalla de login"/>
        <br>
        <sub><b>Login</b></sub>
        <br>
        <sub>Inicio de sesión para usuarios</sub>
      </td>
      <td align="center">
        <img src="screenshots/registro_clientes.png" width="200" alt="Pantalla de registro clientes"/>
        <br>
        <sub><b>Registro de Clientes</b></sub>
        <br>
        <sub>Formulario de registro para clientes</sub>
      </td>
    </tr>
    <tr>
      <td align="center">
        <img src="screenshots/card.png" width="200" alt="Pantalla de tarjetas de empresa"/>
        <br>
        <sub><b>Tarjetas de Empresa</b></sub>
        <br>
        <sub>Tarjeta informativa de la empresa, like para marcarla favorita o iniciar un chat</sub>
      </td>
      <td align="center">
        <img src="screenshots/menu_clientes.png" width="200" alt="Pantalla de menu clientes"/>
        <br>
        <sub><b>Menú de Clientes</b></sub>
        <br>
        <sub>Centro de gestión de clientes con acceso a favoritos, perfil, chats y configuración</sub>
      </td>
      <td align="center">
        <img src="screenshots/favoritos.png" width="200" alt="Pantalla de favoritos"/>
        <br>
        <sub><b>Favoritos</b></sub>
        <br>
        <sub>Empresas guardadas por el usuario como favoritas</sub>
      </td>
    </tr>
    <tr>
      <td align="center">
        <img src="screenshots/search.png" width="200" alt="Pantalla de búsqueda"/>
        <br>
        <sub><b>Búsqueda</b></sub>
        <br>
        <sub>Búsqueda de empresas por filtros</sub>
      </td>
      <td align="center">
        <img src="screenshots/registro_empresas.png" width="200" alt="Pantalla de registro de empresas"/>
        <br>
        <sub><b>Registro de Empresas</b></sub>
        <br>
        <sub>Alta de nuevas empresas</sub>
      </td>
      <td align="center">
        <img src="screenshots/menu_empresas.png" width="200" alt="Pantalla de menu empresas"/>
        <br>
        <sub><b>Menú de Empresas</b></sub>
        <br>
        <sub>Centro de gestión de empresas con acceso al perfil, chats, reseñas y configuración </sub>
      </td>
    </tr>
  </table>
</div>

## ✨ Características principales

- **Descubrimiento de empresas**: Desliza entre diferentes empresas locales para descubrir nuevos negocios.
- **Sistema de favoritos**: Guarda tus empresas favoritas para acceder rápidamente a ellas más tarde.
- **Chat integrado**: Comunícate fácilmente con las empresas directamente desde la aplicación.
- **Perfiles detallados**: Visualiza información completa sobre cada empresa, incluyendo ubicación, horarios y servicios.
- **Filtros personalizados**: Encuentra empresas que se adapten a tus necesidades específicas.

## 🛠️ Tecnologías utilizadas

- Dart como lenguaje de programación
- Flutter para el desarrollo multiplataforma
- Firebase como backend (Autenticación, Firestore, Storage)

## 📲 Instalación

1. Clona este repositorio
2. Ejecuta `flutter pub get` para instalar las dependencias
3. Configura tus propias credenciales de Firebase (ver sección de configuración)
4. Ejecuta `flutter run` para iniciar la aplicación

## 🔥 Configuración de Firebase

Para ejecutar la aplicación necesitarás:
1. Crear un proyecto en [Firebase Console](https://console.firebase.google.com/)
2. Obtener los archivos de configuración:
   - `google-services.json` para Android
   - `GoogleService-Info.plist` para iOS
   - `firebase_options.dart` usando FlutterFire CLI
3. Colocar los archivos en sus respectivas ubicaciones

## 🤝 Contribución

Las contribuciones son bienvenidas. Por favor, abre un issue primero para discutir los cambios propuestos.

## 📄 Licencia
Este proyecto está licenciado bajo la [Licencia MIT](LICENSE).

