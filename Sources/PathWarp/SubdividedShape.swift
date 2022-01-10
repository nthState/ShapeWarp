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
  
  private var allPoints: [CGPoint]
  private var elements: [Path.Element]
  
  public init(allPoints: [CGPoint], elements: [Path.Element]) {
    self.allPoints = allPoints
    self.elements = elements
  }
  
  public func path(in rect: CGRect) -> Path {
    var path = Path()
    
    for element in elements {
      switch element {
        
      case .move(to: let to):
        path.move(to: to)
      case .line(to: let to):
        path.addLine(to: to)
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
  
  public var animatableData: [CGPoint] {
      get { allPoints }
      set { allPoints = newValue }
  }
  
}

extension Path.Element: Animatable {
  
//  public var animatableData: Bool {
//      get {
//        self.
//      }
//      set {
//        elements = newValue
//      }
//  }
  
}
