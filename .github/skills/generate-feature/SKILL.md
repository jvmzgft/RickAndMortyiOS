---
name: generate-feature
description: Genera la estructura completa de código para un nuevo módulo o funcionalidad en iOS usando Swift 6, SwiftUI y MVVM-C, adaptándose dinámicamente al alcance requerido.
---

# Skill: Generador de Feature iOS (MVVM-C)

## Reglas de Adaptabilidad
- **Si la feature es una vista estática o simple:** Genera únicamente la capa de Vista SwiftUI y su correspondiente `#Preview`, omitiendo servicios y ViewModels complejos.
- **Si la feature incluye lógica de estado o red:** Genera la estructura completa por capas según se define a continuación.

---

## Estructura por Capas

### 1. Capa de Modelo (Domain / Entity)
*Si la feature requiere persistencia o manipulación de datos:*
- Crea estructuras `Codable`, `Identifiable` y `Equatable`.
- Usa tipos de datos fuertemente tipados (`UUID`, `Date`, etc.).

### 2. Capa de Servicio y Contrato (Data Layer)
*Si la feature interactúa con APIs o persistencia:*
- Define el protocolo: `protocol [Nombre]ServiceProtocol: Sendable`
- Implementa la clase de producción: `final class [Nombre]Service: [Nombre]ServiceProtocol`
- Implementa el Mock para pruebas/previews: `final class Mock[Nombre]Service: [Nombre]ServiceProtocol`

### 3. Capa de Presentación (ViewModel)
*Si la feature maneja estado o llamadas asíncronas:*
- Usa la macro moderna: `@Observable @MainActor final class [Nombre]ViewModel`
- Inyecta el servicio mediante el inicializador (`service: [Nombre]ServiceProtocol`).
- Maneja un enum genérico para el estado de la vista:
  ```swift
  enum ViewState: Equatable {
      case idle
      case loading
      case loaded
      case error(String)
  }