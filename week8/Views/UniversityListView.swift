//
//  UniversityListView.swift
//  week8
//
//  Created by Jake Smolowe on 7/27/24.
//

import SwiftUI

struct UniversityListView: View {
  var universityStore: UniversityStore
  @State var universityData: UniversityData?
  
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
            return Text("View")
            
          case .paused:
            return Text("Resume")
            
          case .waiting:
            return Text("Download")
          }
        }
        
        if downloader.state == .paused || downloader.state == .downloading {
          ProgressView(value: downloader.downloadProgress)
        }
      }
      .navigationTitle("Universities")
      .listStyle(.plain)
      .padding()
      .onAppear(perform: {
//        downloader.downloadUniversities(at: URL(string: "http://universities.hipolabs.com/search?country=United+States")!)
//        universityData = downloader.universityData
      })
      .sheet(isPresented: $showUniversities) {
        if let data = downloader.universityData {
          List(data.universities, id: \.id) { university in
            NavigationLink(destination: UniversityDetailView(university: university)) {
              Text(university.name)
            }
          }
        } else {
          Text("Could not load data")
        }
      }
      
      List(universityStore.universityData.universities, id: \.id) { university in
        NavigationLink(destination: UniversityDetailView(university: university)) {
          Text(university.name)
        }
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
