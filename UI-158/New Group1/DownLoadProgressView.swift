//
//  DownLoadProgressView.swift
//  UI-158
//
//  Created by にゃんにゃん丸 on 2021/04/08.
//

import SwiftUI

struct DownLoadProgressView: View {
    @Binding var progress : CGFloat
    @EnvironmentObject var downloadmodel : DownLoadTaskModel
    
    var body: some View {
        ZStack{
            
            Color.primary.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing:15){
                
                ZStack{
                    
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                    
                    ProgresShape(progress: progress)
                        .fill(Color.gray.opacity(0.3))
                        .rotationEffect(.init(degrees: -90))
                    
                        
                    
                    
                    
                    
                        
                        
                    }
                    
                    .frame(width: 70, height: 70)
                     
                
                Button(action: {
                    
                    downloadmodel.cancelTask()
                }) {
                    
                    Text("Cancel Button")
                        .fontWeight(.semibold)
                        
                
                
                }
                .padding(.top)
               
                
            }
            .padding(.vertical,20)
            .padding(.horizontal,50)
            .background(Color.white)
            .cornerRadius(10)
        }
    }
}

struct DownLoadProgressView_Previews: PreviewProvider {
    static var previews: some View {
        DownLoadProgressView(progress: .constant(0.5))
    }
}

struct ProgresShape : Shape {
    var progress : CGFloat
    func path(in rect: CGRect) -> Path {
        return Path {path in
            
            
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: 35, startAngle: .zero, endAngle: .init(degrees: Double(progress * 360)), clockwise: false)
            
        }
    }
}
