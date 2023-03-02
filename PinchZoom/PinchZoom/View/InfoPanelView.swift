//
//  InfoPanelView.swift
//  PinchZoom
//
//  Created by Thomas Cowern on 3/2/23.
//

import SwiftUI

struct InfoPanelView: View {
    
    // MARK: - Properties
    var scale: CGFloat
    var offset: CGSize
    
    // MARK: - Body
    var body: some View {
        HStack {
            // MARK: Hotspot
            Image(systemName: "circle.circle")
                .symbolRenderingMode(.hierarchical)
                .resizable()
                .frame(width: 30, height: 30)
            
            Spacer()
            
            // MARK: Info Panel
            HStack(spacing: 2) {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                Text("\(scale)")
                
                Spacer()
                
                Image(systemName: "arrow.left.and.right")
                Text("\(offset.width)")
                
                Spacer()
                
                Image(systemName: "arrow.up.and.down")
                Text("\(offset.height)")
                
                Spacer()
            }
        }
    }
}

// MARK: - Preview
struct InfoPanelView_Previews: PreviewProvider {
    static var previews: some View {
        InfoPanelView(scale: 1, offset: .zero)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
