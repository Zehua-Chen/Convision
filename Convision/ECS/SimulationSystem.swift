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
    for (x, column) in cellLayout.grid.enumerated() {
      for (y, cell) in column.enumerated() {
        var cellStateComponent = cell.components[CellStateComponent.self]!

        let aliveNeighborCount = neighbors(forX: x, y: y, in: cellLayout.grid)
          .map { $0.components[CellStateComponent.self]! }
          .map { $0.isAlive }
          .reduce(into: 0) { result, isAlive in
            if isAlive {
              result += 1
            }
          }

        if cellStateComponent.isAlive {
          if aliveNeighborCount < 2 {
            cellStateComponent.isGoingToBeAlive = false
          } else if aliveNeighborCount == 2 || aliveNeighborCount == 3 {
            cellStateComponent.isGoingToBeAlive = true
          } else {
            cellStateComponent.isGoingToBeAlive = false
          }
        } else {
          cellStateComponent.isGoingToBeAlive = aliveNeighborCount == 3
        }

        cell.components.set(cellStateComponent)
      }
    }
  }

  func neighbors(forX x: Int, y: Int, in grid: [[CellEntity]]) -> [CellEntity] {
    guard grid.width > 0 else { return [] }
    guard grid.height > 0 else { return [] }

    var neighbors: [CellEntity] = []

    // Check all 8 adjacent positions
    for dx in -1...1 {
      for dy in -1...1 {
        // Skip the cell itself
        if dx == 0 && dy == 0 { continue }

        let newX = x + dx
        let newY = y + dy

        // Check bounds
        if newX >= 0 && newX < grid.width && newY >= 0 && newY < grid.height {
          neighbors.append(grid[newX][newY])
        }
      }
    }

    return neighbors
  }
}
