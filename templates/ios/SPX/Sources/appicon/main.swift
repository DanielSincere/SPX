import SwishXCAssets

let svgPath = "SPX/AppIcon.svg"
try await AppIcon(inputSVG: svgPath, outputDir: "App")
  .render(platforms: [.iPhone, .iPad])
