//
//  CellStateSystem.swift
//  Convision
//
//  Created by Zehua Chen on 1/25/25.
//

import RealityKit

struct CellStateSystem: System {
  static let aliveMaterial = UnlitMaterial(color: .white)
  static let deadMaterial = UnlitMaterial(color: .gray)

  private static let query = EntityQuery(
    where: .has(CellStateComponent.self) && .has(ModelComponent.self))

  init(scene: Scene) {}

  func update(context: SceneUpdateContext) {
    for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
      guard var modelComponent = entity.components[ModelComponent.self] else { return }
      guard let cellStateComponent = entity.components[CellStateComponent.self] else { return }

      if cellStateComponent.isAlive {
        modelComponent.materials = [Self.aliveMaterial]
      } else {
        modelComponent.materials = [Self.deadMaterial]
      }

      entity.components.set(modelComponent)
    }
  }
}
