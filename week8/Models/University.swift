//
//  University.swift
//  week8
//
//  Created by Jake Smolowe on 7/26/24.
//

import Foundation

struct University: Encodable {
  var id = UUID()
  
  var alphaTwoCode: String
  var webpages: [String]
  var country: String
  var domains: [String]
  var name: String
  var stateProvince: String?
  
  enum CodingKeys: String, CodingKey {
    case alphaTwoCode = "alpha_two_code"
    case webpages = "web_pages"
    case country
    case domains
    case name
    case stateProvince = "state-province"
  }
  
  enum WebpageKeys: CodingKey {
    case webpage
  }
  
  enum DomainKeys: CodingKey {
    case domain
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(alphaTwoCode, forKey: .alphaTwoCode)
    
    var webpagesContainer = container.nestedUnkeyedContainer(forKey: .webpages)
    for webpage in webpages {
      try webpagesContainer.encode(webpage)
    }
    
    try container.encode(country, forKey: .country)
    
    var domainsContainer = container.nestedUnkeyedContainer(forKey: .webpages)
    for domain in domains {
      try domainsContainer.encode(domain)
    }
    
    try container.encode(name, forKey: .name)
    try container.encode(stateProvince, forKey: .stateProvince)
  }
}

extension University: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    alphaTwoCode = try container.decode(String.self, forKey: .alphaTwoCode)
        
    var webpagesContainer = try container.nestedUnkeyedContainer(forKey: .webpages)
    
    var webpagesArray: [String] = []
    
    while !webpagesContainer.isAtEnd {
      let webpageContainer = try webpagesContainer.nestedContainer(keyedBy: WebpageKeys.self)
      let webpage = try webpageContainer.decode(String.self, forKey: .webpage)
      webpagesArray.append(webpage)
    }
      
    webpages = webpagesArray

    country = try container.decode(String.self, forKey: .country)
    
    var domainsContainer = try container.nestedUnkeyedContainer(forKey: .domains)
    
    var domainsArray: [String] = []

    while !domainsContainer.isAtEnd {
      let domainContainer = try domainsContainer.nestedContainer(keyedBy: DomainKeys.self)
      let domain = try domainContainer.decode(String.self, forKey: .domain)
      domainsArray.append(domain)
    }
      
    domains = domainsArray
    
    name = try container.decode(String.self, forKey: .name)
    stateProvince = try container.decode(String.self, forKey: .stateProvince)
  }
}
