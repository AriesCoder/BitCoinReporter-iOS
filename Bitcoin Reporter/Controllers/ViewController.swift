//
//  ViewController.swift
//  Bitcoin Reporter
//
//  Created by Aries Lam on 4/7/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitCoinImage: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var currencyStackView: UIStackView!
    
    
    var coinManager = CoinManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        bitCoinImage.layer.cornerRadius = 60
        bitCoinImage.clipsToBounds = true
        currencyStackView.layer.cornerRadius = 40
        
    }

}

//MARK: - UIPickderViewDataSource
extension ViewController: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }

}

//MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return coinManager.currencyArray[row]
    
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        currencyLabel.text = selectedCurrency
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}

//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate{
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func coinDidUpdate(coin: CoinModel) {
        DispatchQueue.main.async {
            self.rateLabel.text = String(format: "%.2f",  coin.currencyNum)
        }
        
    }
    
}

