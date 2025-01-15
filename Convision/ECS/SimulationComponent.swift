//
//  ConvisionComponent.swift
//  Convision
//
//  Created by Zehua Chen on 1/9/25.
//
import RealityKit

struct SimulationComponent: Component {
  var updateInterval: Double
  var secondsSinceLastUpdate: Double = 0
}
