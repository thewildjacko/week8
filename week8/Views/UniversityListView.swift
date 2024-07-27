//
//  UniversityListView.swift
//  week8
//
//  Created by Jake Smolowe on 7/27/24.
//

import SwiftUI

struct UniversityListView: View {
  var universityStore: UniversityStore
  
  @ObservedObject private var downloader =
  UniversityDownloader()
  
  @MainActor @State private var downloadProgress: Float = 0.0
  @MainActor @State private var showUniversities = false
  
  var body: some View {
    NavigationStack {
      VStack {
        Button<Text>(action: downloadTapped) {
          switch downloader.state {
          case .downloading:
            return Text("Pause")

          case .failed:
            return Text("Retry")
            
          case .finished:
            return Text("Listen")
            
          case .paused:
            return Text("Resume")
            
          case .waiting:
            return Text("Download")
          }
        }
        
        if downloader.state == .paused || downloader.state == .downloading {
          ProgressView(value: downloader.downloadProgress)
      }
        
        List(universityStore.universityData.universities, id: \.id) { university in
          NavigationLink(destination: UniversityDetailView(university: university)) {
            Text(university.name)
          }
        }
      }
      .navigationTitle("Universities")
      .listStyle(.plain)
      .padding()
      .sheet(isPresented: $showUniversities) {
        
      }
      
    }
  }
  
  private func downloadTapped() {
    switch downloader.state {
      
    case .downloading:
      downloader.pause()
    case .paused:
      downloader.resume()
    case .failed, .waiting:
      guard let universitiesURL = universityStore.downloadLocation else {
        return
      }
      
      downloader.downloadUniversities(at: universitiesURL)
      
    case .finished:
      showUniversities = true
    }
  }
}

#Preview {
  UniversityListView(universityStore: UniversityStore())
}
