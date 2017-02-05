//
//  OutfitsCommand.swift
//  StylistEye
//
//  Created by Michal Severín on 15.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

struct OutfitsCommand: NetworkExecutable {

    typealias Data = OutfitsDTO
    var urlManager: APIUrlManager

    init(stylistId: String? = nil, dressstyle: String? = nil) {
        urlManager = .outfits(stylistId: stylistId, dressstyle: dressstyle)
        
    }
}
