//
//  OutfitDetailCommand.swift
//  StylistEye
//
//  Created by Michal Severín on 16.10.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

/**
 Outfit detail command.
 */
struct OutfitDetailCommand: NetworkExecutable {

    /// Outfit detail DTO
    typealias Data = OutfitDetailDTO

    /// Url manager.
    var urlManager: APIUrlManager

    init(outfitId: Int) {
        urlManager = .outfitDetail(outfitId: outfitId)
    }
}
