import Vapor

public func configure(_ app: Application) throws {

  app.get("hello") { req in return "hello" }
}