# Reglas del Proyecto iOS

## Tech Stack & Standards
- **Lenguaje:** Swift 6.
- **UI:** SwiftUI (evitar UIKit salvo necesidad explícita).
- **Arquitectura:** MVVM-C (Model-View-ViewModel + Coordinator).
- **Concurrencia:** Swift Concurrency (`async/await`, `@MainActor`, `Task`). Evitar Combine o DispatchQueues tradicionales salvo herencia.
- **Gestión de Estado:** `@Observable` macro para ViewModels (Swift 5.9+).
- **Inyección de Dependencias:** Basado en protocolos y contenedores de DI ligeros.

## Buenas Prácticas
- Toda clase o struct pública/internal debe incluir documentación DocC.
- Priorizar views pequeñas y modulares en SwiftUI.
- Tratar los warnings de concurrencia como errores de compilación.
- Evitar el uso de `@StateObject` fuera de la vista raíz que lo necesita.
- Preferir `@EnvironmentObject` para compartir estado entre vistas.
- Mantener los ViewModels libres de referencias a vistas o UIKit.