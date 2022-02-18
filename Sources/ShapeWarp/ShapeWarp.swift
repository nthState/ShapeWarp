//
//  ShapeWarp.swift
//  ShapeWarp
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/ShapeWarp/blob/main/LICENSE for license information.
//

import SwiftUI

public extension Shape {
  
  /// Warp a shape's control points
  /// - Parameters:
  ///   - amount: How much to warp
  ///   - seed: pseudo-random seed to apply
  ///   - include: Act upon, control points, joints, or all
  /// - Returns: A new shape
  func warp(amount: CGFloat, seed: UInt64, include: PointType = .all) -> some Shape {
    return ShapeWarper(shape: self, amount: amount, seed: seed, include: include)
      .warp()
  }
  
}

/// The start/end of a line, or a control point for a line
public struct PointType: OptionSet {
  public let rawValue: Int
  
  /// Start/End of a line
  public static let joint = PointType(rawValue: 1)
  /// Control point for a bezier line
  public static let control = PointType(rawValue: 1 << 1)
  /// All type of points
  public static let all: PointType = [.joint, .control]
  
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
}

public struct ShapeWarper<S>: Animatable where S: Shape {
  
  let shape: S
  let amount: CGFloat
  let seed: UInt64
  let include: PointType
  
  var generator: PRNG
  
  /// Initalizes a PathWarp
  /// - Parameters:
  ///   - amount: How much to warp
  ///   - seed: pseudo-random seed to apply
  ///   - include: Act upon, control points, joints, or all
  public init(shape: S, amount: CGFloat, seed: UInt64, include: PointType) {
    self.shape = shape
    self.amount = amount
    self.seed = seed
    self.include = include

    self.generator = PRNG(seed: seed)
  }
  
  public func warp() -> some Shape {

    let elements = warpPoints()

    let animatableElements: [AnimatableElement] = elements.compactMap ({ element in
      switch element {
      case .move(to: let to):
        return AnimatableElement(type: .move(to: to), to: to.animatableData, control1: .zero, control2: .zero)
      case .line(to: let to):
        return AnimatableElement(type: .line(to: to), to: to.animatableData, control1: .zero, control2: .zero)
      case .quadCurve(to: let to, control: let control):
        return AnimatableElement(type: .quadCurve(to: to, control: control), to: to.animatableData, control1: control.animatableData, control2: control.animatableData)
      case .curve(to: let to, control1: let control1, control2: let control2):
        return AnimatableElement(type: .curve(to: to, control1: control1, control2: control2), to: to.animatableData, control1: control1.animatableData, control2: control2.animatableData)
      case .closeSubpath:
        return AnimatableElement(type: .closeSubpath, to:.zero, control1: .zero, control2: .zero)
      }
    })

    return SubdividedShape(elements: animatableElements)
  }
  
  private func warpPoints() -> [Path.Element] {
    
    let path = shape.path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    var elements: [Path.Element] = []
    
    var startPoint: CGPoint?
    
    path.forEach { element in
      switch element {
      case .move(to: let to):
        
        elements.append(.move(to: to))
        
        guard startPoint == nil else {
          return
        }
        
        startPoint = to
      case .line(to: let to):
        
        let toPoint = include.contains(.joint) ? warp(to, amount: self.amount) : to
        
        elements.append(Path.Element.line(to: toPoint))
        
      case .quadCurve(to: let to, control: let control):

        let toPoint = include.contains(.joint) ? warp(to, amount: self.amount) : to
        let controlPoint = include.contains(.control) ? warp(control, amount: self.amount) : control
        
        elements.append(.quadCurve(to: toPoint, control: controlPoint))
        
      case .curve(to: let to, control1: let control1, control2: let control2):
        
        let toPoint = include.contains(.joint) ? warp(to, amount: self.amount) : to
        let controlPoint1 = include.contains(.control) ? warp(control1, amount: self.amount) : control1
        let controlPoint2 = include.contains(.control) ? warp(control2, amount: self.amount) : control2
        
        elements.append(.curve(to: toPoint, control1: controlPoint1, control2: controlPoint2))
        
      case .closeSubpath:
        
        guard startPoint != nil else {
          return
        }
        
        elements.append(.closeSubpath)
      }
    }
    
    return elements
    
  }
  
}

// MARK: Randomness

extension ShapeWarper {
  
  func warp(_ point: CGPoint, amount: CGFloat) -> CGPoint {
    
    // TODO, can we move this elsewhere so it's hit once?
    guard amount > 0 else {
      return point
    }
    
    return CGPoint(x: point.x + CGFloat(generator.getRandomNumber(min: 0, max: UInt64(amount))),
                   y: point.y + CGFloat(generator.getRandomNumber(min: 0, max: UInt64(amount))))
  }
  
}
