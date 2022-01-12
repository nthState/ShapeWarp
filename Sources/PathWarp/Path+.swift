//
//  Path+.swift
//  PathWarp
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/PathWarp/blob/main/LICENSE for license information.
//

import SwiftUI

internal extension Path {
  
  func allElements() -> [Path.Element] {
    var elements: [Path.Element] = []
    self.forEach { element in
      elements.append(element)
    }
    return elements
  }
  
}

//public extension Path {
//
//  func allPoints() -> [CGPoint] {
//    var points: [CGPoint] = []
//    self.forEach { element in
//      switch element {
//      case .move(to: let to):
//        points.append(to)
//      case .line(to: let to):
//        points.append(to)
//      case .quadCurve(to: let to, control: let control):
//        points.append(to)
//        points.append(control)
//      case .curve(to: let to, control1: let control1, control2: let control2):
//        points.append(to)
//        points.append(control1)
//        points.append(control2)
//      case .closeSubpath:
//        break
//      }
//    }
//    return points
//  }
//
//}
