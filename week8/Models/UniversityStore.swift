//
//  UniversityStore.swift
//  week8
//
//  Created by Jake Smolowe on 7/26/24.
//

import Foundation

class UniversityStore: ObservableObject {
  var universityData: UniversityData = UniversityData(
    universities: []
  ) {
    didSet {
      saveJSON()
    }
  }
  
  var downloadLocation: URL? {
    return URL(string: "http://universities.hipolabs.com/search?country=United+States")
  }
  
  let universityJSONURL = URL(fileURLWithPath: "university_data", relativeTo: FileManager.documentsDirectoryURL)
    .appendingPathExtension("json")
  
  init() {
    loadJSON()
  }
  
  private func loadJSON() {
    print(FileManager.documentsDirectoryURL)
    
    guard let universityJSONURL = Bundle.main.url(forResource: "university_data", withExtension: "json") else {
      print("File not in bundle")
      guard FileManager.default.fileExists(atPath: universityJSONURL.path) else {
        print("File doesn't exist")
        return
      }
      return
    }
    
    let decoder = JSONDecoder()
    
    do {
      let data = try Data(contentsOf: universityJSONURL)
      universityData = try decoder.decode(UniversityData.self, from: data)
      print("hello")
      print(universityData.universities.count)
      
    } catch let error {
      print("decoding error!")
      print(error)
    }
  }
  
  private func saveJSON() {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    
    do {
      let data = try encoder.encode(universityData)
      try data.write(to: universityJSONURL, options: .atomicWrite)
    } catch let error {
      print("encoding error")
      print(error)
    }
  }
}
