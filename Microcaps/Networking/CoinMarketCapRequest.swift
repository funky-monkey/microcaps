//
//  ExchangeRequest.swift
//  Coins
//
//  Created by Sidney de Koning on 23/11/2017.
//  Copyright © 2017 Sidney de Koning. All rights reserved.
//

import Foundation

struct SearchQuery {
    let needle: String
    let pageToLoad: Int
}

struct CoinMarketCapRequest: API {

    private static let sandboxApiKey = "sandbox-key"
    private static let proApiKey = "product-key"
    
    typealias DecodableType = CoinMeta
    
    var host: URL? {
		if self.showDebug {
			return URL(string: "https://sandbox-api.coinmarketcap.com/v1/")
		} else {
			return URL(string: "https://pro-api.coinmarketcap.com/v1/")
		}
    }
    
    var endPoint: Endpoint {
        return .lastestListings
    }
    
    var method: HTTPMethod {
        return .get
    }

	var headers: [String : String]? {
        if self.showDebug {
            return ["Accept" : "application/json",
                    "X-CMC_PRO_API_KEY" : CoinMarketCapRequest.sandboxApiKey]
        } else {
            return ["Accept" : "application/json",
                    "X-CMC_PRO_API_KEY" : CoinMarketCapRequest.proApiKey]
        }
		
	}

    var showDebug: Bool {
        return false
    }
}
