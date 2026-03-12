# TrucoApp (iOS)

Anotador de Truco Argentino hecho en **SwiftUI**.

## Qué incluye

- Marcador para dos equipos: **Nosotros** y **Ellos**.
- Puntaje objetivo configurable por reglas clásicas de truco:
  - Juego a 30 (15 malas + 15 buenas).
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
- `TrucoAnotador/ContentView.swift`: interfaz principal.
- `TrucoAnotador/Models/TrucoMatch.swift`: reglas y lógica de puntaje.

## Abrir en Xcode

1. Crear un nuevo proyecto iOS tipo **App** (SwiftUI) llamado `TrucoAnotador`.
2. Reemplazar los archivos generados por los de esta carpeta.
3. Ejecutar en simulador o dispositivo.

> El entorno de este repositorio no incluye Xcode (Linux), por eso no se puede compilar acá, pero el código está listo para pegar en un proyecto iOS SwiftUI.
