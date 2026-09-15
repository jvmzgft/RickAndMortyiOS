---
name: build-complete-feature
description: Orquesta la creación de una feature iOS completa en 4 fases secuenciales pasando el contexto entre el Arquitecto, SwiftUI Expert, Tester y Code Reviewer.
---

# Skill Máster: Pipeline de Feature Completa iOS

Cuando el usuario invoque `/build-complete-feature [descripción de la funcionalidad]`, debes ejecutar un flujo secuencial en **4 Fases**, acumulando y pasando el contexto generado de una fase a la siguiente.

---

## FASE 1: Arquitectura y Contratos
* **Rol Activo:** `@ios-architect`
* **Entrada:** Requisitos funcionales proporcionados por el usuario.
* **Acciones:**
  1. Diseña la entidad o modelo de datos (`struct` / `Codable` / `Identifiable`).
  2. Define el protocolo del servicio/repositorio (`Sendable`).
  3. Define la interfaz del ViewModel y el estado de la vista (`ViewState`).
* **Salida de la Fase:** Modelos, protocolos e interfaces listos para implementación.

---

## FASE 2: Implementación UI y Lógica de Presentación
* **Rol Activo:** `@swiftui-expert` (Invocando la Skill `/generate-feature`)
* **Entrada:** Artefactos y contratos generados en la FASE 1.
* **Acciones:**
  1. Implementa el ViewModel usando `@Observable` y `@MainActor`, inyectando el servicio por constructor.
  2. Implementa el Mock del servicio para previsualización.
  3. Crea la vista en SwiftUI consumiendo el ViewModel, manejando los estados visuales (carga, contenido, error) y añadiendo un `#Preview` funcional.
* **Salida de la Fase:** Código fuente Swift completo y funcional del módulo.

---

## FASE 3: Suite de Pruebas Unitarias
* **Rol Activo:** `@ios-testing-agent` (Invocando la Skill `/swift-testing-generator`)
* **Entrada:** ViewModel y Mock generados en la FASE 2.
* **Acciones:**
  1. Escribe la suite de pruebas unitarias asíncronas con el framework `import Testing`.
  2. Cubre los escenarios de éxito (transición a `.loaded`), error (captura de excepciones o estado `.error`) y casos límite/colecciones vacías.
* **Salida de la Fase:** Archivo de tests listo para el target de pruebas.

---

## FASE 4: Auditoría y Refactorización Final
* **Rol Activo:** `@code-reviewer` (Invocando la Skill `/code-review-audit`)
* **Entrada:** Todo el código fuente e implementación de tests generados en las FASES 2 y 3.
* **Acciones:**
  1. Inspecciona el código buscando retenes de memoria (`[weak self]`), problemas de concurrencia en Swift 6 (`@MainActor`) o faltas de accesibilidad.
  2. Ofrece un breve reporte de hallazgos.
  3. Muestra la versión **definitiva y refactorizada** del código completo si se detectó algún fallo.
* **Salida de la Fase:** Código final pulido listo para integrarse en el proyecto.