# RickAndMortyApp para iOS

Aplicación nativa en **SwiftUI** que consume la [Rick and Morty API](https://rickandmortyapi.com/documentation) para explorar personajes, episodios y localizaciones.

El proyecto se presenta como una **prueba técnica iOS**: pone el foco en la separación de responsabilidades, el consumo de una API REST, la gestión de estado y una navegación desacoplada de las vistas.

## Funcionalidades

- Listados paginados y detalles de personajes, episodios y localizaciones.
- Búsqueda de personajes por nombre en una pestaña dedicada.
- Navegación entre entidades relacionadas: personajes, sus episodios y sus localizaciones.
- Gestión de carga, errores y resultados vacíos.
- Caché de imágenes, splash animado y Quick Actions.
- Textos localizados en español e inglés.

## Arquitectura y Decisiones

Se utiliza **MVVM + Coordinator**, organizado en presentación, datos y componentes comunes.

| Patrón o recurso | Aplicación en el proyecto |
| --- | --- |
| **MVVM** | Las vistas presentan contenido; los ViewModels gestionan carga, búsqueda y paginación. |
| **Coordinator** | Centraliza las decisiones de navegación y los flujos de cada sección. |
| **Navegación tipada** | `NavigationManager` encapsula `NavigationPath` y los destinos de `NavigationStack`. |
| **Inyección de dependencias y Factory** | `DependencyInjector` construye vistas y ViewModels; los contratos permiten sustituir clientes y coordinadores en tests. |
| **Estado observable** | `@Observable` y `ViewState` representan carga, contenido y error; las transiciones de estado se gestionan en `@MainActor`. |
| **Cliente de red por protocolo** | `APIClient` separa los ViewModels de `URLSession`; las peticiones usan `async/await` y modelos `Decodable`. |

La inyección es manual, sin un contenedor externo. Los ViewModels consumen directamente `APIClient`: no se añade una capa de repositorios o casos de uso para este alcance. El cliente centraliza la construcción de peticiones, la validación HTTP y la decodificación de respuestas.

Los coordinadores se organizan en raíz (`AppCoordinator`), pestañas (`TabBarCoordinator`) y flujos por entidad. Los ViewModels mantienen una referencia débil a su coordinador.

## Estructura

```text
RickAndMortyApp/
├── Application/       # Entrada de la app y Quick Actions
├── Common/            # Componentes, protocolos y utilidades compartidas
├── Data/              # Modelos, cliente de red y NavigationManager
├── Presentation/      # Coordinadores, vistas, ViewModels e inyección
└── Resources/         # Localización, assets y animaciones

RickAndMortyAppTests/   # Tests unitarios, mocks y datos de prueba
RickAndMortyAppUITests/ # Pruebas de interfaz y navegación
```

## Requisitos y Ejecución

| Requisito | Valor |
| --- | --- |
| iOS mínimo | **26.2**, en iPhone y iPad |
| Swift | Modo de lenguaje **5.0**, configurado en el proyecto |
| Xcode | Validado con **27.0**; no se declara una versión mínima de Xcode |
| Dependencias SPM | **Kingfisher 8.6.2** (imágenes) y **Lottie 4.6.0** (animación) |

1. Abre [RickAndMortyApp.xcodeproj](RickAndMortyApp.xcodeproj) en Xcode y espera la resolución de paquetes.
2. Selecciona el scheme `RickAndMortyApp` y un simulador con iOS 26.2 o superior.
3. Ejecuta con `Cmd + R`.

No requiere clave de API ni configuración de un backend. Sí necesita conexión a Internet para consultar el catálogo.

## Pruebas

- **Unitarias:** peticiones y endpoints, estados de vista y ViewModels. Utilizan mocks para comprobar carga, paginación, búsqueda y delegación de navegación sin acceder a la API real.
- **UI:** `testNavigationSmoke` comprueba el paso del splash al catálogo, la apertura del detalle de Rick Sanchez, el regreso al listado y el acceso a episodios, localizaciones y búsqueda.

**Resultado de navegación:** 1 test ejecutado y 0 fallos en iPhone 17 con iOS 27.0, usando Xcode 27.0 (13/10/2026). Esta prueba consulta la API real; no cubre todos los recorridos entre entidades ni verifica los resultados de búsqueda. La suite unitaria no se ha ejecutado en esta revisión.

Desde Xcode, ejecuta el plan de pruebas con `Cmd + U`. Para repetir solo el recorrido de navegación desde la raíz del repositorio:

```bash
xcodebuild test \
  -project RickAndMortyApp.xcodeproj \
  -scheme RickAndMortyApp \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=27.0' \
  -only-testing:RickAndMortyAppUITests/RickAndMortyAppUITests/testNavigationSmoke \
  -parallel-testing-enabled NO \
  -test-timeouts-enabled YES \
  -maximum-test-execution-time-allowance 120
```

Para ejecutar solo los tests unitarios, sustituye `-only-testing` por `-only-testing:RickAndMortyAppTests`. Ajusta el destino si utilizas otro simulador.

## Alcance

Es un catálogo de consulta, sin autenticación ni persistencia propia para uso offline. La búsqueda comparte el ViewModel del listado de personajes. Como siguientes pasos, se podría aislar ese estado y ampliar las pruebas de UI con datos controlados para no depender del servicio externo.