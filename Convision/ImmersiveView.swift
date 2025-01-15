//
//  ImmersiveView.swift
//  Convision
//
//  Created by Zehua Chen on 1/9/25.
//

import RealityKit
import SwiftUI

struct ImmersiveView: View {

  var body: some View {
    RealityView { content in
    }
  }
}

#Preview(immersionStyle: .mixed) {
  ImmersiveView()
    .environment(AppModel())
}
