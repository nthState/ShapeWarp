////
////  ModifiableShape.swift
////  PathWarp
////
////  Copyright © 2022 Chris Davis, https://www.nthState.com
////
////  See https://github.com/nthState/PathWarp/blob/main/LICENSE for license information.
////
//
//import SwiftUI
//
////public struct ModifiableShape<S>: Shape, Animatable where S: Shape {
////
////  private let shapeContent: () -> S
////  private var path: Path
////
////  public init(@ViewBuilder shapeContent: @escaping () -> S) {
////    self.shapeContent = shapeContent
////
////    self.path = shapeContent()
////      .path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
////  }
////
////  public func path(in rect: CGRect) -> Path {
////    shapeContent()
////      .path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
////  }
////
////  public var animatableData: Path {
////      get {
////        path
////      }
////      set {
////        path = newValue
////      }
////  }
////
////}
//
////extension Path: VectorArithmetic {
////  public mutating func scale(by rhs: Double) {
////
////  }
////
////  public var magnitudeSquared: Double {
////
////  }
////
////  public static var zero: Path {
////
////  }
////}
//
////public struct PercentageAnimatableCircle: AnimatableModifier {
////    var path: Path
////  private var allPoints: [CGPoint]
////
////  public init(path: Path) {
////    self.path = path
////    self.foo = path.elements()
////  }
////
////  public var animatableData: [CGPoint] {
////      get { allPoints }
////      set { allPoints = newValue }
////  }
////
////  public func body(content: Content) -> some View {
////      ModifiableShape(isAnimating: true, path: path)
////    }
////}
//
////public struct ModifiableShape: View, Animatable {
////
////  private var path: Path
////
////  public init(path: Path) {
////    self.path = path
////  }
////
////  //public func body(content: Content) -> some View {
////  public var body: some View {
////    path
////  }
////
////  public var animatableData: Path {
////      get {
////        path
////      }
////      set {
////        path = newValue
////      }
////  }
////
////}
//
//
//public struct ModifiableShape: Shape, Animatable {
//
//  var points: [CGPoint]
//
//  public init(points: [CGPoint]) {
//    self.points = points
//  }
//
//  public func path(in rect: CGRect) -> Path {
//
////    return Path { p in
////      p.addPath(self.path)
////    }
//    Path { path in
//      path.move(to: .zero)
//      //let ct = count
//      for pt in points {
//      var j = 0
//      //for i in Int(count)..<Int(count)+5 {
//      //for i in 0..<5 {
//        //let pt = points[i]
//        path.addLine(to: pt)
//        j += 1
//      }
//      path.closeSubpath()
//    }
//
//  }
//
//  public var animatableData: AnimatableCGPoint {
//      get { .init(points: points.map { CGPoint.AnimatableData($0.x, $0.y) }) }
//      set { points = newValue.points.map { CGPoint(x: $0.first, y: $0.second) } }
//  }
//
//}
//
//
//public struct AnimatableCGPoint: VectorArithmetic {
//  var points: [CGPoint.AnimatableData]
//
//  public static func + (lhs: AnimatableCGPoint, rhs: AnimatableCGPoint) -> AnimatableCGPoint {
//      return add(lhs: lhs, rhs: rhs, +)
//  }
//
//  public static func - (lhs: AnimatableCGPoint, rhs: AnimatableCGPoint) -> AnimatableCGPoint {
//      return add(lhs: lhs, rhs: rhs, -)
//  }
//
//  static func add(lhs: AnimatableCGPoint, rhs: AnimatableCGPoint, _ sign: (CGFloat, CGFloat) -> CGFloat) -> AnimatableCGPoint {
//      let maxPoints = max(lhs.points.count, rhs.points.count)
//      let leftIndices = lhs.points.indices
//      let rightIndices = rhs.points.indices
//
//      var newPoints: [CGPoint.AnimatableData] = []
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
//
//      return .init(points: newPoints)
//  }
//
//  mutating public func scale(by rhs: Double) {
//      points.indices.forEach { index in
//          self.points[index].scale(by: rhs)
//      }
//  }
//
//  public var magnitudeSquared: Double {
//      return 1.0
//  }
//
//  public static var zero: AnimatableCGPoint {
//      return .init(points: [])
//  }
//}
//
//
//func Cartesian(length:Double, angle:Double) -> CGPoint {
//    return CGPoint(x: length * cos(angle), y: length * sin(angle))
//}
//
//public struct RegularPolygon: Shape {
//    var sides: Int
//    private var SidesDouble: Double
//
//    public var animatableData: Double {
//        get { return SidesDouble }
//        set { SidesDouble = newValue }
//    }
//
//    public init(sides: Int) {
//        self.sides = sides
//        self.SidesDouble = Double(sides)
//    }
//
//    public func path(in rect: CGRect) -> Path {
//        // centre of the containing rect
//        let c = CGPoint(x: rect.width/2.0, y: rect.height/2.0)
//        // radius of a circle that will fit in the rect
//        let r = Double(min(rect.width,rect.height)) / 2.0
//        let offsetAngle = (Double.pi / Double(SidesDouble)) + Double.pi/2.0
//        var vertices:[CGPoint] = []
//
//        let endAngle: Int = Double(SidesDouble) > Double(Int(SidesDouble)) ? Int(SidesDouble)+1 : Int(SidesDouble)
//        for i in 0..<endAngle{
//            // Calculate the angle in Radians
//            let angle = (2.0 * Double.pi * Double(i)/Double(SidesDouble)) + offsetAngle
//            let pt = Cartesian(length: r, angle: angle)
//            // move the point to the center of the rect and add to vertices
//            vertices.append(CGPoint(x: pt.x + c.x, y: pt.y + c.y))
//        }
//
//        var path = Path()
//        for (n, pt) in vertices.enumerated() {
//            n == 0 ? path.move(to: pt) : path.addLine(to: pt)
//        }
//        path.closeSubpath()
//        return path
//    }
//}
