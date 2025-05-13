#!/usr/bin/env swift
import Foundation

struct Item: Codable {
  let title: String
  let subtitle: String
  let arg: String
}

struct SearchResult: Codable {
  let items: [Item]
  var cache: Cache = .init()
  struct Cache: Codable {
    /// My chosen cache lifetime (24 hours)
    var seconds: UInt32 = 86_400
    /// This should show the cache results first in all situations
    var looseReload: Bool = true
  }
}

func parseSearchResults(_ results: String) -> [Item] {
  let pattern = #"^\s*([-]?\d*)\s*(.*?)\s+\(([\d\.]+)\)\s*(.*)$"#
  guard
    let regex = try? NSRegularExpression(
      pattern: pattern,
      options: .anchorsMatchLines
    )
  else {
    return []
  }

  let nsResults = results as NSString
  let matches = regex.matches(
    in: results,
    options: [],
    range: NSRange(location: 0, length: nsResults.length)
  )

  var items: [Item] = []
  for match in matches {
    guard match.numberOfRanges == 5,
      let idRange = Range(match.range(at: 1), in: results),
      let nameRange = Range(match.range(at: 2), in: results),
      let priceRange = Range(match.range(at: 4), in: results)
    else {
      continue
    }

    let id = String(results[idRange])
    let name = String(results[nameRange])
      .trimmingCharacters(in: .whitespaces)
    let price = String(results[priceRange])

    items.append(
      Item(title: name, subtitle: price, arg: id)
    )
  }
  return items
}

func main() {
  let query = CommandLine.arguments.dropFirst().joined(separator: " ")
  let process = Process()
  process.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/mas")
  process.arguments = ["search", "--price", query]

  let pipe = Pipe()
  process.standardOutput = pipe
  do {
    try process.run()
  } catch {
    fputs("Error running mas: \(error)\n", stderr)
    exit(1)
  }

  let data = pipe.fileHandleForReading
    .readDataToEndOfFile()
  guard let output = String(data: data, encoding: .utf8) else {
    fputs("Unable to read output\n", stderr)
    exit(1)
  }

  let items = parseSearchResults(output)
  let result = SearchResult(items: items)
  let encoder = JSONEncoder()

  guard let jsonData = try? encoder.encode(result),
    let jsonString = String(
      data: jsonData,
      encoding: .utf8
    )
  else {
    fputs("Error encoding JSON\n", stderr)
    exit(1)
  }

  print(jsonString)
}

main()
