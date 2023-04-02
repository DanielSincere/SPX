enum Templates: String, CaseIterable {
	case ios
	case simple

  var files: [ScaffoldFile] {
    switch self {
    	case .ios: return Self.iosFiles
	    case .simple: return Self.simpleFiles
    }
  }
}