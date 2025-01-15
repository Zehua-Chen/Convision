//
//  ConvisionSystem.swift
//  Convision
//
//  Created by Zehua Chen on 1/9/25.
//
import OSLog
import RealityKit

struct SimulationSystem: System {
  private static let convisionComponentQuery = EntityQuery(where: .has(SimulationComponent.self))
  private static let logger = Logger(subsystem: "ECS", category: String(describing: Self.self))

  init(scene: Scene) {}

  func update(context: SceneUpdateContext) {
    for entity in context.entities(
      matching: Self.convisionComponentQuery, updatingSystemWhen: .rendering)
    {
      var convisionComponent = entity.components[SimulationComponent.self]!

      convisionComponent.secondsSinceLastUpdate += context.deltaTime

      if convisionComponent.secondsSinceLastUpdate > convisionComponent.updateInterval {
        Self.logger.info("\(type(of: entity)) update!")
        convisionComponent.secondsSinceLastUpdate = 0
      }

      entity.components.set(convisionComponent)

      // Only process one conway simulation
      return
    }
  }
}
