//
//  DetailViewController.swift
//  WeatherTest
//
//  Created by Гурген on 16.03.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModelProtocol?

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var celLablel: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var minCelLabel: UILabel!
    @IBOutlet weak var maxCelLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.viewModel?.getConditionImage(compitionHandler: { (image) in
            self.imageView.image = image
        })
        self.configure()
    }

    func configure() {
        guard let viewModel = viewModel else { return }
        self.cityLabel.text = viewModel.cityName
        self.celLablel.text = "\(viewModel.temp) Cº"
        self.windspeedLabel.text = "\(viewModel.windspeed) км/ч"
        self.maxCelLabel.text = "\(Int(viewModel.maxTemp ?? 00)) Сº"
        self.minCelLabel.text = "\(Int(viewModel.minTemp ?? 00)) Cº"
        guard let sunrice = viewModel.sunrise else { return }
        self.sunriseLabel.text = sunrice
        self.descriptionLabel.text = viewModel.conditionText
    }
}
