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

struct Coin: Codable {
    
    let id: CoinValue
    let name: CoinValue
    let symbol: CoinValue
    let rank: CoinValue
    let priceEur: CoinValue
    let priceUsd: CoinValue
    let priceBtc: CoinValue
    let marketCapUsd: CoinValue
    let marketCapEur: CoinValue
    let availableSupply: CoinValue
    let totalSupply: CoinValue
    let maxSupply: CoinValue
    
    let change24hVolumeUsd: CoinValue
    let change24hVolumeEur: CoinValue
    let percentChange1h: CoinValue
    let percentChange24h: CoinValue
    let percentChange7d: CoinValue
    let lastUpdated: CoinValue
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case name = "name"
        case symbol = "symbol"
        case rank = "rank"
        case priceEur = "price_eur"
        case priceUsd = "price_usd"
        case priceBtc = "price_btc"
        case marketCapUsd = "market_cap_usd"
        case marketCapEur = "market_cap_eur"
        case availableSupply = "available_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case change24hVolumeUsd = "24h_volume_usd"
        case change24hVolumeEur = "24h_volume_eur"
        case percentChange1h = "percent_change_1h"
        case percentChange24h = "percent_change_24h"
        case percentChange7d = "percent_change_7d"
        case lastUpdated = "last_updated"
    }
}
