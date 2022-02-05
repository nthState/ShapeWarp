//
//  AnimatablePathElement.swift
//  PathWarp
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/PathWarp/blob/main/LICENSE for license information.
//

import SwiftUI

/// A container for Path.Element and making the points animatable
internal struct AnimatableElement: Equatable {
  let type: Path.Element
  var to: CGPoint.AnimatableData
  var control1: CGPoint.AnimatableData
  var control2: CGPoint.AnimatableData
  
  public static func == (lhs: AnimatableElement, rhs: AnimatableElement) -> Bool {
    lhs.to == rhs.to &&
    lhs.type == rhs.type &&
    lhs.control1 == rhs.control1 &&
    lhs.control2 == rhs.control2
  }
}

internal struct AnimatablePathElement: VectorArithmetic {
  
  var elements: [AnimatableElement]
  
  public static func + (lhs: AnimatablePathElement, rhs: AnimatablePathElement) -> AnimatablePathElement {
    return add(lhs: lhs, rhs: rhs, +)
  }
  
  public static func - (lhs: AnimatablePathElement, rhs: AnimatablePathElement) -> AnimatablePathElement {
    return add(lhs: lhs, rhs: rhs, -)
  }
  
  static func add(lhs: AnimatablePathElement, rhs: AnimatablePathElement, _ sign: (CGFloat, CGFloat) -> CGFloat) -> AnimatablePathElement {
    
    let maxPoints = max(lhs.elements.count, rhs.elements.count)
    let leftIndices = lhs.elements.indices
    let rightIndices = rhs.elements.indices
    
    var newElements: [AnimatableElement] = []
    
    (0 ..< maxPoints).forEach { index in
      if leftIndices.contains(index) && rightIndices.contains(index) {
        
        
        let lhsElement = lhs.elements[index]
        let rhsElement = rhs.elements[index]
        
        newElements.append(
          .init(type: lhsElement.type,
                to: .init(sign(lhsElement.to.first, rhsElement.to.first),
                          sign(lhsElement.to.second, rhsElement.to.second)
                         ),
                control1: .init(sign(lhsElement.control1.first, rhsElement.control1.first),
                                sign(lhsElement.control1.second, rhsElement.control1.second)
                               ),
                control2: .init(sign(lhsElement.control2.first, rhsElement.control2.first),
                                sign(lhsElement.control2.second, rhsElement.control2.second)
                               )
               )
        )
        
      } else if rightIndices.contains(index), let lastLeftElement = lhs.elements.last {
        // Right side has more points, collapse to last left point
        let lhsElement = lastLeftElement
        let rhsElement = rhs.elements[index]
        
        newElements.append(
          .init(type: lhsElement.type,
                to: .init(sign(lhsElement.to.first, rhsElement.to.first),
                          sign(lhsElement.to.second, rhsElement.to.second)
                         ),
                control1: .init(sign(lhsElement.control1.first, rhsElement.control1.first),
                          sign(lhsElement.control1.second, rhsElement.control1.second)
                         ),
                control2: .init(sign(lhsElement.control2.first, rhsElement.control2.first),
                          sign(lhsElement.control2.second, rhsElement.control2.second)
                         )
               )
        )
        
      } else if leftIndices.contains(index), let lastElement = newElements.last {
        // Left side has more points, collapse to last known point
        let lhsElement = lhs.elements[index]
        
        newElements.append(
          .init(type: lhsElement.type,
                to: .init(sign(lastElement.to.first, lhsElement.to.first),
                          sign(lastElement.to.second, lhsElement.to.second)
                         ),
                control1: .init(sign(lastElement.control1.first, lhsElement.control1.first),
                          sign(lastElement.control1.second, lhsElement.control1.second)
                         ),
                control2: .init(sign(lastElement.control2.first, lhsElement.control2.first),
                          sign(lastElement.control2.second, lhsElement.control2.second)
                         )
               )
        )
      }
    }

    return .init(elements: newElements)
  }
  
  mutating public func scale(by rhs: Double) {
      elements.indices.forEach { index in
        self.elements[index].to.scale(by: rhs)
        self.elements[index].control1.scale(by: rhs)
        self.elements[index].control2.scale(by: rhs)
      }
  }
  
  public var magnitudeSquared: Double {
    return 1.0
  }
  
  public static var zero: AnimatablePathElement {
    return .init(elements: [])
  }
  
  public static func == (lhs: AnimatablePathElement, rhs: AnimatablePathElement) -> Bool {
    lhs.elements == rhs.elements
  }
  
}
