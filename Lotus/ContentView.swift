import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // Tahoe-style background
            LinearGradient(
                colors: [
                    Color.black.opacity(0.7),
                    Color.blue.opacity(0.4)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    WeatherWidget()
                    ClockWidget()
                    RecentFilesWidget()
                }

                HStack(spacing: 20) {
                    MusicPlayerWidget()
                    StocksWidget()
                    GamesWidget()
                }

                HStack(spacing: 20) {
                    AudioMixerWidget()
                    BookmarksWidget()
                    ScreenTimeWidget()
                }
            }
            .padding(24)
        }
    }
}
