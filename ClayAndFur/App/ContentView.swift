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
            
            ClayBodiesListView()
                .tabItem {
                    Image(systemName: "cube")
                    Text("Clay Bodies")
                }
                .tag(2)
            
            GlazesListView()
                .tabItem {
                    Image(systemName: "paintbrush")
                    Text("Glazes")
                }
                .tag(3)
            
            FiringsListView()
                .tabItem {
                    Image(systemName: "flame")
                    Text("Firings")
                }
                .tag(4)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(5)
        }
        .accentColor(.orange)
    }
}