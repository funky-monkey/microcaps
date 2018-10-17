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
    
    typealias DecodableType = [Coin]
    
    var host: URL? {
        return URL(string: "https://api.coinmarketcap.com/v1/")
    }
    
    var endPoint: Endpoint {
        return .ticker
    }
    
    var method: HTTPMethod {
        return .get
    }

	var headers: [String : String]? {
		return nil
	}

    var showDebug: Bool {
        return false
    }
}
