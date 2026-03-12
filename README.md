# TrucoApp (iOS)

Anotador de Truco Argentino hecho en **SwiftUI**, con interfaz simple, agradable y estilo vintage.

## Qué incluye

- Marcador para dos equipos: **Nosotros** y **Ellos**.
- Soporte explícito de **malas y buenas**:
  - El juego va a 30 puntos.
  - Primeros 15 puntos: malas.
  - De 16 a 30: buenas.
- Cálculo de jugadas **al resto** (Falta Envido / Contraflor al resto) según el puntaje del rival:
  - Si el rival está en malas, se juega al cierre de malas (15).
  - Si el rival está en buenas, se juega al cierre de partida (30).
- Carga rápida de tantos por:
  - Mano ganada (1, 2 o 3 puntos).
  - Truco / Retruco / Vale Cuatro (querido y no querido).
  - Envido / Real Envido / Falta Envido.
  - Flor / Contraflor / Contraflor al resto.
- Historial de jugadas con detalle.
- Deshacer última jugada.
- Reiniciar partida.
- Pantalla de reglas resumidas para consulta rápida.

## Estructura

- `TrucoAnotador/TrucoAnotadorApp.swift`: entrada de la app.
- `TrucoAnotador/ContentView.swift`: interfaz principal y diseño vintage.
- `TrucoAnotador/Models/TrucoMatch.swift`: reglas, lógica de puntaje y separación malas/buenas.

## Abrir en Xcode

1. Crear un nuevo proyecto iOS tipo **App** (SwiftUI) llamado `TrucoAnotador`.
2. Reemplazar los archivos generados por los de esta carpeta.
3. Ejecutar en simulador o dispositivo.

> El entorno de este repositorio no incluye Xcode (Linux), por eso no se puede compilar acá, pero el código está listo para usar en un proyecto iOS SwiftUI.
