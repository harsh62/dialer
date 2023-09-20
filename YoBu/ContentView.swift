//
//  ContentView.swift
//  YoBu
//
//  Created by Singh, Harshdeep on 2023-09-18.
//

import SwiftUI

struct ContentView: View {

    @State private var selectedTabIndex = 0



    var body: some View {

        TabView(selection: $selectedTabIndex) {
            VStack {
                Button(action: {
                    print("Circular Button tapped")
                    selectedTabIndex = Int.random(in: 0...2)
                }) {
                    Text("Call")
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.white)
                        .background(Color.green)
                        .clipShape(Circle())
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)

            Text("Search")
                .tabItem {

                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)

            Text("Notification")
                .tabItem {
                    Label("Notification", systemImage: "bell")
                }
                .tag(2)

            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(3)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
