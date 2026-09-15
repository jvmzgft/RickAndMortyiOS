---
name: swift-testing-generator
description: Diseña y genera una suite de pruebas unitarias asíncronas para ViewModels o Servicios utilizando el framework moderno Swift Testing (import Testing).
---

# Skill: Generador de Pruebas Unitarias (Swift Testing)

## Directrices de Estructura
1. Usa **exclusivamente** el framework nativo `import Testing` en lugar de `XCTest`.
2. Agrupa los casos de prueba dentro de un bloque `@Suite("Pruebas de [NombreComponente]")`.
3. Aplica el patrón **Given - When - Then** en el cuerpo de cada prueba.

---

## Cobertura Requerida (Mínimo 3 Escenarios)

1. **Caso de Éxito:**
   - Verifica el flujo principal cuando las dependencias devuelven datos válidos.
   - Comprueba la transición del estado a `.loaded`.
2. **Caso de Error:**
   - Configura el Mock para que lance una excepción o marque fallo.
   - Verifica la captura adecuada con `#expect(throws: ...)` o la actualización a `.error`.
3. **Caso Límite / Colección Vacía:**
   - Comprueba la respuesta ante colecciones vacías o parámetros opcionales en `nil`.

---

## Plantilla Base de Código

```swift
import Testing
@testable import TuApp

@Suite("Pruebas de [Nombre]ViewModel")
struct [Nombre]ViewModelTests {

    @Test("La carga inicial exitosa actualiza el estado a loaded")
    func testLoadDataSuccess() async throws {
        // Given
        let mockService = Mock[Nombre]Service(shouldSucceed: true)
        let sut = await [Nombre]ViewModel(service: mockService)

        // When
        await sut.loadData()

        // Then
        await #expect(sut.state == .loaded)
    }

    @Test("Un fallo en el servicio actualiza el estado a error")
    func testLoadDataFailure() async throws {
        // Given
        let mockService = Mock[Nombre]Service(shouldSucceed: false)
        let sut = await [Nombre]ViewModel(service: mockService)

        // When
        await sut.loadData()

        // Then
        if case .error(let message) = await sut.state {
            #expect(!message.isEmpty)
        } else {
            Issue.record("Se esperaba un estado de error.")
        }
    }
}