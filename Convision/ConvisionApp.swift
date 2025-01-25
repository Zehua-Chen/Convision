//
//  ConvisionApp.swift
//  Convision
//
//  Created by Zehua Chen on 1/9/25.
//

import SwiftUI

@main
struct ConvisionApp: App {

  @State private var appModel = AppModel()

  init() {
    CellLayoutComponent.registerComponent()
    CellStateComponent.registerComponent()
    NeedsLayoutComponent.registerComponent()
    SimulationComponent.registerComponent()

    CellLayoutSystem.registerSystem()
    CellStateSystem.registerSystem()
    SimulationSystem.registerSystem()
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(appModel)
    }
    .windowStyle(.volumetric)

    ImmersiveSpace(id: appModel.immersiveSpaceID) {
      ImmersiveView()
        .environment(appModel)
        .onAppear {
          appModel.immersiveSpaceState = .open
        }
        .onDisappear {
          appModel.immersiveSpaceState = .closed
        }
    }
    .immersionStyle(selection: .constant(.mixed), in: .mixed)
  }
}
