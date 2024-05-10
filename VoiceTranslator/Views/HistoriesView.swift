import SwiftUI

struct HistoriesView: View {
    @State private var selectedTab = 0

      var body: some View {
        ZStack(alignment: .top) {
          TabView(selection: $selectedTab) {
              AssistantHistoriesView()
              .tabItem { Label(LocalizedStringKey("assistant.view.title"), systemImage: "person.fill") }
              .tag(0)
              TranslateHistoriesView()
              .tabItem { Label(LocalizedStringKey("translate.view.title"), systemImage: "person.2.fill") }
              .tag(1)
          }
          .edgesIgnoringSafeArea(.all) // Ensures TabView fills entire area

          CustomTabBarView(selectedTab: $selectedTab) // Your custom tab bar view
        }
      }
}

struct CustomTabBarView: View {
  @Binding var selectedTab: Int

  var body: some View {
    HStack {
      Button(action: { selectedTab = 0 }) {
          Text("Assistant")
      }
      Spacer()
      Button(action: { selectedTab = 1 }) {
        Text("Translate")
      }
    }
    .frame(height: 40) // Adjust height as needed
    .background(Color.gray) // Set background color for the tab bar
  }
}

#Preview {
    HistoriesView()
}
