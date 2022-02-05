//
//  CGPoint+.swift
//  PathWarp
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/PathWarp/blob/main/LICENSE for license information.
//

import SwiftUI

struct ExampleSwiftUIView {
  @State var isAnimating: Bool = false
}

extension ExampleSwiftUIView: View {
  
  var body: some View {
    VStack(spacing: 24) {
      test1
//      test2
//      test3
//      controls
    }
  }
  
  var test1: some View {
    Rectangle()
      .warp(amount: 10, seed: 0987654321)
      .stroke(Color.red, lineWidth: 2)
      .frame(width: 100, height: 100)
  }
  
  var test2: some View {
    Circle()
      .warp(amount: 20, seed: isAnimating ? 838281828383 : 75534253334, include: .control)
      .fill(Color.blue)
      .frame(width: 100, height: 100)
  }
  
  var test3: some View {
    Rectangle()
      .warp(amount: isAnimating ? 30 : 20, seed: 11225544338877557788)
      .fill(Color.green)
      .frame(width: 100, height: 100)
  }
  
  var controls: some View {
    Button {
      withAnimation {
        isAnimating.toggle()
      }
    } label: {
      Text("Animate")
    }

  }
}

#if DEBUG
struct ExampleSwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    ExampleSwiftUIView()
  }
}
#endif
