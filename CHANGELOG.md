# Change Log

## [Unreleased](https://github.com/siginur/SMStorage/tree/HEAD)
[Full changelog](https://github.com/siginur/SMStorage/compare/v1.3.1...HEAD)

## [1.3.1](https://github.com/siginur/SMStorage/tree/v1.3.1) (2023-02-16)
[Full changelog](https://github.com/siginur/SMStorage/compare/v1.3.0...v1.3.1)
#### Fixes
- Fix recursion error when string value is set

## [1.3.0](https://github.com/siginur/SMStorage/tree/v1.3.0) (2022-04-22)
[Full changelog](https://github.com/siginur/SMStorage/compare/v1.2.1...v1.3.0)
#### News
- Add new StorageType: `.keychainn`
- Add DataPolicy configuration for `files` and `keychain` storage types
- Add get/set methods with error throwing when something went wrong

## [1.2.1](https://github.com/siginur/SMStorage/tree/v1.2.1) (2022-03-17)
[Full changelog](https://github.com/siginur/SMStorage/compare/v1.2.0...v1.2.1)
#### Fixes
- Make RawRepresentable extension public

## [1.2.0](https://github.com/siginur/SMStorage/tree/v1.2.0) (2022-03-17)
[Full changelog](https://github.com/siginur/SMStorage/compare/v1.1.0...v1.2.0)
#### News
- Add RawRepresentable extension

## [1.1.0](https://github.com/siginur/SMStorage/tree/v1.1.0) (2022-02-01)
[Full changelog](https://github.com/siginur/SMStorage/compare/v1.0.0...v1.1.0)
#### News
- Add new StorageType: `.files`
- Add method `contain`
- Add tests
#### Changes
- StorageKey type changed from `String` to `CustomStringConvertible`
- Initializers were changed to static methods

## [1.0.0](https://github.com/siginur/SMStorage/tree/v1.0.0) (2021-12-12)
Initial release
