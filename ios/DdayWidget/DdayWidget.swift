import WidgetKit
import SwiftUI

struct DdayEntry: TimelineEntry {
    let date: Date
    let emoji: String
    let title: String
    let targetDate: String
    let days: Int
    let isPast: Bool
    let isDday: Bool
    let isEmpty: Bool
    let bgStartColor: Color
    let bgEndColor: Color
}

struct DdayProvider: TimelineProvider {
    let userDefaults = UserDefaults(suiteName: "group.com.daycount.app")

    func placeholder(in context: Context) -> DdayEntry {
        DdayEntry(
            date: Date(), emoji: "\u{1F495}", title: "My D-Day",
            targetDate: "2026-06-15", days: 105, isPast: false,
            isDday: false, isEmpty: false,
            bgStartColor: Color(hex: "6C63FF"),
            bgEndColor: Color(hex: "8B5CF6")
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (DdayEntry) -> Void) {
        completion(readEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DdayEntry>) -> Void) {
        let entry = readEntry()
        let midnight = Calendar.current.startOfDay(for: Date()).addingTimeInterval(86400)
        let timeline = Timeline(entries: [entry], policy: .after(midnight))
        completion(timeline)
    }

    private func readEntry() -> DdayEntry {
        let isEmpty = userDefaults?.bool(forKey: "widget_dday_empty") ?? true
        if isEmpty {
            return DdayEntry(
                date: Date(), emoji: "\u{1F4C5}", title: "Add your first D-Day",
                targetDate: "", days: 0, isPast: false, isDday: false,
                isEmpty: true,
                bgStartColor: Color(hex: "6C63FF"),
                bgEndColor: Color(hex: "8B5CF6")
            )
        }

        return DdayEntry(
            date: Date(),
            emoji: userDefaults?.string(forKey: "widget_dday_emoji") ?? "\u{1F4C5}",
            title: userDefaults?.string(forKey: "widget_dday_title") ?? "",
            targetDate: userDefaults?.string(forKey: "widget_dday_date") ?? "",
            days: userDefaults?.integer(forKey: "widget_dday_days") ?? 0,
            isPast: userDefaults?.bool(forKey: "widget_dday_is_past") ?? false,
            isDday: userDefaults?.bool(forKey: "widget_dday_is_dday") ?? false,
            isEmpty: false,
            bgStartColor: Color(hex: userDefaults?.string(forKey: "widget_theme_bg_start") ?? "6C63FF"),
            bgEndColor: Color(hex: userDefaults?.string(forKey: "widget_theme_bg_end") ?? "8B5CF6")
        )
    }
}

struct DdayWidgetView: View {
    var entry: DdayEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.emoji)
                .font(.system(size: family == .systemSmall ? 24 : 32))

            Text(entry.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)

            if !entry.isEmpty {
                Spacer()
                Text(entry.isDday ? "D-Day!" :
                     entry.isPast ? "D+\(entry.days)" : "D-\(entry.days)")
                    .font(.system(size: family == .systemSmall ? 28 : 36, weight: .black))
                    .foregroundColor(.white)

                if family != .systemSmall && !entry.targetDate.isEmpty {
                    Text(entry.targetDate)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

@main
struct DdayWidget: Widget {
    let kind: String = "DdayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DdayProvider()) { entry in
            DdayWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    LinearGradient(
                        gradient: Gradient(colors: [entry.bgStartColor, entry.bgEndColor]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
        }
        .configurationDisplayName("DayCount")
        .description("Display your closest D-Day countdown")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (108, 99, 255)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}
