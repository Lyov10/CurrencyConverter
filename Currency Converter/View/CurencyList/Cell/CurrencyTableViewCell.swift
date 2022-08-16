//
//  CurrencyTableViewCell.swift
//  Currency Converter
//
//  Created by 4steps on 16.08.22.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyNameLabel: UILabel!
    
    static let id = "CurrencyTableViewCell"
    
    func setupCell(model: BalanceModel) {
        currencyNameLabel.text = model.currencyName
    }
}
