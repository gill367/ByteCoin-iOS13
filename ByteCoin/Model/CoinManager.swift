//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
protocol CoinManagerDelegate: UIViewController {
    func didGetCurrnecyRate(_ coinManager:CoinManager, exchangeData: CoinModel)
    func didFailWithError(error: Error)
}
class CoinManager {
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "5FE1B1B2-AC06-47FA-AC70-94F01035381B"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func fetchExchangeRate(forCurrency currencySent: String) {
        let urlString = "\(baseURL)/\(currencySent)?apikey=\(apiKey)"
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { data, response, error in
                
                if let safeData = data {
                    if let parsedData = self.parseJSON(safeData) {
                        self.delegate?.didGetCurrnecyRate(self, exchangeData: parsedData)
                    }
                    
                    
                }
                
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(ExchangeData.self, from: data)
            return CoinModel(currency: result.asset_id_quote, value: result.rate)
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    func getCurrencies() -> [String] {
        return currencyArray
    }
}
