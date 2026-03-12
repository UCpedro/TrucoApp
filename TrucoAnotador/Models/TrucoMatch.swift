import Foundation
import Combine

enum Team: String, CaseIterable, Identifiable {
    case nosotros = "Nosotros"
    case ellos = "Ellos"

    var id: String { rawValue }

    var opponent: Team {
        self == .nosotros ? .ellos : .nosotros
    }
}

enum MatchPhase: String {
    case malas = "Malas"
    case buenas = "Buenas"
}

enum TrucoAction: String, CaseIterable, Identifiable {
    // Mano
    case mano1 = "Mano ganada (1)"
    case mano2 = "Mano ganada (2)"
    case mano3 = "Mano ganada (3)"

    // Truco
    case trucoQuerido = "Truco querido (2)"
    case retrucoQuerido = "Retruco querido (3)"
    case valeCuatroQuerido = "Vale Cuatro querido (4)"
    case trucoNoQuerido = "Truco no querido (1)"
    case retrucoNoQuerido = "Retruco no querido (2)"
    case valeCuatroNoQuerido = "Vale Cuatro no querido (3)"

    // Envido
    case envidoQuerido = "Envido querido (2)"
    case realEnvidoQuerido = "Real Envido querido (3)"
    case faltaEnvidoQuerido = "Falta Envido (al resto)"
    case envidoNoQuerido = "Envido no querido (1)"
    case realEnvidoNoQuerido = "Real Envido no querido (1)"

    // Flor
    case flor = "Flor (3)"
    case contraflor = "Contraflor (6)"
    case contraflorAlResto = "Contraflor al resto"

    var id: String { rawValue }

    func points(currentScore: Int, opponentScore: Int, maxScore: Int, malasLimit: Int) -> Int {
        switch self {
        case .mano1: return 1
        case .mano2: return 2
        case .mano3: return 3

        case .trucoQuerido: return 2
        case .retrucoQuerido: return 3
        case .valeCuatroQuerido: return 4
        case .trucoNoQuerido: return 1
        case .retrucoNoQuerido: return 2
        case .valeCuatroNoQuerido: return 3

        case .envidoQuerido: return 2
        case .realEnvidoQuerido: return 3
        case .faltaEnvidoQuerido,
                .contraflorAlResto:
            let target = opponentScore < malasLimit ? malasLimit : maxScore
            return max(1, target - currentScore)

        case .envidoNoQuerido: return 1
        case .realEnvidoNoQuerido: return 1

        case .flor: return 3
        case .contraflor: return 6
        }
    }
}

struct TrucoMove: Identifiable {
    let id = UUID()
    let team: Team
    let action: TrucoAction
    let points: Int
    let resultingScore: Int
}

@MainActor
final class TrucoMatch: ObservableObject {
    @Published var scoreNosotros: Int = 0
    @Published var scoreEllos: Int = 0
    @Published var history: [TrucoMove] = []

    let maxScore: Int
    let malasLimit: Int

    init(maxScore: Int = 30, malasLimit: Int = 15) {
        self.maxScore = maxScore
        self.malasLimit = malasLimit
    }

    var winner: Team? {
        if scoreNosotros >= maxScore { return .nosotros }
        if scoreEllos >= maxScore { return .ellos }
        return nil
    }

    func score(for team: Team) -> Int {
        team == .nosotros ? scoreNosotros : scoreEllos
    }

    func malasPoints(for team: Team) -> Int {
        min(score(for: team), malasLimit)
    }

    func buenasPoints(for team: Team) -> Int {
        max(0, score(for: team) - malasLimit)
    }

    func phase(for team: Team) -> MatchPhase {
        score(for: team) < malasLimit ? .malas : .buenas
    }

    func apply(_ action: TrucoAction, to team: Team) {
        guard winner == nil else { return }

        let current = score(for: team)
        let opponent = score(for: team.opponent)
        let points = action.points(
            currentScore: current,
            opponentScore: opponent,
            maxScore: maxScore,
            malasLimit: malasLimit
        )
        let newScore = min(maxScore, current + points)

        if team == .nosotros {
            scoreNosotros = newScore
        } else {
            scoreEllos = newScore
        }

        history.insert(
            TrucoMove(team: team, action: action, points: points, resultingScore: newScore),
            at: 0
        )
    }

    func undo() {
        guard let last = history.first else { return }
        history.removeFirst()

        if last.team == .nosotros {
            scoreNosotros = max(0, scoreNosotros - last.points)
        } else {
            scoreEllos = max(0, scoreEllos - last.points)
        }
    }

    func reset() {
        scoreNosotros = 0
        scoreEllos = 0
        history.removeAll()
    }
}
