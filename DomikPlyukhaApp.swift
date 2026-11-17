import SwiftUI
import WidgetKit

@main
struct DomikPlyukhaApp: App {
    var body: some Scene {
        WindowGroup {
            PlyukhMainView()
        }
    }
}

struct PlyukhMainView: View {
    @State private var state: String = "chill"
    @State private var statusText: String = "Ровный пацан на связи"

    let actions: [(String, String, String)] = [
        ("chill", "😎 На чилле", "Плюх отдыхает"),
        ("blunt", "🌿 Скрутить плотный блант", "Хороша тяга, Бро! (Без ауры)"),
        ("squatSemki", "🌻 Сесть на корты (Семки + Голубь)", "Щелкаем семки с голубем"),
        ("shawarma", "🌯 Заказать горячую Шаурму", "Сочная шавуха в лаваше!"),
        ("doshik", "🍜 Заварить горячий Дошик", "Пробило на горячий Дошик"),
        ("brick", "🧱 Подкачаться кирпичом", "Бицуха растет!"),
        ("phone", "📱 Поймать сеть на треснутой мобиле", "Ловим палки сети...")
    ]

    var body: some View {
        ZStack {
            Color(red: 0.09, green: 0.11, blue: 0.15).ignoresSafeArea()
            VStack(spacing: 18) {
                Text("Домик Плюха v7.1")
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundColor(.white)

                Text(statusText)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.green)

                TimelineView(.animation) { context in
                    let t = context.date.timeIntervalSinceReferenceDate
                    PlyukhCanvasCharacter(state: state, time: t)
                        .frame(width: 240, height: 220)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color(red: 0.14, green: 0.17, blue: 0.22))
                        )
                }

                Text("Управление Плюхом (также меняет виджет):")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(actions, id: \.0) { act in
                            Button(action: {
                                state = act.0
                                statusText = act.2
                                UserDefaults.standard.set(act.0, forKey: "plyukh_state")
                                WidgetCenter.shared.reloadAllTimelines()
                            }) {
                                HStack {
                                    Text(act.1)
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    if state == act.0 {
                                        Text("АКТИВНО")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(.green)
                                    }
                                }
                                .padding(14)
                                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.08)))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.top, 16)
        }
    }
}

struct PlyukhCanvasCharacter: View {
    let state: String
    let time: Double

    var body: some View {
        let breathe = CGFloat(sin(time * 3.0)) * 3.0
        ZStack {
            Ellipse()
                .fill(Color.black.opacity(0.45))
                .frame(width: 110 + breathe, height: 22)
                .offset(y: 52)

            // Ноги
            Ellipse()
                .fill(Color(red: 0.53, green: 0.57, blue: 0.63))
                .frame(width: 32, height: 18)
                .offset(x: -26, y: 48)
            Ellipse()
                .fill(Color(red: 0.53, green: 0.57, blue: 0.63))
                .frame(width: 32, height: 18)
                .offset(x: 26, y: 48)

            // Тело Плюха (без зеленой ауры!)
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.85, green: 0.87, blue: 0.91), Color(red: 0.55, green: 0.58, blue: 0.65)],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(width: (state == "squatSemki" ? 124 : 108) + breathe,
                       height: (state == "squatSemki" ? 82 : 94) - breathe)
                .overlay(Ellipse().stroke(Color(red: 0.12, green: 0.16, blue: 0.23), lineWidth: 4))

            // Пластырь
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(red: 0.9, green: 0.77, blue: 0.65))
                .frame(width: 22, height: 8)
                .rotationEffect(.degrees(-22))
                .offset(x: -28, y: -28)

            // Глаза
            HStack(spacing: 10) {
                ForEach(0..<2, id: \.self) { _ in
                    ZStack {
                        Circle()
                            .fill(state == "blunt" ? Color(red: 1.0, green: 0.89, blue: 0.9) : Color.white)
                            .frame(width: 26, height: 26)
                        Circle()
                            .fill(Color.black)
                            .frame(width: 10, height: 10)
                            .offset(x: CGFloat(cos(time * 2.0) * 3.0), y: CGFloat(sin(time * 2.0) * 2.0))
                    }
                    .overlay(Circle().stroke(Color.black, lineWidth: 2.5))
                }
            }
            .offset(y: -10)

            // Рот
            Capsule()
                .fill(Color.black)
                .frame(width: 22, height: 4)
                .offset(y: 14)

            // Текстурированные пропы
            if state == "blunt" {
                HStack(spacing: 0) {
                    Circle().fill(Color.red).frame(width: 7, height: 7)
                    Rectangle().fill(Color.gray).frame(width: 4, height: 6)
                    Rectangle().fill(Color.brown).frame(width: 22, height: 6)
                }
                .offset(x: -26, y: 14)
            } else if state == "shawarma" {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 0.96, green: 0.87, blue: 0.70))
                        .frame(width: 20, height: 32)
                    Rectangle()
                        .fill(Color.gray.opacity(0.6))
                        .frame(width: 20, height: 12)
                        .offset(y: 10)
                }
                .offset(x: -26, y: 16)
            } else if state == "doshik" {
                ZStack {
                    RoundedRectangle(cornerRadius: 3).fill(Color.white).frame(width: 34, height: 20)
                    Rectangle().fill(Color.red).frame(width: 34, height: 6)
                }
                .offset(x: -24, y: 18)
            } else if state == "brick" {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(red: 0.72, green: 0.11, blue: 0.11))
                    .frame(width: 30, height: 18)
                    .offset(x: 48, y: CGFloat(sin(time * 6.0) * 14.0))
            } else if state == "squatSemki" {
                Text("🌻  🐦")
                    .font(.system(size: 22))
                    .offset(x: 34, y: 24)
            } else if state == "phone" {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.cyan)
                    .frame(width: 16, height: 26)
                    .offset(x: 42, y: -36)
            }
        }
    }
}
