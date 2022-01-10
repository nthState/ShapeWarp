//
//  SubdividedShape.swift
//  PathWarp
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/PathWarp/blob/main/LICENSE for license information.
//


import SwiftUI

/// A custom shape that is build from a list of subdivided path elements
public struct SubdividedShape: Shape, Animatable {
  
  private var elements: [AnimatableElement]
  
  public init(elements: [AnimatableElement]) {
    self.elements = elements
  }
  
  public func path(in rect: CGRect) -> Path {
    var path = Path()
    
    
//    path.move(to: .zero)
//    for pt in allPoints {
//      path.addLine(to: pt)
//    }
//    path.closeSubpath()
    
    for element in elements {
      switch element.type {
      case .move(to: let to):
        path.move(to: CGPoint(x: element.to.first, y: element.to.second))
      case .line(to: let to):
        path.addLine(to:  CGPoint(x: element.to.first, y: element.to.second))
      case .quadCurve(to: let to, control: let control):
        path.addQuadCurve(to: to, control: control)
      case .curve(to: let to, control1: let control1, control2: let control2):
        path.addCurve(to: to, control1: control1, control2: control2)
      case .closeSubpath:
        path.closeSubpath()
      }
    }
    
    return path
  }
  
  public var animatableData: AnimatablePathElement {
    get { .init(elements: elements.map { AnimatableElement(type: $0.type, to: $0.to) }) }
    set { elements = newValue.elements.map { AnimatableElement(type: $0.type, to: $0.to) } }
  }
  
}
