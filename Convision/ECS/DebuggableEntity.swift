//
//  DebuggableEntity.swift
//  Convision
//
//  Created by Zehua Chen on 1/11/25.
//
import RealityKit

protocol DebuggableEntity: Entity {
}

extension DebuggableEntity {
  func logVisualBounds(with label: String) {
    let visualBounds = visualBounds(recursive: false, relativeTo: nil)

    debugPrint("\(label)")
    debugPrint("extends = \(visualBounds.extents)")
  }
}
