import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MarketView()
                .tabItem { Label("Market", systemImage: "chart.bar.fill") }
            ChatView()
                .tabItem { Label("Chat", systemImage: "bubble.left.and.bubble.right.fill") }
        }
    }
}
