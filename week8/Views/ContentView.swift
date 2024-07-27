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
    UniversityListView(universityStore: universityStore)
  }
}

#Preview {
  ContentView()
}
