//
//  UniversityData.swift
//  week8
//
//  Created by Jake Smolowe on 7/26/24.
//

import Foundation

struct UniversityData: Encodable {
  var universities: [University]
  
  enum CodingKeys: CodingKey {
    case universities
  }
  
  enum UniversitiesKeys: CodingKey {
    case alphaTwoCode, webPages, country, domains, name, stateProvince
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    var universitysContainer = container.nestedUnkeyedContainer(forKey: .universities)
    
    for university in universities {
      var universityContainer = universitysContainer.nestedContainer(keyedBy: UniversitiesKeys.self)
      
      try universityContainer.encode(university.alphaTwoCode, forKey: .alphaTwoCode)
      try universityContainer.encode(university.webPages, forKey: .webPages)
      try universityContainer.encode(university.country, forKey: .country)
      try universityContainer.encode(university.domains, forKey: .domains)
      try universityContainer.encode(university.name, forKey: .name)
      try universityContainer.encode(university.stateProvince, forKey: .stateProvince)
    }
  }
}

extension UniversityData: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    var universitiesContainer = try container.nestedUnkeyedContainer(forKey: .universities)
    
    var universitiesArray: [University] = []
    
    while !universitiesContainer.isAtEnd {
      let universityContainer = try universitiesContainer.nestedContainer(keyedBy: UniversitiesKeys.self)
      let alphaTwoCode = try universityContainer.decode(String.self, forKey: .alphaTwoCode)
      let webPages = try universityContainer.decode([String].self, forKey: .webPages)
      let country = try universityContainer.decode(String.self, forKey: .country)
      let domains = try universityContainer.decode([String].self, forKey: .domains)
      let name = try universityContainer.decode(String.self, forKey: .name)
      let stateProvince = try universityContainer.decode(String?.self, forKey: .stateProvince)
      let university = University(alphaTwoCode: alphaTwoCode, webPages: webPages, country: country, domains: domains, name: name, stateProvince: stateProvince)
      universitiesArray.append(university)
    }
    
    universities = universitiesArray
  }
}


