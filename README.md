<p align="center"><img height="125px" width="400" src="./branding/text-black.png" alt="Fliver Rider"/></p>

# Fliver Rider app for iOS and Android

[![Stars](https://img.shields.io/github/stars/fliverdev/rider.svg)](https://github.com/fliverdev/rider/stargazers)
[![Forks](https://img.shields.io/github/forks/fliverdev/rider.svg)](https://github.com/fliverdev/rider/network/members)
[![Issues](https://img.shields.io/github/issues/fliverdev/rider.svg)](https://github.com/fliverdev/rider/issues)
[![License](https://img.shields.io/github/license/fliverdev/rider.svg)](https://opensource.org/licenses/GPL-3.0)

Fliver is a smartphone app for iOS and Android to help ease the process of getting a taxi when you need one. We obtain information about user demand for taxis, based on which we create density hotspots to inform the taxi drivers where there are people looking for a taxi.

This is the Rider app repository for riders to mark their locations and notify a driver. It is part of the Final Year Project of a bunch of Computer Engineering students.

## Building

To build and run the app on your device, do the following:

-   Install Flutter by following the instructions on their [website](https://flutter.dev/docs/get-started/install/).
-   Fork/clone this repo to your local machine using `git clone https://github.com/fliverdev/rider.git`.
-   **Important:** the `AppDelegate.swift` and `AndroidManifest.xml` files are currently encrypted due to the use of API keys, so the project will not build directly for either platforms. To resolve this issue, please overwrite the existing `AppDelegate.swift` and `AndroidManifest.xml` files with your own.
-   Connect your devices/emulators and run the app using `flutter run --release` in the root of the project directory.

**Note:** you can also run it faster in debug mode using `flutter run`, but the animations will be choppy and performance won't be as expected.

## Contributing

Found any bugs? Have any suggestions or code improvements? [Submit an issue](https://github.com/fliverdev/rider/issues) or fork and [send a pull request](https://github.com/fliverdev/rider/pulls) with your changes. All contributions are more than welcome, and will be merged into `master` if satisfactory.

## Credits

This project is primarily developed by a bunch of Computer Engineering students at NMIMS's MPSTME:

-   [Urmil Shroff](https://github.com/urmilshroff)
-   [Priyansh Ramnani](https://github.com/prince1998)
-   [Vinay Kolwankar](https://github.com/vinay-ai)

Take a look at the entire list of [contributors](https://github.com/fliverdev/rider/graphs/contributors) to see who all have helped with the project directly.

## License

This project is licensed under the GNU GPL v3 - see the [LICENSE](LICENSE) file for details.
