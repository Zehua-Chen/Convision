//
//  CellEntity.swift
//  Convision
//
//  Created by Zehua Chen on 1/10/25.
//
import RealityKit

class CellEntity: Entity, DebuggableEntity {
  /// Don't use this initializer!
  required convenience init() {
    self.init(scale: .zero)
  }

  init(scale: Float) {
    super.init()

    let boxMesh = MeshResource.generateBox(size: 1.0)
    let material = UnlitMaterial(color: .gray)

    let modelComponent = ModelComponent(mesh: boxMesh, materials: [material])

    self.components.set(modelComponent)
    self.scale = SIMD3<Float>(repeating: scale)
  }
}
