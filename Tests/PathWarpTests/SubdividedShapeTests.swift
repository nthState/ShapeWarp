//
//  SubdividedShape.swift
//  PathWarp
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/PathWarp/blob/main/LICENSE for license information.
//

import XCTest
@testable import PathWarp

class SubdividedShapeTests: XCTestCase {
  
  func test_elements_make_path() throws {
    
    let elements: [AnimatableElement] = [
      AnimatableElement(type: .move(to: .zero), to: .zero, control1: .zero, control2: .zero),
      AnimatableElement(type: .line(to: CGPoint(x: 0, y: 100)), to: aPoint(CGPoint(x: 0, y: 100)), control1: .zero, control2: .zero)
    ]
    
    let shape = SubdividedShape(elements: elements)
    
    let actual = shape.path(in: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
    
    XCTAssertEqual(String(describing: actual), String(describing: "0 0 m 0 100 l"), "Path should match")
  }
  
  func aPoint(_ point: CGPoint) -> CGPoint.AnimatableData {
    CGPoint.AnimatableData(point.x, point.y)
  }
  
}
