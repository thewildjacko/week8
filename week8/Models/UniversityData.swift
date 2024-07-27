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
  
  enum UniversitiesKeys: String, CodingKey {
    case alphaTwoCode = "alpha_two_code"
    case webpages = "web_pages"
    case country
    case domains
    case name
    case stateProvince = "state-province"
  }
  
  func encode(to encoder: Encoder) throws {
    var universitiesContainer = encoder.unkeyedContainer()
    
    for university in universities {
      try universitiesContainer.encode(university)
    }
  }
}

extension UniversityData: Decodable {
  init(from decoder: Decoder) throws {
    var universitiesContainer = try decoder.unkeyedContainer()
    
    var universitiesArray: [University] = []
    
    while !universitiesContainer.isAtEnd {
      let universityContainer = try universitiesContainer.nestedContainer(keyedBy: UniversitiesKeys.self)
      
      let alphaTwoCode = try universityContainer.decode(String.self, forKey: .alphaTwoCode)
            
      var webpagesContainer = try universityContainer.nestedUnkeyedContainer(forKey: .webpages)
      var webpagesArray: [String] = []
      
      while !webpagesContainer.isAtEnd {
        let webpage = try webpagesContainer.decode(String.self)
        webpagesArray.append(webpage)
      }
      let webpages = webpagesArray
      
      let country = try universityContainer.decode(String.self, forKey: .country)

      var domainsContainer = try universityContainer.nestedUnkeyedContainer(forKey: .domains)
      var domainsArray: [String] = []
      
      while !domainsContainer.isAtEnd {
        let domain = try domainsContainer.decode(String.self)
        domainsArray.append(domain)
      }
      let domains = domainsArray
      
      let name = try universityContainer.decode(String.self, forKey: .name)
      let stateProvince = try universityContainer.decode(String?.self, forKey: .stateProvince)
      
      let university = University(alphaTwoCode: alphaTwoCode, webpages: webpages, country: country, domains: domains, name: name, stateProvince: stateProvince)
      universitiesArray.append(university)
    }
    
    universities = universitiesArray
  }
}


