//
//  ColorHarmonyView.swift
//  PhotoGuide
//

import SwiftUI

/// Vue simple : affiche UNIQUEMENT la roue complète.
/// Tout (roue + slider + boutons harmonie) est géré par ColorHarmonyWheel.
struct ColorHarmonyView: View {

    @ObservedObject var vm: ColorHarmonyViewModel

    var body: some View {
        ColorHarmonyWheel(vm: vm)
            .padding(.bottom, 12)
    }
}
