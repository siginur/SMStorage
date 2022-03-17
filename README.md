# SMStorage

A description of this package.


## Requirements

- iOS 9.0+ | macOS 10.10+ | tvOS 9.0+ | watchOS 2.0+



## Integration

#### Swift Package Manager

You can use [The Swift Package Manager](https://swift.org/package-manager) to install `SMStorage` by adding the proper description to your `Package.swift` file:

```swift
// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    dependencies: [
        .package(url: "https://github.com/siginur/SMStorage.git", from: "1.2.0"),
    ]
)
```
Then run `swift build` whenever you get prepared.


## Usage

#### Initialization

```swift
import SMStorage
```
You can choose between 3 types of storage: UserDefaults, Memory or Files

```swift
let userDefaults = SMStorage.userDefaults()
let memory = SMStorage.memory()
let files = SMStorage.files()
```

#### StorageKey

```swift
enum Key: String, StorageKey {
	case firstName
	case lastName
}
let memory = SMStorage<Key>.memory()
memory[.firstName] = "Alexey"
```

#### Subscript
```swift
// Getting a value
let value: String? = memory["key"]
```

```swift
// With a hard way
let value = memory["key"].string
```