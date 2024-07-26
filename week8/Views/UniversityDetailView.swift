//
//  UniversityDetailView.swift
//  week8
//
//  Created by Jake Smolowe on 7/26/24.
//

import SwiftUI

struct UniversityDetailView: View {
  var university: University
  
  var body: some View {
    VStack {
      Text(university.name)
        .font(.largeTitle)
      
      Form {
        Section {
          DetailRow(title: "Alpha Two Code:", text: university.alphaTwoCode)
          DetailRow(title: "Country:", text: university.country)
          DetailRow(title: "State/Province:", text: university.stateProvince ?? "not listed")
        }
        
        Section(header: (Text("Web Pages:"))) {
          List(university.webpages, id: \.self) { webpage in
            Link("\(webpage)", destination: URL(string: webpage)!)
          }
        }
        
        
        Section(header: (Text("Domains:"))) {
          List(university.domains, id: \.self) { domain in
            Text(domain)
          }
        }
        
      }
    }
    .padding()
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    UniversityDetailView(university: University(alphaTwoCode: "a2c", webpages: ["fakepage.com", "fakepage2.com"], country: "United States", domains: ["fakeuni.com", "fakeuni2.com"], name: "FakeUni", stateProvince: "California")
    )
  }
}
