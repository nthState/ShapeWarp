//
//  ModifiableShape.swift
//  PathWarp
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/PathWarp/blob/main/LICENSE for license information.
//

import SwiftUI

//public struct ModifiableShape<S>: Shape, Animatable where S: Shape {
//
//  private let shapeContent: () -> S
//  private var path: Path
//
//  public init(@ViewBuilder shapeContent: @escaping () -> S) {
//    self.shapeContent = shapeContent
//
//    self.path = shapeContent()
//      .path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
//  }
//
//  public func path(in rect: CGRect) -> Path {
//    shapeContent()
//      .path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
//  }
//
//  public var animatableData: Path {
//      get {
//        path
//      }
//      set {
//        path = newValue
//      }
//  }
//
//}

//extension Path: VectorArithmetic {
//  public mutating func scale(by rhs: Double) {
//    
//  }
//  
//  public var magnitudeSquared: Double {
//    
//  }
//  
//  public static var zero: Path {
//    
//  }
//}

//public struct PercentageAnimatableCircle: AnimatableModifier {
//    var path: Path
//  private var allPoints: [CGPoint]
//
//  public init(path: Path) {
//    self.path = path
//    self.foo = path.elements()
//  }
//
//  public var animatableData: [CGPoint] {
//      get { allPoints }
//      set { allPoints = newValue }
//  }
//
//  public func body(content: Content) -> some View {
//      ModifiableShape(isAnimating: true, path: path)
//    }
//}

//public struct ModifiableShape: View, Animatable {
//
//  private var path: Path
//
//  public init(path: Path) {
//    self.path = path
//  }
//
//  //public func body(content: Content) -> some View {
//  public var body: some View {
//    path
//  }
//
//  public var animatableData: Path {
//      get {
//        path
//      }
//      set {
//        path = newValue
//      }
//  }
//
//}

public struct ModifiableShape: Shape, Animatable {

  private var allPoints: [CGPoint]
  private var path: Path

  public init(allPoints: [CGPoint], path: Path) {
    self.allPoints = allPoints
    self.path = path
  }

  public func path(in rect: CGRect) -> Path {
    let _ = path.allElements()
    return Path { p in
      p.addPath(self.path)
    }
  }

  public var animatableData: [CGPoint] {
      get { allPoints }
      set { allPoints = newValue }
  }
  
//  var animatableData: AnimatablePair<Path, Bool> {
//    get { AnimatablePair(path, isAnimating) }
//    set { (path, isAnimating) = (newValue.first, newValue.second) }
//  }

}

func Cartesian(length:Double, angle:Double) -> CGPoint {
    return CGPoint(x: length * cos(angle), y: length * sin(angle))
}

public struct RegularPolygon: Shape {
    var sides: Int
    private var SidesDouble: Double

    public var animatableData: Double {
        get { return SidesDouble }
        set { SidesDouble = newValue }
    }

    public init(sides: Int) {
        self.sides = sides
        self.SidesDouble = Double(sides)
    }

    public func path(in rect: CGRect) -> Path {
        // centre of the containing rect
        let c = CGPoint(x: rect.width/2.0, y: rect.height/2.0)
        // radius of a circle that will fit in the rect
        let r = Double(min(rect.width,rect.height)) / 2.0
        let offsetAngle = (Double.pi / Double(SidesDouble)) + Double.pi/2.0
        var vertices:[CGPoint] = []

        let endAngle: Int = Double(SidesDouble) > Double(Int(SidesDouble)) ? Int(SidesDouble)+1 : Int(SidesDouble)
        for i in 0..<endAngle{
            // Calculate the angle in Radians
            let angle = (2.0 * Double.pi * Double(i)/Double(SidesDouble)) + offsetAngle
            let pt = Cartesian(length: r, angle: angle)
            // move the point to the center of the rect and add to vertices
            vertices.append(CGPoint(x: pt.x + c.x, y: pt.y + c.y))
        }

        var path = Path()
        for (n, pt) in vertices.enumerated() {
            n == 0 ? path.move(to: pt) : path.addLine(to: pt)
        }
        path.closeSubpath()
        return path
    }
}
