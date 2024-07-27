//
//  UniversityListView.swift
//  week8
//
//  Created by Jake Smolowe on 7/27/24.
//

import SwiftUI

struct UniversityListView: View {
  @State var universityData: UniversityData?
  
  @ObservedObject private var downloader =
  UniversityDownloader()
  
  @MainActor @State private var downloadProgress: Float = 0.0
  @MainActor @State private var showUniversities = false
  
  var downloadLocation: URL? {
    return URL(string: "http://universities.hipolabs.com/search?country=United+States")
  }
  
  var body: some View {
    NavigationStack {
      VStack {
        if downloader.state == .paused || downloader.state == .downloading {
          ProgressView(value: downloader.downloadProgress)
        }
        if let data = downloader.universityData {
          List(data.universities, id: \.id) { university in
            NavigationLink(destination: UniversityDetailView(university: university)) {
              Text(university.name)
            }
          }
        } else {
          if downloader.state == .paused || downloader.state == .downloading {
            Text("Downloading...")
          } else if downloader.state == .failed {
            Text("Could not load data")
          }
        }
      }
      .navigationTitle("Universities")
      .listStyle(.plain)
      .padding()
      .onAppear(perform: {
        download()
      })
    }
  }
  
  private func download() {
    switch downloader.state {
      
    case .downloading:
      downloader.pause()
    case .paused:
      downloader.resume()
    case .failed, .waiting:
      guard let universitiesURL = downloadLocation else {
        return
      }
      
      downloader.downloadUniversities(at: universitiesURL)
      
    case .finished:
      showUniversities = true
    }
  }
}

#Preview {
  UniversityListView()
}
