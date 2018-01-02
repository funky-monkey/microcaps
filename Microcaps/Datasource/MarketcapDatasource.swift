//
//  MarketcapDatasource.swift
//  Microcaps
//
//  Created by Sidney de Koning on 22/12/2017.
//  Copyright © 2017 Funky Monkey. All rights reserved.
//

import Foundation

class MarketcapDatasource {
    
    let MARKETCAP_24H_RATIO: Double = 2.0
    
    var data = [Coin]()
    
    func load(completion: @escaping () -> Void) {
        
        self.data = []
        
        try? CoinMarketCapRequest().call { (result) in
            switch(result) {
            case .success(let data):
                
                self.data = data
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
            return (coin.marketCapEur.double ?? 0.0) <= 250_000.0 || (coin.marketCapUsd.double ?? 0.0) <= 250_000.0
        })
        
        print(smallMarketCap.count)
        
        self.data = smallMarketCap
    }
    
    private func filterLowToMediumCoinSupply() {
        
        // Note down all the coins below this mark with a low to medium coin supply i.e less than 50m.
        let mediumCoinSupply = self.data.filter( { (coin: Coin) in
            return (coin.maxSupply.double ?? 0.0) <= 50_000_000
        })
        
        print(mediumCoinSupply.count)
        
        self.data = mediumCoinSupply
    }
    
    private func calculateMarketCapToVolumeRatio() {
        print("Now calculating microcaps...")
        
        let twentyFourHourVolume = self.data.filter({ (coin: Coin) in
//            let volume = (coin.availableSupply.double ?? 0.0)
//            let marketCap = (coin.totalSupply.double ?? 0.0)
//
//            //print(Double(volume/marketCap).description)
//            if (volume/marketCap) > 0.02 {
//                return true
//            }
//            return false
            
            // [x] market cap to volume ratio < 2% (if X has a market cap of $100k, it's 24H volume should be $2000 or more)
            let marketCap = (coin.marketCapUsd.double ?? 0.0)
            let marketcapPercentage = (marketCap * MARKETCAP_24H_RATIO) / 100
            let volume24hour = (coin.change24hVolumeUsd.double ?? 0.0)
            
            if (volume24hour >= marketcapPercentage) {
                print(marketCap, marketcapPercentage, volume24hour)
                return true
            }
            return false
        })
        
        print(twentyFourHourVolume.count)

        self.data = twentyFourHourVolume
    }
    
    private func filterZero() {
        let zeroMarketCap = self.data.filter( { (coin: Coin) in
            guard
                let zeroCoinUsd = coin.marketCapUsd.double,
                let zeroCoinEur = coin.marketCapEur.double,
                let zeroAvailable = coin.availableSupply.double,
                let zeroTotalSupply = coin.totalSupply.double
            else {
                return false
                
            }
            return zeroCoinUsd != 0.0 || zeroCoinEur != 0.0 || zeroAvailable != 0.0 || zeroTotalSupply != 0.0
        })
        
        print(zeroMarketCap.count)
        
        self.data = zeroMarketCap
    }
    
    private func sortResults() {
        self.data.sort { (a: Coin, b: Coin) -> Bool in
            guard let rankA = a.rank.double, let rankB = b.rank.double else { return false }
            return rankA < rankB
        }
    }
}
