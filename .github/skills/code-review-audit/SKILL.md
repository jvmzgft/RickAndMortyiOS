---
name: code-review-audit
description: Audita código Swift/SwiftUI en busca de fugas de memoria (retain cycles), problemas de concurrencia en Swift 6, vulnerabilidades y fallos de accesibilidad.
---

# Skill: Auditoría y Code Review de iOS

## Lista de Comprobación Técnica

### 1. Gestión de Memoria y Retain Cycles
- Comprueba la presencia de `[weak self]` en closures asíncronos o callbacks de larga duración.
- Verifica que las propiedades de delegados utilicen `weak var`.

### 2. Concurrencia y Aislamiento en Swift 6
- Asegura que la modificación de variables `@State` o elementos de UI ocurran dentro del hilo principal (`@MainActor`).
- Verifica la ausencia de datos mutables compartidos entre hilos sin aislamiento adecuado (`Sendable` / `actor`).

### 3. Seguridad de Ejecución
- Detecta desempaquetados forzados inseguros (`!`) o llamadas a `try!` que puedan provocar *crashes* en producción.

---

## Formato Estricto del Reporte

Organiza la respuesta evaluando el código revisado en estas cuatro secciones:

1. 🚨 **Errores Críticos / Riesgo de Crash:** Fugas de memoria, dataraces o errores en tiempo de ejecución.
2. ⚠️ **Advertencias y Rendimiento:** Lógica de negocio en la Vista SwiftUI, llamadas innecesarias a `body` o malas prácticas de estilo.
3. ✅ **Puntos Fortalecidos:** Patrones bien implementados y cumplimiento de estándares.
4. 🛠️ **Código Refactorizado:** Proporciona el bloque completo de código con todas las correcciones aplicadas.