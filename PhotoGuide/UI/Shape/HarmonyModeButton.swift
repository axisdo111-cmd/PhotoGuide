//
//  HarmonyModeButton.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 12/12/2025.
//

import SwiftUI

struct HarmonyModeButton<Content: View>: View {

    let isSelected: Bool
    let action: () -> Void
    let content: () -> Content

    var body: some View {
        Button(action: action) {
            content()
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.25))
                )
        }
        .buttonStyle(.plain)
    }
}
