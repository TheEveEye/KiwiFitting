//
//  SlotView.swift
//  KiwiFitting
//
//  Created by Oskar on 20.04.25.
//

import SwiftUI

struct SlotView: View {
    let slotType: SlotType
    @State public var module: Module?
    @State var state: SlotState = .online
    var rotationAngle: Double
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let innerRadius: CGFloat = min(geometry.size.width, geometry.size.height) / 2.3529411765
            let outerRadius: CGFloat = min(geometry.size.width, geometry.size.height) / 2
            let startAngle = Angle.degrees(0)
            let endAngle = Angle.degrees(8.424)
            
            // slotFrame: renders the arc shape (path outline)
            let slotFrame = Path { path in
                // First arc (outer)
                path.addArc(center: center, radius: outerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                // Line to inner arc's end point
                let endPoint = CGPoint(
                    x: center.x + innerRadius * cos(CGFloat(endAngle.radians)),
                    y: center.y + innerRadius * sin(CGFloat(endAngle.radians))
                )
                path.addLine(to: endPoint)
                // Second arc (inner), drawn backwards to complete the shape
                path.addArc(center: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
                // Line back to start of outer arc to close the path
                let startPoint = CGPoint(
                    x: center.x + outerRadius * cos(CGFloat(startAngle.radians)),
                    y: center.y + outerRadius * sin(CGFloat(startAngle.radians))
                )
                path.addLine(to: startPoint)
                path.addArc(center: center, radius: outerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            }
            

            // slotContent: places the content inside the frame (e.g., the circle image)
            let slotContent: any View =
                state == .empty || state == .disabled ?
                    slotType.image
                        .resizable()
                        .rotationEffect(.degrees(94.212))
                    :
            AsyncImage(url: URL(string: "https://images.evetech.net/types/\(module?.typeID ?? "0")/icon?size=64"), content: { image in
                        image
                            .resizable()
                            .scaleEffect(1.2)
                            .rotationEffect(.degrees(4.212 - rotationAngle))
                    }, placeholder: {
                        ProgressView()
                    })
            
            ZStack {
                slotFrame
                    .stroke(state.frameStrokeColor, lineWidth: 2)
                    .fill(state.frameFillColor)
                AnyView(slotContent
                    .frame(width: (outerRadius - innerRadius) * 0.6, height: (outerRadius - innerRadius) * 0.6)
                    .transformEffect(CGAffineTransform(
                        translationX: ((innerRadius + outerRadius) / 2) * cos(CGFloat(Angle.degrees(4.212).radians)),
                        y: ((innerRadius + outerRadius) / 2) * sin(CGFloat(Angle.degrees(4.212).radians))
                    ))
                    .opacity(state.imageOpacity)
                        )
            }
            .onTapGesture {
                state.advance()
            }
        }
    }
}

#Preview {
    SlotView(slotType: .high, module: inferModule(typeID: "482"), rotationAngle: 0)
        .scaleEffect(3)
        .transformEffect(CGAffineTransform(translationX: -500, y: 0))
}
