//
//  FruitsProvider.swift
//  CustomCollectionLayout
//
//  Created by Maksym Husar on 2/17/19.
//  Copyright © 2019 MaksymHusar. All rights reserved.
//

import Foundation
import UIKit

struct DogsProvider {
    static func get() -> [Dog] {
        return [
            Dog(date: Date(), image: UIImage(named: "dog1")),
            Dog(date: Date(), image: UIImage(named: "dog2")),
            Dog(date: Date(), image: UIImage(named: "dog3")),
            Dog(date: Date(), image: UIImage(named: "dog4")),
            Dog(date: Date(), image: UIImage(named: "dog5")),
            Dog(date: Date(), image: UIImage(named: "dog6")),
            Dog(date: Date(), image: UIImage(named: "dog7")),
            Dog(date: Date(), image: UIImage(named: "dog8")),
            Dog(date: Date(), image: UIImage(named: "dog9")),
            Dog(date: Date(), image: UIImage(named: "dog10")),
            Dog(date: Date(), image: UIImage(named: "dog11")),
            Dog(date: Date(), image: UIImage(named: "dog12")),
            Dog(date: Date(), image: UIImage(named: "dog13")),
            Dog(date: Date(), image: UIImage(named: "dog14")),
            Dog(date: Date(), image: UIImage(named: "dog15")),
        ]
    }
}
