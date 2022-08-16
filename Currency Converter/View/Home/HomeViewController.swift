//
//  ViewController.swift
//  Currency Converter
//
//  Created by 4steps on 15.08.22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var sellView: UIView!
    @IBOutlet weak var recieveView: UIView!
    @IBOutlet weak var keyboardConstraint: NSLayoutConstraint!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var recievedAmount: UILabel!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var recievedAmountLabel: UILabel!
    
    
    private let toCurrencyListViewController = "CurrencyListViewController"
    
    var dataSource : [BalanceModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var convertedModel: CurrencyModel?
    
    var destinationType: DestinationType = .toCurrency
    
    private var selectedCurrency: BalanceModel? {
        didSet {
            fromButton.setTitle(selectedCurrency?.currencyName, for: .normal)
        }
    }
    private var selectedToCurrency: BalanceModel? {
        didSet {
            toButton.setTitle(selectedToCurrency?.currencyName, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupUI()
        registerKeyboardNotif()
        dataSource = BalanceModel.createTempModel()
        selectedCurrency = BalanceModel.createTempModel().first
        
    }
    @IBAction func submitButtonTapped(_ sender: Any) {
        self.amountTextField.resignFirstResponder()
        showAlert()
    }
    
    @IBAction func openCurrencyList(_ sender: Any) {
        destinationType = .toCurrency
        self.performSegue(withIdentifier: toCurrencyListViewController, sender: nil)
    }
    
    @IBAction func opneFromCurrencyList(_ sender: Any) {
        destinationType = .fromCurrency
        self.performSegue(withIdentifier: toCurrencyListViewController, sender: nil)
    }
    
    private func setupUI() {
        self.submitButton.layer.cornerRadius = 25
        recieveView.layer.cornerRadius = 20
        sellView.layer.cornerRadius = 20
        submitButton.isEnabled = false
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: BalanceCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: BalanceCollectionViewCell.id)
    }
    
    private func registerKeyboardNotif() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil) { [weak self] (notification) in
            self?.keyboardNotificationHandlingAction(notification: notification as NSNotification)
        }
        
    }
    func keyboardNotificationHandlingAction(notification: NSNotification) {
        if let userInfo = notification.userInfo, let changingConstraint = keyboardConstraint {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                changingConstraint.constant = 0
                
            } else {
                if var height = endFrame?.size.height {
                    if #available(iOS 11.0, *) {
                        height -= view.safeAreaInsets.bottom
                    }
                    keyboardConstraint.constant = height + 16
                } else {
                    keyboardConstraint.constant = 0
                }
            }
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: {
                self.view.layoutIfNeeded() }, completion: nil)
        } else {
            keyboardConstraint?.constant = 0
        }
    }
    
    
   private func showAlert() {
       guard let convertedModel = convertedModel else {
           return
       }
        let title = "Currency Converted"
       let message = "You have converted \(amountTextField.text ?? "") \(selectedCurrency?.currencyName ?? "") to \(convertedModel.amount) \(convertedModel.currency)"
        let doneButton =  "Done"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: doneButton, style: .cancel) 

        alert.addAction(okAction)
       self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case toCurrencyListViewController:
            let destinationVC = segue.destination as! CurrencyListViewController
            destinationVC.delegate = self
            destinationVC.destinationType = destinationType
        default:
            break
        }
    }
}

extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: BalanceCollectionViewCell.id, for: indexPath) as! BalanceCollectionViewCell
        cell.setupCell(model: dataSource[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCurrency = dataSource[indexPath.item]
        recievedAmountLabel.text = ""
        amountTextField.text = ""
        submitButton.isEnabled = false
    }
    
}


extension HomeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = (textField.text ?? "") + string
        if Double(currentString ) ?? 0.0 > selectedCurrency?.currencyBalance ?? 0.0 {
            textField.textColor = .red
            submitButton.isEnabled = false
            return true
        } else {
            textField.textColor = .black
            submitButton.isEnabled = true
        }
        guard  let fromCurrency = selectedCurrency?.currencyName, let toCurrency = toButton.titleLabel?.text else {return false}
        CurrencyRequestManager.sharedInstance.getCurrency(fromAmount: currentString, fromCurrency: fromCurrency, toCurrency: toCurrency) { [weak self] currency in
            self?.recievedAmountLabel.text = "+\(currency?.amount ?? "")"
            self?.convertedModel = currency
        }
        return true
    }
    
}


extension HomeViewController : CurrencyListViewControllerDelegate {
    func didSelectFromCurrency(currency: BalanceModel) {
        selectedCurrency = currency
    }
    func didSelectToCurrency(currency: BalanceModel) {
        selectedToCurrency = currency
    }
    
}
