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
//		return ["application/json; charset=utf-8": "Content-Type",
//				"X-CMC_PRO_API_KEY" : "fad04d51-3d42-4a32-8c5f-9f0f5eab1254"]
		return nil
	}

    var showDebug: Bool {
        return false
    }
}
