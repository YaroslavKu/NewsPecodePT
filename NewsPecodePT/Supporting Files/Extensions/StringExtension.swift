//
//  StringExtension.swift
//  NewsPecodePT
//
//  Created by Slavik on 05.09.2020.
//  Copyright © 2020 Me. All rights reserved.
//

import Foundation


extension String{
    var encodeUrl : String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String
    {
        return self.removingPercentEncoding!
    }
}

extension String {
   var countryStringFromCountryCode: String {
        let locale = Locale.current
        guard let languageString = locale.localizedString(forRegionCode: self) else { return self }
        return languageString
    }
}
