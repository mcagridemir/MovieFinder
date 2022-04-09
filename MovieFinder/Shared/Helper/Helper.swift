//
//  Helper.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import UIKit

class Helper {
    class func formatDate(dateTxt: String, inputFormat: String? = nil, outputFormat: String? = nil) -> String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = inputFormat ?? "dd.MM.yyyy"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = outputFormat ?? "yyyy-MM-ddTHH:mm:ss"
        if let date = dateFormatterGet.date(from: dateTxt) {
            return dateFormatterPrint.string(from: date)
        }
        return nil
    }
}
