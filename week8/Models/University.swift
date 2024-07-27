//
//  University.swift
//  week8
//
//  Created by Jake Smolowe on 7/26/24.
//

import Foundation

struct University {
  var id = UUID()
  
  var alphaTwoCode: String
  var webpages: [String]
  var country: String
  var domains: [String]
  var name: String
  var stateProvince: String?
}

extension University: Identifiable, Codable {
  enum CodingKeys: String, CodingKey {
    case alphaTwoCode = "alpha_two_code"
    case webpages = "web_pages"
    case country
    case domains
    case name
    case stateProvince = "state-province"
  }
}
