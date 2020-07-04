//
//  GameRules.swift
//  Core
//
//  Created by Danil Lahtin on 04.07.2020.
//  Copyright © 2020 Danil Lahtin. All rights reserved.
//

public protocol GameRules {
    func getWinner() -> Player?
}
