//
//  ConvisionEntity.swift
//  Convision
//
//  Created by Zehua Chen on 1/9/25.
//
import Observation
import RealityKit

@Observable
final class ConvisionEntity: Entity, DebuggableEntity {
  static let defaultUpdateInterval = 1.0

  let dimension: Int

  /// Access pattern: `[x][y]`
  var entities: [[CellEntity]] = []

  var isRunning = false {
    didSet {
      if isRunning && !oldValue {
        // Start simulation
        self.components.set(SimulationComponent(updateInterval: Self.defaultUpdateInterval))
      } else if !isRunning && oldValue {
        // Stop simulation
        self.components.remove(SimulationComponent.self)
      }
    }
  }

  /// Don't use this initializer.
  required convenience init() {
    self.init(boundingBox: .empty)
  }

  init(
    boundingBox: BoundingBox,
    dimension: Int = 10,
    gap: Float = 0.01,
    cellScale: Float = 0.05
  ) {
    self.dimension = dimension

    super.init()

    let width = boundingBox.extents.x
    let height = boundingBox.extents.y

    let gridWidth = Self.numberOfCells(cellScale: cellScale, total: width, gap: gap)
    let gridHeight = Self.numberOfCells(cellScale: cellScale, total: height, gap: gap)

    for x in 0..<gridWidth {
      var row = [CellEntity]()

      for y in 0..<gridHeight {
        let cellEntity = CellEntity(scale: cellScale)
        cellEntity.name = "Cell(x: \(x) y: \(y))"

        row.append(cellEntity)
        addChild(cellEntity)
      }

      entities.append(row)
    }

    let cellLayoutComponent = CellLayoutComponent(
      grid: entities, parent: self, boundingBox: boundingBox, gap: gap)
    self.components.set(cellLayoutComponent)
    self.components.set(NeedsLayoutComponent())

    self.boundingBox = boundingBox
  }

  /// Where the cells can be placed.
  var boundingBox: BoundingBox {
    get { components[CellLayoutComponent.self]!.boundingBox }
    set { components[CellLayoutComponent.self]!.boundingBox = newValue }
  }

  static func numberOfCells(cellScale: Float, total: Float, gap: Float) -> Int {
    // x * cellScale + (x - 1) * gap = total
    // x * cellScale + x * gap - gap = total
    // x * (cellScale + gap) = total - gap
    // x = (total - gap) / (cellScale + gap)
    return Int(floor((total - gap) / (cellScale + gap)))
  }
}
