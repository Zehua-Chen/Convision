//
//  ConvisionSystem.swift
//  Convision
//
//  Created by Zehua Chen on 1/9/25.
//
import OSLog
import RealityKit

struct SimulationSystem: System {
  private static let query = EntityQuery(
    where: .has(SimulationComponent.self) && .has(CellLayoutComponent.self))
  private static let logger = Logger(subsystem: "ECS", category: String(describing: Self.self))

  init(scene: Scene) {}

  func update(context: SceneUpdateContext) {
    for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
      var simulationComponent = entity.components[SimulationComponent.self]!
      let cellLayoutComponent = entity.components[CellLayoutComponent.self]!

      simulationComponent.secondsSinceLastUpdate += context.deltaTime

      if simulationComponent.secondsSinceLastUpdate > simulationComponent.updateInterval {
        simulate(cellLayout: cellLayoutComponent)
        simulationComponent.secondsSinceLastUpdate = 0
      }

      entity.components.set(simulationComponent)
    }
  }

  private func simulate(cellLayout: CellLayoutComponent) {
    Self.logger.info("Simulate!")
  }
}
