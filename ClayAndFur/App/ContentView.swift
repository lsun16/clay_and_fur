import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Dashboard")
                }
                .tag(0)
            
            PiecesListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Pieces")
                }
                .tag(1)
            
            GlazesListView()
                .tabItem {
                    Image(systemName: "paintbrush")
                    Text("Glazes")
                }
                .tag(2)
            
            FiringsListView()
                .tabItem {
                    Image(systemName: "flame")
                    Text("Firings")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(.orange)
    }
}