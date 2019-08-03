//
//  Endpoints.swift
//  Coins
//
//  Created by Sidney de Koning on 10/09/2017.
//  Copyright © 2017 Sidney de Koning. All rights reserved.
//

import Foundation

public enum Endpoint {
    case getBase
    case lastestListings
	case lastestMarketPairs
}

protocol Path {
    var path: String { get }
}

extension Endpoint: Path {
    
    var path: String {
        
        switch self {
        case .getBase:
            return "/"
        case .lastestListings:
            return "cryptocurrency/listings/latest?limit=5000"
		case .lastestMarketPairs:
			return "cryptocurrency/market-pairs/latest"
        }
    }
}
