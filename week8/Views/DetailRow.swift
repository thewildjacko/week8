//
//  DetailRow.swift
//  week8
//
//  Created by Jake Smolowe on 7/26/24.
//

import SwiftUI

struct DetailRow: View {
  var title: String
  var text: String
  
  var body: some View {
    HStack {
      Text(title)
      Spacer()
      Text(text)
    }
  }
}


#Preview {
    DetailRow(title: "Title", text: "Name")
}
