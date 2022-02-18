//
//  SubdividedShape.swift
//  PathWarp
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/ShapeWarp/blob/main/LICENSE for license information.
//

import XCTest
import SwiftUI
@testable import ShapeWarp

final class ShapeWarpTests: XCTestCase {
  
  func test_zero_settings_has_no_affect() throws {
    
    let rect = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
    
    let actual = Rectangle()
      .warp(amount: 0, seed: 94578)
      .path(in: rect)
    
    let matchRectange = Rectangle()
      .path(in: rect)
    
    XCTAssertEqual(actual.description, matchRectange.description, "Shapes should match")
  }
  
  func test_zero_settings_has_affect() throws {
    
    let rect = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
    
    let actual = Rectangle()
      .warp(amount: 14, seed: 94578)
      .path(in: rect)
    
    let matchRectange = Rectangle()
      .path(in: rect)
    
    XCTAssertNotEqual(actual.description, matchRectange.description, "Shapes shouldn't match")
  }
  
}
