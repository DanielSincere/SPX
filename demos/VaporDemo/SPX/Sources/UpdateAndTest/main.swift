import Sh

_ = try sh("mkdir -p logs")
try sh(.file("logs/update.log"), "swift package update")
try sh(.file("logs/test.log"), "swift test")
