//
//  ContentView.swift
//  Convision
//
//  Created by Zehua Chen on 1/9/25.
//

import RealityKit
import SwiftUI

struct ContentView: View {
  @State private var enlarge = false
  @State private var convisionEntity: ConvisionEntity?

  var body: some View {
    GeometryReader3D { geometry in
      RealityView { content in
        // Compute the size of the yellow box in entity hierarchy debugger.
        let boundingBox = content.convert(
          geometry.frame(in: .local), from: .local, to: content)

        convisionEntity = ConvisionEntity(boundingBox: boundingBox)
        content.add(convisionEntity!)
        convisionEntity!.boundingBox = boundingBox
      } update: { content in
        convisionEntity?.boundingBox = content.convert(
          geometry.frame(in: .local), from: .local, to: content)
      }
      .gesture(
        TapGesture()
          .targetedToAnyEntity()
          .onEnded { value in
            let entity = value.entity

            guard var cellStateComponent = entity.components[CellStateComponent.self] else {
              return
            }

            cellStateComponent.isGoingToBeAlive = true
            entity.components.set(cellStateComponent)
          }
      )
      .toolbar {
        ToolbarItemGroup(placement: .bottomOrnament) {
          Button {
            convisionEntity?.start()
          } label: {
            Text("Start")
          }
          .disabled(convisionEntity == nil)
        }
      }
    }
  }
}

#Preview(windowStyle: .volumetric) {
  ContentView()
    .environment(AppModel())
}
