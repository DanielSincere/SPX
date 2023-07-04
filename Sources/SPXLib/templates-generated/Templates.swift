enum Templates: String, CaseIterable {
	case simple
	case ios

  var files: [ScaffoldFile] {
    switch self {
    	case .simple: return Self.simpleFiles
	case .ios: return Self.iosFiles
    }
  }
}