//
//  Coin.swift
//  Coind
//
//  Created by Sidney de Koning on 23/11/2017.
//  Copyright © 2017 Sidney de Koning. All rights reserved.
//

import Foundation

struct CoinValue: Codable, CustomStringConvertible {
    let double: Double?
    let string: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        guard let tempStr = try? container.decode(String.self) else {
            self.double = nil
            self.string = ""
            return
        }
        self.string = tempStr
        self.double = Double(tempStr) ?? 0
    }
    
    var description: String {
        guard let double = self.double else { return "" }
        return String(describing: double)
    }
}

struct CoinMeta: Codable {
    let status: Status
    let data: [Coin]
}

struct Status: Codable {
	let timestamp: String
	let errorCode: Int
	let errorMessage: String?
	let elapsed: Int
	let creditCount: Int
    
    enum CodingKeys : String, CodingKey {
        case timestamp = "timestamp"
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case elapsed = "elapsed"
        case creditCount = "credit_count"
        
    }
}

struct Coin: Codable {
    
    let id: Int
    let name: String
    let symbol: String
    let slug: String
    let numMarketPairs: Int
    let dateAdded: String
    let tags: [String?]
    let maxSupply: Double?
    let circulatingSupply: Double?
    let totalSupply: Double?
    
    let cmcRank: Int
    let lastUpdated: String
    let quote: CoinQuote
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case name = "name"
        case symbol = "symbol"
        case slug = "slug"
        case numMarketPairs = "num_market_pairs"
        case dateAdded = "date_added"
        case tags = "tags"
        case maxSupply = "max_supply"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case cmcRank = "cmc_rank"
        case lastUpdated = "last_updated"
        case quote = "quote"
    }
}


struct Tag: Codable {
    let name: String?
}

struct USD: Codable {
    let price: Double
    let change24hVolume: Double?
    let percentChange1h: Double?
    let percentChange24h: Double?
    let percentChange7d: Double?
    let marketCap: Double?
    let lastUpdated: String
    
    enum CodingKeys : String, CodingKey {
        case price = "price"
        case change24hVolume = "volume_24h"
        case percentChange1h = "percent_change_1h"
        case percentChange24h = "percent_change_24h"
        case percentChange7d = "percent_change_7d"
        case marketCap = "market_cap"
        case lastUpdated = "last_updated"
    }
}

struct CoinQuote: Codable {
    let USD: USD
}

