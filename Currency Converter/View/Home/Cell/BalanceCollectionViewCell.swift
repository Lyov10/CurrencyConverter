//
//  BalanceCollectionViewCell.swift
//  Currency Converter
//
//  Created by 4steps on 16.08.22.
//

import UIKit

class BalanceCollectionViewCell: UICollectionViewCell {

    static let id = "BalanceCollectionViewCell"

    @IBOutlet weak var balanceCountLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    
    func setupCell(model: BalanceModel) {
        balanceCountLabel.text = "\(model.currencyBalance)"
        currencyNameLabel.text = "\(model.currencyName)"
    }
    
}
