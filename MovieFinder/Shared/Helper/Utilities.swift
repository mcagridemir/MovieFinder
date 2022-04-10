//
//  Utilities.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 10.04.2022.
//

import Foundation

class Utilities {
    /// This function trims whitespaces and new lines, checks given text has at least 1 character and returns text has at least 1 character or not.
    class func hasAtLeast1Character(text: String) -> Bool {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedText.count >= 1
    }
}
