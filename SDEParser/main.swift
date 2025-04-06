import Foundation
import Yams

let fileManager = FileManager.default

let projectRoot = URL(fileURLWithPath: #file)
    .deletingLastPathComponent() // main.swift

let resourcesRoot = projectRoot.appendingPathComponent("Resources")

func processYAMLFiles(in directory: URL) {
    let startTime = Date()

    guard let enumerator = fileManager.enumerator(at: directory, includingPropertiesForKeys: nil) else {
        print("❌ Failed to enumerate directory: \(directory.path)")
        return
    }

    var yamlFiles: [URL] = []
    for case let fileURL as URL in enumerator {
        if fileURL.pathExtension == "yaml" {
            yamlFiles.append(fileURL)
        }
    }
    enumerator.skipDescendants()

    let totalFiles = yamlFiles.count
    var completedFiles = 0
    let progressQueue = DispatchQueue(label: "progress.queue")

    let group = DispatchGroup()
    let queue = DispatchQueue(label: "yaml.processing.queue", attributes: .concurrent)

    for fileURL in yamlFiles {
        group.enter()
        queue.async {
            defer {
                progressQueue.sync {
                    completedFiles += 1
                    print("📦 \(completedFiles)/\(totalFiles) | Converted \(fileURL.lastPathComponent) → \(fileURL.deletingPathExtension().appendingPathExtension("json").lastPathComponent)")
                }
                group.leave()
            }

            do {
                let yamlString = try String(contentsOf: fileURL, encoding: .utf8)
                guard let yamlData = try Yams.load(yaml: yamlString) else {
                    print("⚠️ Skipping: Failed to parse YAML at \(fileURL.path)")
                    return
                }

                var finalData = yamlData

                if let dict = yamlData as? [String: Any],
                   dict.keys.allSatisfy({ Int($0) != nil }) {
                    let sortedDict = dict
                        .compactMap { (key, value) -> (Int, Any)? in
                            guard let intKey = Int(key) else { return nil }
                            return (intKey, value)
                        }
                        .sorted(by: { $0.0 < $1.0 })

                    finalData = Dictionary(uniqueKeysWithValues: sortedDict.map { (key, value) in ("\(key)", value) })
                }

                let relativePath = fileURL.path.replacingOccurrences(of: resourcesRoot.path, with: "")
                let jsonDestinationRoot = resourcesRoot.appendingPathComponent("sde-json")
                let jsonURL = jsonDestinationRoot.appendingPathComponent(relativePath)
                    .deletingPathExtension()
                    .appendingPathExtension("json")

                try fileManager.createDirectory(at: jsonURL.deletingLastPathComponent(), withIntermediateDirectories: true)

                let jsonData = try JSONSerialization.data(withJSONObject: finalData, options: [.prettyPrinted])
                try jsonData.write(to: jsonURL)
                // print("✅ Converted \(fileURL.lastPathComponent) → \(jsonURL.lastPathComponent)")
            } catch {
                print("❌ Error processing \(fileURL.path): \(error)")
            }
        }
    }

    group.wait()
    let elapsedTime = Date().timeIntervalSince(startTime)
    print(String(format: "⏱ Time elapsed: %.2f seconds", elapsedTime))
}

processYAMLFiles(in: resourcesRoot)
