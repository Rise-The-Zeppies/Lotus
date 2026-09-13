import WidgetKit
import SwiftUI
import Foundation

// ---------------------------------------------------------
// WEATHER WIDGET
// ---------------------------------------------------------

struct WeatherEntry: TimelineEntry {
    let date: Date
    let temperature: Double
}

struct WeatherProvider: TimelineProvider {
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(), temperature: 72)
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> ()) {
        completion(WeatherEntry(date: Date(), temperature: 72))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> ()) {
        Task {
            let temp = await fetchTemperature()
            let entry = WeatherEntry(date: Date(), temperature: temp)
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
            completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
        }
    }

    func fetchTemperature() async -> Double {
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=29.42&longitude=-98.49&current_weather=true")!

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let current = json?["current_weather"] as? [String: Any]
            return current?["temperature"] as? Double ?? 0
        } catch {
            return 0
        }
    }
}

struct WeatherWidgetEntryView: View {
    var entry: WeatherProvider.Entry

    var body: some View {
        VStack {
            Text("San Antonio")
                .font(.caption)
                .foregroundColor(.secondary)

            Text("\(Int(entry.temperature))°")
                .font(.system(size: 42, weight: .bold))
        }
        .padding()
    }
}

struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WeatherProvider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather")
        .description("Shows the current temperature in San Antonio.")
    }
}

// ---------------------------------------------------------
// NEWS WIDGET (YOUR KEY ADDED)
// ---------------------------------------------------------

struct NewsEntry: TimelineEntry {
    let date: Date
    let headline: String
}

struct NewsProvider: TimelineProvider {
    func placeholder(in context: Context) -> NewsEntry {
        NewsEntry(date: Date(), headline: "Loading…")
    }

    func getSnapshot(in context: Context, completion: @escaping (NewsEntry) -> ()) {
        completion(NewsEntry(date: Date(), headline: "Snapshot"))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NewsEntry>) -> ()) {
        Task {
            let headline = await fetchHeadline()
            let entry = NewsEntry(date: Date(), headline: headline)
            let nextUpdate = Date().addingTimeInterval(60 * 30)
            completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
        }
    }

    func fetchHeadline() async -> String {
        let apiKey = "3101f035edc84b7b8d511debb70914fe"
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)")!

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let articles = json?["articles"] as? [[String: Any]]
            return articles?.first?["title"] as? String ?? "No news available"
        } catch {
            return "Error loading news"
        }
    }
}

struct NewsWidgetEntryView: View {
    var entry: NewsProvider.Entry

    var body: some View {
        Text(entry.headline)
            .font(.headline)
            .padding()
    }
}

struct NewsWidget: Widget {
    let kind: String = "NewsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NewsProvider()) { entry in
            NewsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("News")
        .description("Shows the top US headline.")
    }
}

// ---------------------------------------------------------
// PHOTO WIDGET (YOUR UNSPLASH KEY ADDED)
// ---------------------------------------------------------

struct PhotoEntry: TimelineEntry {
    let date: Date
    let image: UIImage
}

struct PhotoProvider: TimelineProvider {
    func placeholder(in context: Context) -> PhotoEntry {
        PhotoEntry(date: Date(), image: UIImage(systemName: "photo")!)
    }

    func getSnapshot(in context: Context, completion: @escaping (PhotoEntry) -> ()) {
        completion(PhotoEntry(date: Date(), image: UIImage(systemName: "photo")!))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PhotoEntry>) -> ()) {
        Task {
            let img = await fetchImage()
            let entry = PhotoEntry(date: Date(), image: img)
            let nextUpdate = Date().addingTimeInterval(60 * 60)
            completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
        }
    }

    func fetchImage() async -> UIImage {
        let accessKey = "vJC7EagkXk0KAlwY0ZSoNpHHT8yg9BLIym6QPnzo5HQ"
        let url = URL(string: "https://api.unsplash.com/photos/random?client_id=\(accessKey)&orientation=squarish")!

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            if let urls = json?["urls"] as? [String: Any],
               let imageUrl = urls["small"] as? String,
               let finalURL = URL(string: imageUrl) {

                let (imgData, _) = try await URLSession.shared.data(from: finalURL)
                return UIImage(data: imgData) ?? UIImage(systemName: "photo")!
            }
        } catch {}

        return UIImage(systemName: "photo")!
    }
}

struct PhotoWidgetEntryView: View {
    var entry: PhotoProvider.Entry

    var body: some View {
        Image(uiImage: entry.image)
            .resizable()
            .scaledToFill()
            .clipped()
    }
}

struct PhotoWidget: Widget {
    let kind: String = "PhotoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PhotoProvider()) { entry in
            PhotoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Random Photo")
        .description("Shows a random photo from Unsplash.")
    }
}

// ---------------------------------------------------------
// WIDGET BUNDLE
// ---------------------------------------------------------

@main
struct LotusWidgets: WidgetBundle {
    var body: some Widget {
        WeatherWidget()
        NewsWidget()
        PhotoWidget()
    }
}
