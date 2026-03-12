import SwiftUI

struct ContentView: View {
    @StateObject private var match = TrucoMatch()
    @State private var selectedAction: TrucoAction = .mano1
    @State private var showingRules = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                scoreBoard
                actionPicker
                actionButtons
                controls
                historyList
            }
            .padding()
            .navigationTitle("Anotador de Truco")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Reglas") {
                        showingRules = true
                    }
                }
            }
            .sheet(isPresented: $showingRules) {
                RulesView()
            }
        }
    }

    private var scoreBoard: some View {
        HStack(spacing: 12) {
            TeamCard(name: Team.nosotros.rawValue,
                     score: match.scoreNosotros,
                     color: .blue)
            TeamCard(name: Team.ellos.rawValue,
                     score: match.scoreEllos,
                     color: .red)
        }
        .overlay(alignment: .bottom) {
            if let winner = match.winner {
                Text("🏆 Ganó \(winner.rawValue)")
                    .font(.headline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial, in: Capsule())
                    .offset(y: 18)
            }
        }
        .padding(.bottom, match.winner == nil ? 0 : 20)
    }

    private var actionPicker: some View {
        Picker("Jugada", selection: $selectedAction) {
            ForEach(TrucoAction.allCases) { action in
                Text(action.rawValue).tag(action)
            }
        }
        .pickerStyle(.menu)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                match.apply(selectedAction, to: .nosotros)
            } label: {
                Label("Sumar a Nosotros", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)

            Button {
                match.apply(selectedAction, to: .ellos)
            } label: {
                Label("Sumar a Ellos", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
    }

    private var controls: some View {
        HStack {
            Button("Deshacer") {
                match.undo()
            }
            .buttonStyle(.bordered)

            Spacer()

            Button("Nueva partida", role: .destructive) {
                match.reset()
            }
            .buttonStyle(.bordered)
        }
    }

    private var historyList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Historial")
                .font(.headline)

            if match.history.isEmpty {
                Text("Sin jugadas todavía")
                    .foregroundStyle(.secondary)
            } else {
                List(match.history) { move in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(move.team.rawValue)
                                .font(.subheadline.bold())
                            Text(move.action.rawValue)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("+\(move.points)")
                            .font(.headline)
                    }
                }
                .listStyle(.plain)
                .frame(minHeight: 180)
            }
        }
    }
}

private struct TeamCard: View {
    let name: String
    let score: Int
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Text(name)
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("\(score)")
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .foregroundStyle(color)
            Text("puntos")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct RulesView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Objetivo") {
                    Text("Gana el primer equipo en llegar a 30 puntos (15 malas + 15 buenas).")
                }

                Section("Truco") {
                    Text("• Truco querido: 2")
                    Text("• Retruco querido: 3")
                    Text("• Vale Cuatro querido: 4")
                    Text("• No querido: se anota el valor anterior (1, 2 o 3)")
                }

                Section("Envido") {
                    Text("• Envido querido: 2")
                    Text("• Real Envido querido: 3")
                    Text("• Falta Envido: puntos al resto para ganar")
                    Text("• Envido / Real Envido no querido: 1")
                }

                Section("Flor") {
                    Text("• Flor: 3")
                    Text("• Contraflor: 6")
                    Text("• Contraflor al resto: puntos al resto")
                }

                Section("Mano") {
                    Text("Podés sumar 1, 2 o 3 puntos manualmente para casos de mano cerrada o resolución especial.")
                }
            }
            .navigationTitle("Reglas de Truco")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
