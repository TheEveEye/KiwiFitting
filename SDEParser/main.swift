import Foundation
import Yams

let fileManager = FileManager.default

let projectRoot = URL(fileURLWithPath: #file)
    .deletingLastPathComponent() // main.swift

let resourcesRoot = projectRoot.appendingPathComponent("Resources")

func processYAMLFiles(in directory: URL) {
    guard let enumerator = fileManager.enumerator(at: directory, includingPropertiesForKeys: nil) else {
        print("❌ Failed to enumerate directory: \(directory.path)")
        return
    }

    for case let fileURL as URL in enumerator {
        guard fileURL.pathExtension == "yaml" else { continue }

        do {
            let yamlString = try String(contentsOf: fileURL, encoding: .utf8)
            guard let yamlData = try Yams.load(yaml: yamlString) else {
                print("⚠️ Skipping: Failed to parse YAML at \(fileURL.path)")
                continue
            }

            let relativePath = fileURL.path.replacingOccurrences(of: resourcesRoot.path, with: "")
            let jsonDestinationRoot = resourcesRoot.appendingPathComponent("sde-json")
            let jsonURL = jsonDestinationRoot.appendingPathComponent(relativePath)
                .deletingPathExtension()
                .appendingPathExtension("json")

            try fileManager.createDirectory(at: jsonURL.deletingLastPathComponent(), withIntermediateDirectories: true)

            let jsonData = try JSONSerialization.data(withJSONObject: yamlData, options: [.prettyPrinted])
            try jsonData.write(to: jsonURL)
            print("✅ Converted \(fileURL.lastPathComponent) → \(jsonURL.lastPathComponent)")
        } catch {
            print("❌ Error processing \(fileURL.path): \(error)")
        }
    }
}

processYAMLFiles(in: resourcesRoot)
