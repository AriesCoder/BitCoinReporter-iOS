//
//  Coin.swift
//  Bitcoin Reporter
//
//  Created by Aries Lam on 4/7/22.
//

import Foundation

protocol CoinManagerDelegate{
    func coinDidUpdate(coin: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager{
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "15D41E69-A5C0-492E-97F6-0193C03552CD"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        let urlWithPrice = "https://rest.coinapi.io/v1/exchangerate/BTC/\(currency)?apikey=15D41E69-A5C0-492E-97F6-0193C03552CD"
        performRequest(with: urlWithPrice)
    }
    
//    func fetchCoin(_ apiKey: String){
//        let urlString =
//        "https://rest.coinapi.io/v1/exchangerate/BTC?apikey=\(apiKey)"
//
//    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            task.resume()
        }
        
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?){
        if error != nil{
            delegate?.didFailWithError(error: error!)
            return
        }
        if let coinData = data{
            if let coin = parseJSON(data: coinData){
                delegate?.coinDidUpdate(coin: coin)
            }
        }
    }
    
    func parseJSON(data: Data)-> CoinModel?{
        do{
            let decodedData = try JSONDecoder().decode(CoinData.self, from: data)
            let rate = decodedData.rate
            
            let coin = CoinModel(currencyNum: rate)
            return coin
        }catch{
            print(error)
        }
        return nil
    }
    
}

