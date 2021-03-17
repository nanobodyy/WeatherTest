//
//  WeatherViewController.swift
//  WeatherTest
//
//  Created by Гурген on 03.03.2021.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: WeatherViewModelProtocol?
    
    let network = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        configureNavController()
        viewModel?.viewLoad(tableView: self.tableView)
    }

    func configureNavController() {
        title = "погода"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(WeatherViewController.addTarget))
    }
    
    @objc func addTarget() {
        let ac = UIAlertController(title: "Город", message: "добавить город", preferredStyle:.alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            let textField = ac.textFields?[0]
            guard let text = textField?.text else { return }
            
            self.viewModel?.addNewCity(tableView: self.tableView, name: text)
        }
        
        let cancel = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        ac.addTextField { (textField) in
            
        }
        
        ac.addAction(ok)
        ac.addAction(cancel)
        
        present(ac, animated: true, completion: nil)
    }
    
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherTableViewCell
        let cellViewModel = viewModel?.cellViewModel(forIndexPath: indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        self.viewModel?.deleteCity(index: indexPath)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        viewModel?.selectRow(atIndexPath: indexPath)
        let detailViewModel = viewModel?.viewModelForSelectedRow()
        detailViewController.viewModel = detailViewModel
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
        //self.present(detailViewController, animated: true, completion: nil)
    }
}
