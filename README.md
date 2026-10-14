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
| **Inyección de dependencias y Factory** | `DependencyInjector` compone vistas, ViewModels, casos de uso y el repositorio; cada factoría de caso de uso acepta un repositorio sustituible. |
| **Estado observable** | `@Observable` y `ViewState` representan carga, contenido y error; las transiciones de estado se gestionan en `@MainActor`. |
| **Casos de uso por operación** | Cada ViewModel recibe un `Get...UseCase` concreto como `struct`. Todos implementan un único protocolo `UseCase` con `Input`, `Output` y `handle(_:)`, e inyectan `HttpRepository`. |
| **Repositorio por protocolo** | `HttpRepository` expone seis operaciones tipadas de listado y detalle; `DefaultHttpRepository` selecciona los endpoints y delega en `APIClient`. |
| **Cliente de red por protocolo** | `APIClient` abstrae `URLSession`; las peticiones usan `async/await` y modelos `Decodable`. |

La inyección es manual, sin un contenedor externo. El flujo de datos es `ViewModel → UseCase → HttpRepository → APIClient → URLSession`. Los seis casos de uso limitan cada ViewModel a su operación de listado o detalle; actualmente delegan en el repositorio sin añadir reglas de negocio. Los ViewModels conservan el estado, el debounce y la decisión de cargar otra página, sin conocer el repositorio ni los endpoints. Se mantienen los modelos de respuesta de la API, sin mapeos adicionales. El cliente centraliza la construcción de peticiones, la validación HTTP y la decodificación de respuestas.

El contrato común exige `func handle(_ input: Input) async throws -> Output`. Los detalles usan `String` como entrada, los listados de episodios y localizaciones usan `Int`, y el listado de personajes define un `Input` con página y nombre opcional. Cada caso declara su `Output`; no hay protocolos específicos, implementaciones `DefaultGet...` ni dependencias `any UseCase` en los ViewModels. El repositorio sigue siendo sustituible mediante su protocolo.

Los coordinadores se organizan en raíz (`AppCoordinator`), pestañas (`TabBarCoordinator`) y flujos por entidad. Los ViewModels mantienen una referencia débil a su coordinador.

## Estructura

```text
RickAndMortyApp/
├── Application/       # Entrada de la app y Quick Actions
├── Common/            # Componentes, protocolos y utilidades compartidas
├── Data/              # Modelos, repositorio, cliente de red y NavigationManager
├── Domain/            # Protocolo UseCase y seis casos concretos
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

- **Unitarias:** peticiones, endpoints, repositorio, casos de uso, composición de dependencias y ViewModels. Los ViewModels se prueban junto a su caso de uso real sobre `MockHttpRepository`; los casos de uso se prueban también de forma directa y a través del contrato genérico común. El repositorio usa `MockAPIClient`, sin acceder a la API real. Las nuevas suites usan Swift Testing; los tests existentes conservan XCTest.
- **UI:** `testNavigationSmoke` comprueba el paso del splash al catálogo, la apertura del detalle de Rick Sanchez, el regreso al listado y el acceso a episodios, localizaciones y búsqueda.

**Resultado unitario:** 64 tests aprobados y 0 fallos en iPhone 18 Pro con iOS 27.0, usando Xcode 27.0 (14/10/2026), incluidos 16 tests de casos de uso, 6 de composición y 8 del repositorio.

**Resultado de navegación:** 1 test ejecutado y 0 fallos en iPhone 17 con iOS 27.0, usando Xcode 27.0 (13/10/2026). Esta prueba consulta la API real; no cubre todos los recorridos entre entidades ni verifica los resultados de búsqueda. No se ha repetido tras incorporar el repositorio y los casos de uso.

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