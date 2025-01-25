//
//  CellLayoutComponent.swift
//  Convision
//
//  Created by Zehua Chen on 1/11/25.
//
import RealityKit

struct CellLayoutComponent: Component {
  /// Access pattern: `[x][y]`
  var grid: [[CellEntity]]
  var parent: Entity
  var boundingBox: BoundingBox

  var gap: Float
}

extension [[CellEntity]] {
  var width: Int { count }

  var height: Int {
    if width > 0 {
      return self[0].count
    }

    return -1
  }
}
