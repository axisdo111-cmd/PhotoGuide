//
//  ExposureViewModel.swift
//  PhotoGuide
//
//  Created by Daniel PHAM-LE-THANH on 10/12/2025.
//

import SwiftUI

class ExposureViewModel: ObservableObject {

    // MARK: - Vitesses réelles (par stops)
    let shutterStops: [Double] = [
        1/4000, 1/2000, 1/1000,
        1/500, 1/250, 1/125,
        1/60, 1/30, 1/15,
        1/8, 1/4, 1/2, 1, 2, 3
    ]

    @Published var shutterIndex: Int = 5 {
        didSet { updateEV() }
    }
    var shutter: Double { shutterStops[shutterIndex] }


    // MARK: - Ouvertures normalisées (vraies valeurs)
    let apertureStops: [Double] = [
        1.0, 1.4, 2.0, 2.8,
        4.0, 5.6, 8.0, 11.0,
        16.0, 22.0, 32.0, 45.0,
        64.0, 90.0
    ]

    @Published var apertureIndex: Int = 3 {  // f/2.8 par défaut
        didSet { updateEV() }
    }
    var aperture: Double { apertureStops[apertureIndex] }


    // MARK: - ISO
    @Published var iso: Double = 100 {
        didSet { updateEV() }
    }

    // MARK: - EV total
    @Published var totalEV: Double = 0

    func updateEV() {
        let evISO = log2(iso / 100)
        let evA = log2(aperture * aperture)
        let evT = log2(1 / shutter)

        totalEV = evA + evT - evISO
    }
}
