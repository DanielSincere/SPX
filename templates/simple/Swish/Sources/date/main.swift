import Sh
import Foundation

let cmd =
"""
date +%s
"""
let timeInterval = try sh(TimeInterval.self, cmd)
let date = Date(timeIntervalSince1970: timeInterval)
print(date)
