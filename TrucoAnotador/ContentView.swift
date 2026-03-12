import SwiftUI

struct ContentView: View {
    @StateObject private var match = TrucoMatch()
    @State private var selectedAction: TrucoAction = .mano1
    @State private var showingRules = false

    var body: some View {
        NavigationStack {
            ZStack {
                VintageBackground()
                    .ignoresSafeArea()

                VStack(spacing: 14) {
                    scoreBoard

                    ScrollView {
                        VStack(spacing: 14) {
                            actionPicker
                            actionButtons
                            controls
                            historyList
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
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
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                TeamCard(team: .nosotros, match: match, color: Color(hex: "315A3D"))
                TeamCard(team: .ellos, match: match, color: Color(hex: "7A3E2E"))
            }

            if let winner = match.winner {
                Text("🏆 Ganó \(winner.rawValue)")
                    .font(.headline)
                    .fontDesign(.serif)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(hex: "F3E8C8"), in: Capsule())
                    .overlay(Capsule().stroke(Color(hex: "8C6E49"), lineWidth: 1))
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var actionPicker: some View {
        GroupBox("Jugada") {
            Picker("Jugada", selection: $selectedAction) {
                ForEach(TrucoAction.allCases) { action in
                    Text(action.rawValue).tag(action)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .groupBoxStyle(VintageBoxStyle())
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                match.apply(selectedAction, to: .nosotros)
            } label: {
                Text("+ Nosotros")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(VintageButtonStyle(tint: Color(hex: "315A3D")))

            Button {
                match.apply(selectedAction, to: .ellos)
            } label: {
                Text("+ Ellos")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(VintageButtonStyle(tint: Color(hex: "7A3E2E")))
        }
    }

    private var controls: some View {
        HStack {
            Button("Deshacer") {
                match.undo()
            }
            .buttonStyle(VintageButtonStyle(tint: Color(hex: "8C6E49")))

            Spacer()

            Button("Nueva partida", role: .destructive) {
                match.reset()
            }
            .buttonStyle(VintageButtonStyle(tint: Color(hex: "B8573D")))
        }
    }

    private var historyList: some View {
        GroupBox("Historial") {
            if match.history.isEmpty {
                Text("Sin jugadas todavía")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.secondary)
            } else {
                VStack(spacing: 8) {
                    ForEach(match.history) { move in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(move.team.rawValue)
                                    .font(.subheadline.bold())
                                Text(move.action.rawValue)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("+\(move.points)")
                                .font(.headline)
                            Text("(\(move.resultingScore))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Divider()
                    }
                }
            }
        }
        .groupBoxStyle(VintageBoxStyle())
    }
}

private struct TeamCard: View {
    let team: Team
    @ObservedObject var match: TrucoMatch
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(team.rawValue)
                .font(.headline)
                .fontDesign(.serif)

            Text("\(match.score(for: team))")
                .font(.system(size: 46, weight: .bold, design: .rounded))
                .foregroundStyle(color)

            HStack(spacing: 8) {
                phaseBadge(title: "Malas", value: match.malasPoints(for: team), active: match.phase(for: team) == .malas)
                phaseBadge(title: "Buenas", value: match.buenasPoints(for: team), active: match.phase(for: team) == .buenas)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: "F7EFD7"), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color(hex: "8C6E49"), lineWidth: 1.2))
        .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
    }

    @ViewBuilder
    private func phaseBadge(title: String, value: Int, active: Bool) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text("\(value)")
                .font(.caption.bold())
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(active ? color.opacity(0.2) : Color.white.opacity(0.6), in: Capsule())
    }
}

private struct RulesView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Objetivo") {
                    Text("Gana el primer equipo en llegar a 30 puntos (15 malas + 15 buenas).")
                    Text("Al pasar de 15, comenzás a sumar en buenas.")
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
            }
            .scrollContentBackground(.hidden)
            .background(VintageBackground())
            .navigationTitle("Reglas de Truco")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct VintageBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Color(hex: "EBDDB8"), Color(hex: "D2BC8E")],
            startPoint: .top,
            endPoint: .bottom
        )
        .overlay {
            Rectangle()
                .fill(.black.opacity(0.04))
                .blendMode(.multiply)
        }
    }
}

private struct VintageButtonStyle: ButtonStyle {
    let tint: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(tint.opacity(configuration.isPressed ? 0.55 : 0.85), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "F7EFD7"), lineWidth: 1))
            .foregroundStyle(.white)
    }
}

private struct VintageBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            configuration.label
                .font(.headline)
                .fontDesign(.serif)
            configuration.content
        }
        .padding(12)
        .background(Color(hex: "F7EFD7"), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "8C6E49"), lineWidth: 1.2))
    }
}

private extension Color {
    init(hex: String) {
        let sanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    ContentView()
}
