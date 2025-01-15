//
//  CellLayoutComponent.swift
//  Convision
//
//  Created by Zehua Chen on 1/11/25.
//
import RealityKit

struct CellLayoutComponent: Component {
  /// Access pattern: `[x][y]`
  var cells: [[CellEntity]]
  var parent: Entity
  var boundingBox: BoundingBox

  var gap: Float
}
