//
//  University.swift
//  week8
//
//  Created by Jake Smolowe on 7/26/24.
//

import Foundation

struct University: Codable {
  var id = UUID()
  
  var alphaTwoCode: String
  var webPages: [String]
  var country: String
  var domains: [String]
  var name: String
  var stateProvince: String?
}
