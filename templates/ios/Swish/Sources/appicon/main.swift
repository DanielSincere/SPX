import SwishXCAssets

let svgPath = "Swish/AppIcon.svg"
try await AppIcon(inputSVG: svgPath, outputDir: "App")
  .render(platforms: [.iPhone, .iPad])
