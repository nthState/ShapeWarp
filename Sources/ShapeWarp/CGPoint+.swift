//
//  CGPoint+.swift
//  ShapeWarp
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/ShapeWarp/blob/main/LICENSE for license information.
//

import CoreGraphics

internal extension CGPoint {
  
  init(_ animatablePoint: CGPoint.AnimatableData) {
    self = CGPoint(x:animatablePoint.first, y: animatablePoint.second)
  }
  
}
