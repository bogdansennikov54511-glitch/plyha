import WidgetKit
import SwiftUI
import AppIntents

struct PlyukhEntry: TimelineEntry {
    let date: Date
    let state: String
}

struct PlyukhProvider: TimelineProvider {
    func placeholder(in context: Context) -> PlyukhEntry {
        PlyukhEntry(date: Date(), state: "blunt")
    }
    func getSnapshot(in context: Context, completion: @escaping (PlyukhEntry) -> Void) {
        completion(PlyukhEntry(date: Date(), state: "blunt"))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<PlyukhEntry>) -> Void) {
        let states = ["chill", "blunt", "squatSemki", "shawarma", "doshik", "brick"]
        let saved = UserDefaults.standard.string(forKey: "plyukh_state") ?? states.randomElement()!
        let entry = PlyukhEntry(date: Date(), state: saved)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }
}

struct SwitchPlyukhWidgetIntent: AppIntent {
    static var title: LocalizedStringResource = "Действие Плюха"
    @Parameter(title: "State") var nextState: String
    init() {}
    init(nextState: String) { self.nextState = nextState }
    func perform() async throws -> some IntentResult {
        UserDefaults.standard.set(nextState, forKey: "plyukh_state")
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

struct PlyukhWidgetView: View {
    var entry: PlyukhProvider.Entry

    var body: some View {
        ZStack {
            Color(red: 0.12, green: 0.14, blue: 0.18)

            VStack(spacing: 4) {
                ZStack {
                    Ellipse()
                        .fill(Color.black.opacity(0.45))
                        .frame(width: 86, height: 16)
                        .offset(y: 36)

                    // Туловище Плюха без зеленой ауры
                    Ellipse()
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 0.85, green: 0.87, blue: 0.91), Color(red: 0.55, green: 0.58, blue: 0.65)],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                        .frame(width: entry.state == "squatSemki" ? 94 : 82,
                               height: entry.state == "squatSemki" ? 62 : 72)
                        .overlay(
                            Ellipse().stroke(Color(red: 0.12, green: 0.16, blue: 0.23), lineWidth: 3)
                        )

                    // Пластырь
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(red: 0.9, green: 0.77, blue: 0.65))
                        .frame(width: 15, height: 6)
                        .rotationEffect(.degrees(-22))
                        .offset(x: -19, y: -21)

                    // Глаза
                    HStack(spacing: 7) {
                        ForEach(0..<2, id: \.self) { _ in
                            ZStack {
                                Circle()
                                    .fill(entry.state == "blunt" ? Color(red: 1.0, green: 0.89, blue: 0.9) : Color.white)
                                    .frame(width: 19, height: 19)
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 7.5, height: 7.5)
                                    .offset(x: 1.5, y: 1)
                            }
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        }
                    }
                    .offset(y: -7)

                    Capsule()
                        .fill(Color.black)
                        .frame(width: 16, height: 3)
                        .offset(y: 10)

                    if entry.state == "blunt" {
                        HStack(spacing: 0) {
                            Circle().fill(Color.red).frame(width: 5, height: 5)
                            Rectangle().fill(Color.gray).frame(width: 3, height: 5)
                            Rectangle().fill(Color.brown).frame(width: 15, height: 5)
                        }
                        .offset(x: -19, y: 10)
                    } else if entry.state == "shawarma" {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(red: 0.96, green: 0.87, blue: 0.70))
                            .frame(width: 13, height: 20)
                            .offset(x: -18, y: 12)
                    } else if entry.state == "doshik" {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.red)
                            .frame(width: 22, height: 12)
                            .offset(x: -16, y: 13)
                    } else if entry.state == "squatSemki" {
                        Text("🌻🐦").font(.system(size: 14)).offset(x: 24, y: 16)
                    }
                }
                .padding(.top, 6)

                HStack(spacing: 8) {
                    Button(intent: SwitchPlyukhWidgetIntent(nextState: "blunt")) { Text("🌿").font(.system(size: 12)) }
                    Button(intent: SwitchPlyukhWidgetIntent(nextState: "squatSemki")) { Text("🌻").font(.system(size: 12)) }
                    Button(intent: SwitchPlyukhWidgetIntent(nextState: "shawarma")) { Text("🌯").font(.system(size: 12)) }
                    Button(intent: SwitchPlyukhWidgetIntent(nextState: "doshik")) { Text("🍜").font(.system(size: 12)) }
                }
                .buttonStyle(.plain)

                Text("60 кадров/с · сборка 12")
                    .font(.system(size: 8.5, weight: .bold))
                    .foregroundColor(.white.opacity(0.65))
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

@main
struct DomikPlyukhaWidget: Widget {
    let kind: String = "DomikPlyukhaWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PlyukhProvider()) { entry in
            PlyukhWidgetView(entry: entry)
        }
        .configurationDisplayName("Домик Плюха")
        .description("Ровный пацан с района на твоем экране.")
        .supportedFamilies([.systemSmall])
    }
}
