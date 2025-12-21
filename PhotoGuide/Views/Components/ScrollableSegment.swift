//
//  SrollableSegment.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//

import SwiftUI

struct ScrollableSegment<T: Hashable>: View {
    @Binding var selection: T
    let items: [T]
    let label: (T) -> String
    
    @Namespace private var animation
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(items, id: \.self) { item in
                    Button {
                        selection = item
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    } label: {
                        Text(label(item))
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                ZStack {
                                    if selection == item {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.15))
                                            .matchedGeometryEffect(id: "seg", in: animation)
                                    }
                                }
                            )
                            .foregroundColor(selection == item ? .white : .white.opacity(0.6))
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
