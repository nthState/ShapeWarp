import SwiftUI

public struct AnimatableElement: Equatable {
  let type: Path.Element
  var to: CGPoint.AnimatableData
  
  public static func == (lhs: AnimatableElement, rhs: AnimatableElement) -> Bool {
    lhs.to == rhs.to && lhs.type == rhs.type
  }
}

public struct AnimatablePathElement: VectorArithmetic {
  
  //typealias PerElement = (String, CGPoint.AnimatableData)
  
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
                         )
               )
        )
      }
    }
    
    
    //      (0 ..< maxPoints).forEach { index in
    //          if leftIndices.contains(index) && rightIndices.contains(index) {
    //              // Merge points
    //              let lhsPoint = lhs.points[index]
    //              let rhsPoint = rhs.points[index]
    //              newPoints.append(
    //                  .init(
    //                      sign(lhsPoint.first, rhsPoint.first),
    //                      sign(lhsPoint.second, rhsPoint.second)
    //                  )
    //              )
    //          } else if rightIndices.contains(index), let lastLeftPoint = lhs.points.last {
    //              // Right side has more points, collapse to last left point
    //              let rightPoint = rhs.points[index]
    //              newPoints.append(
    //                  .init(
    //                      sign(lastLeftPoint.first, rightPoint.first),
    //                      sign(lastLeftPoint.second, rightPoint.second)
    //                  )
    //              )
    //          } else if leftIndices.contains(index), let lastPoint = newPoints.last {
    //              // Left side has more points, collapse to last known point
    //              let leftPoint = lhs.points[index]
    //              newPoints.append(
    //                  .init(
    //                      sign(lastPoint.first, leftPoint.first),
    //                      sign(lastPoint.second, leftPoint.second)
    //                  )
    //              )
    //          }
    //      }
    
    return .init(elements: newElements)
  }
  
  mutating public func scale(by rhs: Double) {
      elements.indices.forEach { index in
        self.elements[index].to.scale(by: rhs)
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
