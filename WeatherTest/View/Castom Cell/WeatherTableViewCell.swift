//
//  WeatherTableViewCell.swift
//  WeatherTest
//
//  Created by Гурген on 03.03.2021.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var celsiusLabel: UILabel!
    
    weak var viewModel: WeatherCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {return}
            cityLabel.text = viewModel.cityName
            descriptionLabel.text = viewModel.description
            celsiusLabel.text = String(describing: viewModel.tempC)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
