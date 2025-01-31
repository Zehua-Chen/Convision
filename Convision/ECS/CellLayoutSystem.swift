//
//  CellLayoutSystem.swift
//  Convision
//
//  Created by Zehua Chen on 1/11/25.
//
import RealityKit
import Spatial

struct CellLayoutSystem: System {
  static let query = EntityQuery(
    where: .has(CellLayoutComponent.self) && .has(NeedsLayoutComponent.self))

  init(scene: Scene) {}

  func update(context: SceneUpdateContext) {
    for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
      entity.components.remove(NeedsLayoutComponent.self)
      let cellLayout = entity.components[CellLayoutComponent.self]!

      for (x, row) in cellLayout.grid.enumerated() {
        for (y, cell) in row.enumerated() {
          let cellSizeX = cell.scale.x
          let cellSizeY = cell.scale.y

          // Apply transformations in the following order:
          // 1. Scale to create gaps between cells
          // 2. Center each cell by offsetting by half its size
          // 3. Move to the bounding box origin (starting position for the grid)
          let transformation = AffineTransform3D.identity
            // Move to the bounding box origin (starting position for the grid)
            .translated(
              by: Vector3D(
                x: cellLayout.boundingBox.min.x, y: cellLayout.boundingBox.min.y, z: 0)
            )
            // Center each cell by offsetting by half its size
            .translated(by: Vector3D(x: cellSizeX / 2.0, y: cellSizeY / 2.0, z: 0))
            // Scale to create gaps between cells
            // Each cell position will be multiplied by (size + gap) to create spacing
            .scaled(
              by: Size3D(
                width: cellLayout.gap + cellSizeX, height: cellLayout.gap + cellSizeY, depth: 1))

          // Convert cell grid coordinates (x,y) to scene space
          let cellSpacePosition = SIMD4<Float>(Float(x), Float(y), 0, 1)
          let sceneSpacePosition = float4x4(transformation) * cellSpacePosition

          cell.setPosition(
            [sceneSpacePosition.x, sceneSpacePosition.y, sceneSpacePosition.z],
            relativeTo: cellLayout.parent)
        }
      }
    }
  }
}
