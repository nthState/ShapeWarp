//
//  PathWarp.swift
//  PathWarp
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/PathWarp/blob/main/LICENSE for license information.
//

import SwiftUI

public extension Shape {

  func warp3(amount: CGFloat, seed: UInt64, include: Connection = .all) -> Path {
    return PathWarp3(shape: self, amount: amount, seed: seed, include: include)
      .warp()
      .path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
  }
  
}

private struct PathWarp3<S>: Animatable where S: Shape {
  
  let shape: S
  let amount: CGFloat
  let seed: UInt64
  let include: Connection
  
  var generator: PRNG
  
  init(shape: S, amount: CGFloat, seed: UInt64, include: Connection) {
    self.shape = shape
    self.amount = amount
    self.seed = seed
    self.include = include

    self.generator = PRNG(seed: seed)
  }
  
  public func warp() -> some Shape {
    
    let elements = warpPoints()
    
    let points = shape.path(in: CGRect(x: 0, y: 0, width: 100, height: 100)).allPoints()

    return SubdividedShape(allPoints: points, elements: elements)
  }
  
  private func warpPoints() -> [Path.Element] {
    
    let path = shape.path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    var elements: [Path.Element] = []
    
    var startPoint: CGPoint?
    var lastPoint: CGPoint = .zero
    
    path.forEach { element in
      switch element {
      case .move(to: let to):
        lastPoint = to
        
        elements.append(.move(to: to))
        
        guard startPoint == nil else {
          return
        }
        
        startPoint = to
      case .line(to: let to):
        
        let toPoint = include.contains(.joint) ? warp(to, amount: self.amount) : to
        
        elements.append(Path.Element.line(to: toPoint))
        
        lastPoint = toPoint
      case .quadCurve(to: let to, control: let control):
#warning("TODO: Chris to fill in")
        elements.append(.quadCurve(to: to, control: control))
        break
      case .curve(to: let to, control1: let control1, control2: let control2):
        
        let toPoint = include.contains(.joint) ? warp(to, amount: self.amount) : to
        let controlPoint1 = include.contains(.control) ? warp(control1, amount: self.amount) : control1
        let controlPoint2 = include.contains(.control) ? warp(control2, amount: self.amount) : control2
        
        elements.append(.curve(to: toPoint, control1: controlPoint1, control2: controlPoint2))
        
        lastPoint = toPoint
      case .closeSubpath:
        
        guard let to = startPoint else {
          return
        }
        
        elements.append(.closeSubpath)
        
        lastPoint = to
      }
    }
    
    return elements
    
  }
  
}

// MARK: Randomness

extension PathWarp3 {
  
  func warp(_ point: CGPoint, amount: CGFloat) -> CGPoint {
    
    return CGPoint(x: point.x + CGFloat(generator.getRandomNumber(min: 0, max: UInt64(amount))),
                   y: point.y + CGFloat(generator.getRandomNumber(min: 0, max: UInt64(amount))))
  }
  
}
