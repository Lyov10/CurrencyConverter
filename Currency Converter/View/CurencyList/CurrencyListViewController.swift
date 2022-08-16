//
//  CurrencyListViewController.swift
//  Currency Converter
//
//  Created by 4steps on 16.08.22.
//

import UIKit

protocol CurrencyListViewControllerDelegate: AnyObject {
    func didSelectToCurrency(currency: BalanceModel)
    func didSelectFromCurrency(currency: BalanceModel)
}

class CurrencyListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate : CurrencyListViewControllerDelegate?
    
    var destinationType : DestinationType?
    
    var dataSource : [BalanceModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = BalanceModel.createTempModel()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CurrencyTableViewCell.id, bundle: nil), forCellReuseIdentifier: CurrencyTableViewCell.id)
    }
    

}

extension CurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.id, for: indexPath) as! CurrencyTableViewCell
        cell.setupCell(model: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch destinationType {
        case .toCurrency:
            delegate?.didSelectToCurrency(currency: dataSource[indexPath.row])
        case .fromCurrency:
            delegate?.didSelectFromCurrency(currency: dataSource[indexPath.row])
        default:
            break
        }
        self.dismiss(animated: true)
    }
    
    
}
