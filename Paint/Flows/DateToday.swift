//
//  DateToday.swift
//  Paint
//
//  Created by Илья Мудрый on 28.07.2021.
//

import Foundation
import UIKit

struct DateToday {
    
    static let currentTime = DateToday().getCurrentDate
    
    private var getCurrentDate: String?
    
    private init() {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        getCurrentDate = formatter.string(from: today)
    }
}


