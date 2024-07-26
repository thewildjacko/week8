//
//  ContentView.swift
//  week8
//
//  Created by Jake Smolowe on 7/25/24.
//

import SwiftUI

struct ContentView: View {
  @State var universityStore = UniversityStore()
  
    var body: some View {
      NavigationStack {
        VStack {
          List(universityStore.universityData.universities, id: \.id) { university in
            NavigationLink(destination: UniversityDetailView(university: university)) {
              Text(university.name)
            }
          }
        }
        .navigationTitle("Universities")
        .listStyle(.plain)
        .padding()
      }
    }
}

#Preview {
    ContentView()
}
