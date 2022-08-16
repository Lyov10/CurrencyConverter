//
//  CurrencyNetworkManager.swift
//  Currency Converter
//
//  Created by 4steps on 16.08.22.
//

import Foundation
import Alamofire

final class RestAPIConstants {

    static let baseUrl = "http://api.evp.lt/currency/commercial/exchange/"
    
    static func getCurrency(fromAmount: String,fromCurrency: String,toCurrency: String ) -> String {
        return  baseUrl + fromAmount + "-" + fromCurrency + "/" + toCurrency + "/latest"
    }
    
}




final class CurrencyRequestManager {
    
    static let sharedInstance = CurrencyRequestManager()
    
    private init() {}
    
    // MARK: - Requests
    
    func getCurrency(fromAmount: String, fromCurrency: String, toCurrency: String, completion: @escaping (_ currency: CurrencyModel?) -> Void) {
        let url = RestAPIConstants.getCurrency(fromAmount: fromAmount, fromCurrency: fromCurrency, toCurrency: toCurrency)
        
        AF.request(url, method: .get, encoding: JSONEncoding.default).validate(statusCode: 200..<600).responseJSON {(response) in
        switch response.result {
        case .success(let value):
            do {
                let resultData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                let result = try JSONDecoder().decode(CurrencyModel.self, from: resultData)
                completion(result)
            } catch {
                completion(nil)
            }
        case .failure(_):
            completion(nil)
        }
    }
}

}
