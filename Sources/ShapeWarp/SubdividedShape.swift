//
//  SubdividedShape.swift
//  ShapeWarp
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/ShapeWarp/blob/main/LICENSE for license information.
//


import SwiftUI

/// A custom shape that is build from a list of subdivided path elements
internal struct SubdividedShape: Shape, Animatable {
  
  private var elements: [AnimatableElement]
  
  internal init(elements: [AnimatableElement]) {
    self.elements = elements
  }
  
  internal func path(in rect: CGRect) -> Path {
    var path = Path()

    for element in elements {
      switch element.type {
      case .move(to: _):
        path.move(to: CGPoint(element.to))
      case .line(to: _):
        path.addLine(to:  CGPoint(element.to))
      case .quadCurve(to: _, control: _):
        path.addQuadCurve(to: CGPoint(element.to), control: CGPoint(element.control1))
      case .curve(to: _, control1: _, control2: _):
        path.addCurve(to: CGPoint(element.to), control1: CGPoint(element.control1), control2: CGPoint(element.control2))
      case .closeSubpath:
        path.closeSubpath()
      }
    }
    
    return path
  }
  
  public var animatableData: AnimatablePathElement {
    get {
      .init(elements: elements.map {
        AnimatableElement(type: $0.type,
                          to: $0.to,
                          control1: $0.control1,
                          control2: $0.control2)
      })
    }
    set {
      elements = newValue.elements.map {
        AnimatableElement(type: $0.type,
                          to: $0.to,
                          control1: $0.control1,
                          control2: $0.control2)
      }
    }
  }
  
}
