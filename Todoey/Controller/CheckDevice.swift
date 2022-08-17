//
//  CheckDevice.swift
//  Todoey
//
//  Created by Francesco terlizzi on 12/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

class CheckDevice {
    var currentDevice : UUID = UUID()
    
    var modelName : String = ""
    
    init() {
        self.currentDevice = UIDevice.current.identifierForVendor
        self.modelName = self.machineName()
    }
    
    // https://stackoverflow.com/questions/26028918/how-to-determine-the-current-iphone-device-model
    func machineName() -> String {
      var systemInfo = utsname()
      uname(&systemInfo)
      let machineMirror = Mirror(reflecting: systemInfo.machine)
      return machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
      }
    }
    
}
