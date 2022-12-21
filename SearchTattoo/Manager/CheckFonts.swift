//
//  CheckFonts.swift
//  SearchTattoo
//
//  Created by Hertz on 12/19/22.
//

import Foundation
import UIKit

class CheckFonts {
    init() {
        func checkFonts() {
            for family: String in UIFont.familyNames {
                            print(family)
                            for names : String in UIFont.fontNames(forFamilyName: family){
                                print("=== \(names)")
                            }
                        }
        }
    }
}
