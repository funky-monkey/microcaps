//
//  MarketcapDatasource.swift
//  Microcaps
//
//  Created by Sidney de Koning on 22/12/2017.
//  Copyright © 2017 Funky Monkey. All rights reserved.
//

import Foundation

enum CoinSupply: Double {
	case fiftyMil = 50_000_000.0
}

enum MarketCap: Double {
	case twoFifty = 250_000.0
}

class MarketcapDatasource {
    
    let MARKETCAP_24H_RATIO: Double = 2.0
    var MARKET_CAP: MarketCap = .twoFifty
    var COIN_SUPPLY: CoinSupply = .fiftyMil
    
    var data = [Coin]()
    
    func load(completion: @escaping () -> Void) {
        
        self.data = []
        
        try? CoinMarketCapRequest().call { (result) in
            switch(result) {
            case .success(let data):

                self.data = data.data
                // Remove all garbage
                self.filterZero()
                
                self.filterSmallMarketCap()
                self.filterLowToMediumCoinSupply()
                self.calculateMarketCapToVolumeRatio()
                
                self.sortResults()
                
                completion()
            case .error(let error):
                print(error)
            }
        }
    }
    
    /* Requirements
     [x] marketcap < EUR 250.000: filterLowToMediumCoinSupply()
     [x] max_supply < 50.000: filterLowToMediumCoinSupply()
     [x] market cap to volume ratio < 2% (if X has a market cap of $100k, it's 24H volume should be $2000 or more)
     - filter out coins of which total supply is far greater then circulating supply
     */
    
    private func filterSmallMarketCap() {
        // Find coins with a smaller market cap than $250,000
        let smallMarketCap = self.data.filter( { (coin: Coin) in
            return (coin.quote.USD.marketCap ?? 0.0) <= MARKET_CAP.rawValue
        })
        
        self.data = smallMarketCap
		print("filterSmallMarketCap:", self.data.count)
    }
    
    private func filterLowToMediumCoinSupply() {
        
        // Note down all the coins below this mark with a low to medium coin supply i.e less than 50m.
        let mediumCoinSupply = self.data.filter( { (coin: Coin) in
            guard let max = coin.maxSupply else { return false }
            return max <= COIN_SUPPLY.rawValue
        })
        
        self.data = mediumCoinSupply
		print("filterLowToMediumCoinSupply:", self.data.count)
    }
    
    private func calculateMarketCapToVolumeRatio() {
        print("Now calculating microcaps...")
        
        let twentyFourHourVolume = self.data.filter({ (coin: Coin) in
            
            // [x] market cap to volume ratio < 2% (if X has a market cap of $100k, it's 24H volume should be $2000 or more)
            let marketCap = (coin.quote.USD.marketCap ?? 0.0)
            let marketcapPercentage = (marketCap * MARKETCAP_24H_RATIO) / 100
            let volume24hour = (coin.quote.USD.change24hVolume ?? 0.0)
            
            if volume24hour >= marketcapPercentage {
                return true
            }
            return false
        })
        
        self.data = twentyFourHourVolume
		print("calculateMarketCapToVolumeRatio:", self.data.count)
    }
    
    private func filterZero() {
        let zeroMarketCap = self.data.filter( { (coin: Coin) in
            
            let zeroCoinUsd = coin.quote.USD.marketCap
            let zeroTotalSupply = coin.totalSupply
            
            return zeroCoinUsd != 0.0 || zeroTotalSupply != 0.0
        })
        
        self.data = zeroMarketCap
		print("filterZero:", self.data.count)
    }
    
    private func sortResults() {
        self.data.sort { (a: Coin, b: Coin) -> Bool in
            let rankA = a.cmcRank
            let rankB = b.cmcRank
            return rankA < rankB
        }
    }
}
