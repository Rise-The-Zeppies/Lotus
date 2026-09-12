import SwiftUI
import PhotosUI
import AppKit

// MARK: - Glass Background

struct Glass: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}

//////////////////////////////////////////////////////////////
// WEATHER
//////////////////////////////////////////////////////////////

struct WeatherWidget: View {
    var body: some View {
        ZStack {
            Glass()
            VStack(alignment: .leading, spacing: 8) {
                Text("Weather").font(.headline)
                Text("72° · Partly Cloudy").font(.title2)
                Text("San Antonio, TX")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .frame(width: 240, height: 140)
    }
}

//////////////////////////////////////////////////////////////
// CLOCK
//////////////////////////////////////////////////////////////

struct ClockWidget: View {
    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Glass()
            VStack(spacing: 6) {
                Text(DateFormatter.localizedString(from: now, dateStyle: .none, timeStyle: .medium))
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                Text(DateFormatter.localizedString(from: now, dateStyle: .medium, timeStyle: .none))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 260, height: 160)
        .onReceive(timer) { now = $0 }
    }
}

//////////////////////////////////////////////////////////////
// RECENT FILES
//////////////////////////////////////////////////////////////

struct RecentFilesWidget: View {
    var body: some View {
        ZStack {
            Glass()
            VStack(alignment: .leading, spacing: 6) {
                Text("Recent Files").font(.headline)
                Text("File1.txt").font(.caption)
                Text("File2.txt").font(.caption)
                Text("File3.txt").font(.caption)
            }
            .padding(16)
        }
        .frame(width: 240, height: 140)
    }
}

//////////////////////////////////////////////////////////////
// MUSIC PLAYER
//////////////////////////////////////////////////////////////

struct MusicPlayerWidget: View {
    var body: some View {
        ZStack {
            Glass()
            VStack(alignment: .leading, spacing: 8) {
                Text("Music Player").font(.headline)
                Text("Now Playing:").font(.caption).foregroundColor(.secondary)
                Text("Track Name – Artist").font(.subheadline)
            }
            .padding(16)
        }
        .frame(width: 240, height: 140)
    }
}

//////////////////////////////////////////////////////////////
// STOCKS
//////////////////////////////////////////////////////////////

struct StocksWidget: View {
    var body: some View {
        ZStack {
            Glass()
            VStack(alignment: .leading, spacing: 6) {
                Text("Stocks").font(.headline)
                Text("AAPL  189.23  +1.2%")
                Text("MSFT  412.87  +0.8%")
                Text("GOOG  142.11  -0.3%")
            }
            .font(.caption)
            .padding(16)
        }
        .frame(width: 240, height: 140)
    }
}

//////////////////////////////////////////////////////////////
// GAMES
//////////////////////////////////////////////////////////////

struct GamesWidget: View {
    var body: some View {
        ZStack {
            Glass()
            VStack(alignment: .leading, spacing: 8) {
                Text("Games").font(.headline)
                Text("• Snake")
                Text("• Tic-Tac-Toe (bot)")
            }
            .font(.caption)
            .padding(16)
        }
        .frame(width: 240, height: 140)
    }
}

//////////////////////////////////////////////////////////////
// AUDIO MIXER
//////////////////////////////////////////////////////////////

struct AudioMixerWidget: View {
    var body: some View {
        ZStack {
            Glass()
            VStack(alignment: .leading, spacing: 8) {
                Text("Audio Mixer").font(.headline)
                Slider(value: .constant(0.6))
                Slider(value: .constant(0.3))
                Slider(value: .constant(0.8))
            }
            .padding(16)
        }
        .frame(width: 240, height: 160)
    }
}

//////////////////////////////////////////////////////////////
// BOOKMARKS
//////////////////////////////////////////////////////////////

struct BookmarksWidget: View {
    var body: some View {
        ZStack {
            Glass()
            VStack(alignment: .leading, spacing: 6) {
                Text("Bookmarks").font(.headline)
                Text("• lotus.app")
                Text("• github.com")
                Text("• youtube.com")
            }
            .font(.caption)
            .padding(16)
        }
        .frame(width: 240, height: 140)
    }
}

//////////////////////////////////////////////////////////////
// SCREEN TIME
//////////////////////////////////////////////////////////////

struct ScreenTimeWidget: View {
    var body: some View {
        ZStack {
            Glass()
            VStack(alignment: .leading, spacing: 8) {
                Text("Screen Time").font(.headline)
                Text("Today: 4h 32m").font(.subheadline)
                Text("Most used: Browser, Editor")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .frame(width: 240, height: 140)
    }
}

//////////////////////////////////////////////////////////////
// PHOTOS
//////////////////////////////////////////////////////////////

struct PhotosWidget: View {
    @State private var photos: [UIImage] = []

    var body: some View {
        ZStack {
            Glass()
            VStack(alignment: .leading, spacing: 10) {
                Text("Photos").font(.headline)

                if photos.isEmpty {
                    Text("No photos loaded")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(photos, id: \.self) { img in
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                }

                Button("Load Photos") { loadPhotos() }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
            }
            .padding(16)
        }
        .frame(width: 260, height: 160)
    }

    private func loadPhotos() {
        let fetch = PHAsset.fetchAssets(with: .image, options: nil)
        var imgs: [UIImage] = []

        fetch.enumerateObjects { asset, _, _ in
            let manager = PHImageManager.default()
            let opts = PHImageRequestOptions()
            opts.isSynchronous = true

            manager.requestImage(
                for: asset,
                targetSize: CGSize(width: 200, height: 200),
                contentMode: .aspectFill,
                options: opts
            ) { image, _ in
                if let image = image { imgs.append(image) }
            }
        }

        DispatchQueue.main.async { self.photos = imgs }
    }
}

//////////////////////////////////////////////////////////////
// SYSTEM MONITOR (CPU/RAM)
//////////////////////////////////////////////////////////////

struct SystemMonitorWidget: View {
    var body: some View {
        ZStack {
            Glass()
            VStack(spacing: 8) {
                Text("System Monitor").font(.headline)
                Text("CPU: 23%")
                Text("RAM: 8.1 GB / 16 GB")
            }
            .padding(16)
        }
        .frame(width: 240, height: 140)
    }
}

//////////////////////////////////////////////////////////////
// APP LAUNCHER
//////////////////////////////////////////////////////////////

struct AppLauncherWidget: View {
    let apps = ["Safari", "Finder", "Terminal", "Notes"]

    var body: some View {
        ZStack {
            Glass()
            VStack(alignment: .leading, spacing: 8) {
                Text("App Launcher").font(.headline)
                ForEach(apps, id: \.self) { app in
                    Text("• \(app)")
                }
            }
            .padding(16)
        }
        .frame(width: 240, height: 160)
    }
}

//////////////////////////////////////////////////////////////
// KEYBOARD VIEWER
//////////////////////////////////////////////////////////////

struct KeyboardViewerWidget: View {
    var body: some View {
        ZStack {
            Glass()
            VStack(spacing: 10) {
                Text("Keyboard Viewer").font(.headline)
                Text("Press any key…")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .frame(width: 240, height: 140)
    }
}

//////////////////////////////////////////////////////////////
// NOTES
//////////////////////////////////////////////////////////////

struct NotesWidget: View {
    @State private var text = ""

    var body: some View {
        ZStack {
            Glass()
            VStack(alignment: .leading) {
                Text("Notes").font(.headline)
                TextEditor(text: $text)
                    .frame(height: 80)
                    .background(Color.clear)
            }
            .padding(16)
        }
        .frame(width: 260, height: 160)
    }
}

//////////////////////////////////////////////////////////////
// CALCULATOR
//////////////////////////////////////////////////////////////

struct CalculatorWidget: View {
    @State private var a = ""
    @State private var b = ""
    @State private var result = ""

    var body: some View {
        ZStack {
            Glass()
            VStack(spacing: 8) {
                Text("Calculator").font(.headline)
                TextField("A", text: $a)
                TextField("B", text: $b)
                Button("Add") {
                    if let x = Double(a), let y = Double(b) {
                        result = "\(x + y)"
                    }
                }
                Text("Result: \(result)")
            }
            .padding(16)
        }
        .frame(width: 240, height: 180)
    }
}

//////////////////////////////////////////////////////////////
// CALENDAR PEEK
//////////////////////////////////////////////////////////////

struct CalendarPeekWidget: View {
    var body: some View {
        ZStack {
            Glass()
            VStack(spacing: 8) {
                Text("Calendar Peek").font(.headline)
                Text("Wed, Sep 2, 2026")
                Text("Events: None")
            }
            .padding(16)
        }
        .frame(width: 240, height: 140)
    }
}

//////////////////////////////////////////////////////////////
// CLIPBOARD HISTORY
//////////////////////////////////////////////////////////////

struct ClipboardHistoryWidget: View {
    var body: some View {
        ZStack {
            Glass()
            VStack(alignment: .leading, spacing: 6) {
                Text("Clipboard History").font(.headline)
                Text("• Copied text 1")
                Text("• Copied text 2")
                Text("• Copied text 3")
            }
            .padding(16)
        }
        .frame(width: 240, height: 160)
    }
}

//////////////////////////////////////////////////////////////
// BATTERY & POWER
//////////////////////////////////////////////////////////////

struct BatteryPowerWidget: View {
    var body: some View {
        ZStack {
            Glass()
            VStack(spacing: 8) {
                Text("Battery & Power").font(.headline)
                Text("Battery: 87%")
                Text("Charging: Yes")
            }
            .padding(16)
        }
        .frame(width: 240, height: 140)
    }
}

//////////////////////////////////////////////////////////////
// WINDOW SWITCHER
//////////////////////////////////////////////////////////////

struct WindowSwitcherWidget: View {
    var body: some View {
        ZStack {
            Glass()
            VStack(alignment: .leading, spacing: 6) {
                Text("Window Switcher").font(.headline)
                Text("• Finder")
                Text("• Safari")
                Text("• Terminal")
            }
            .padding(16)
        }
        .frame(width: 240, height: 160)
    }
}

//////////////////////////////////////////////////////////////
// MINI GAMES HUB
//////////////////////////////////////////////////////////////

struct MiniGamesHubWidget: View {
    var body: some View {
        ZStack {
            Glass()
            VStack(spacing: 8) {
                Text("Mini Games Hub").font(.headline)
                Text("• Snake")
                Text("• Pong")
                Text("• Minesweeper")
            }
            .padding(16)
        }
        .frame(width: 240, height: 160)
    }
}
