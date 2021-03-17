//
//  WeatherAssebly.swift
//  WeatherTest
//
//  Created by Гурген on 05.03.2021.
//

import UIKit

class WeatherAssebly {
    func assembly() -> UIViewController {
        let vc = WeatherViewController()
        let vm = WeatherViewModel()
        vc.viewModel = vm
        
        return vc
    }
}
