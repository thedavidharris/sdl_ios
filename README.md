[![Accio supported](https://img.shields.io/badge/Accio-supported-0A7CF5.svg?style=flat)](https://github.com/JamitLabs/Accio)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/SmartDeviceLink-iOS.svg?style=flat)](https://cocoapods.org/pods/SmartDeviceLink-iOS)
[![License](https://img.shields.io/cocoapods/l/SmartDeviceLink-iOS.svg?style=flat)](https://cocoapods.org/pods/SmartDeviceLink-iOS)
![SmartDeviceLink Tests](https://github.com/smartdevicelink/sdl_ios/workflows/SmartDeviceLink%20Tests/badge.svg)
[![codecov](https://codecov.io/gh/smartdevicelink/sdl_ios/branch/master/graph/badge.svg)](https://codecov.io/gh/smartdevicelink/sdl_ios)
[![Documentation](docs/badge.svg)](https://smartdevicelink.com/en/guides/iOS/getting-started/installation/)
[![Slack Status](http://sdlslack.herokuapp.com/badge.svg)](http://slack.smartdevicelink.com) 

# SmartDeviceLink (SDL)

[SmartDeviceLink (SDL)](https://www.smartdevicelink.com) is a standard set of protocols and messages that connect applications on a smartphone to a vehicle head unit. This messaging enables a consumer to interact with their application using common in-vehicle interfaces such as a touch screen display, embedded voice recognition, steering wheel controls and various vehicle knobs and buttons. There are three main components that make up the SDL ecosystem.

* The [Core](https://github.com/smartdevicelink/sdl_core) component is the software which Vehicle Manufacturers (OEMs)  implement in their vehicle head units. Integrating this component into their head unit and HMI based on a set of guidelines and templates enables access to various smartphone applications.
* The optional [SDL Server](https://github.com/smartdevicelink/sdl_server) can be used by Vehicle OEMs to update application policies and gather usage information for connected applications.
* The [iOS](https://github.com/smartdevicelink/sdl_ios) and [Android](https://github.com/smartdevicelink/sdl_android) libraries are implemented by app developers into their applications to enable command and control via the connected head unit.
* To suggest new features to SDL, including the iOS library, go to the [SDL Evolution](https://github.com/smartdevicelink/sdl_evolution) github project.
* To understand if a contribution should be entered as an iOS Pull Request or Issue, or an SDL Evolution Proposal, please reference [this document](https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals_versus_issues.md).

<a href="http://www.youtube.com/watch?feature=player_embedded&v=AzdQdSCS24M" target="_blank"><img src="http://i.imgur.com/nm8UujD.png?1" alt="SmartDeviceLink" border="10" /></a>


## Mobile Proxy

The mobile library component of SDL is meant to run on the end user’s smart-device from within SDL enabled apps. The library allows the apps to connect to SDL enabled head-units and hardware through bluetooth, USB, and TCP. Once the library establishes a connection between the smart device and head-unit through the preferred method of transport, the two components are able to communicate using the SDL defined protocol. The app integrating this library project is then able to expose its functionality to the head-unit through text, media, and other interactive elements.


## SDL iOS

We're still working on creating documentation for each of these individual repositories, but in the meantime, you can find more information about SmartDeviceLink [on the website](https://www.smartdevicelink.com).

See the [changelog](https://github.com/smartdevicelink/sdl_ios/blob/master/CHANGELOG.md) for release notes. This project uses [Semantic Versioning](http://semver.org/).

### Installing

#### Accio

You can install this library using [Accio/SwiftPM](https://github.com/JamitLabs/Accio) documentation page.  Please follow the steps to install and initialization Accio into a current or new application. 

In your Package.swift file , you want to add `.package(url: "https://github.com/smartdevicelink/sdl_ios.git", .from: "6.6.0"),`  to the dependencies array.  Then add  `SmartDeviceLink` to the targets dependencies array.

Please see [Mainifest format](https://github.com/apple/swift-package-manager/blob/master/Documentation/PackageDescriptionV4.md) to specify dependencies to a specific branch / version of SDL.

###### Swift

If you are building a Swift app, then add this instead `SmartDeviceLinkSwift` to the targets dependencies array.

##### Cocoapods

You can install this library using [Cocoapods](https://cocoapods.org/pods/SmartDeviceLink-iOS). You can get started with Cocoapods by [following their install guide](https://guides.cocoapods.org/using/getting-started.html#getting-started), and learn how to use Cocoapods to install dependencies [by following this guide](https://guides.cocoapods.org/using/using-cocoapods.html).

In your podfile, you want to add `pod 'SmartDeviceLink', '~> 6.6'`. Then run `pod install` inside your terminal. With Cocoapods, we support iOS 8.0+.

###### Swift
If you are building a Swift app, then add this instead `pod 'SmartDeviceLink/Swift', '~> 6.6'`. Then run `pod install` in your terminal.

##### Carthage

SDL iOS supports Carthage! Install using Carthage by following [this guide](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application). Carthage supports iOS 8+.

###### Swift
If you are building a Swift app, then include both packaged frameworks for expanded logging support.

##### Dynamic Framework

Tagged to our releases is a dynamic framework file that can be drag-and-dropped into the application. Dynamic frameworks are supported on iOS 8+. **WARNING: You cannot submit your app to the app store with the framework as is. You MUST strip the simulator part of the framework first. Strip the x64 and i386 portions first like so:**

```
lipo -remove i386 -remove x86_64 -o SmartDeviceLink.framework/SmartDeviceLink SmartDeviceLink.framework/SmartDeviceLink`
```

You can check the current architectures like so:

```
lipo -info SmartDeviceLink.framework/SmartDeviceLink
```

### Reference Documentation

You can find the latest reference documentation on [SmartDeviceLink.com Documentation](https://smartdevicelink.com/en/docs/iOS/master/), and view guides on [SmartDeviceLink.com Guides](https://smartdevicelink.com/en/guides/iOS/getting-started/installation/).

### Getting Help

First, view our guides on [SmartDeviceLink.com](https://smartdevicelink.com/en/guides/iOS/getting-started/installation/).

If you see a bug, please post an issue on the appropriate repository. Please see the [contribution guidelines](https://github.com/smartdevicelink/sdl_ios/blob/master/CONTRIBUTING.md) before proceeding. If you need general assistance, or have other questions, you can [sign up](http://slack.smartdevicelink.org) for the [SDL Slack](https://smartdevicelink.slack.com) and chat with other developers and the maintainers of the project.

### SDL iOS Getting Started

#### Example Apps
To use the example apps, you can use `pod try SmartDeviceLink`, alternately, you can clone or download the project, but you must then also retrieve the submodules by running `git submodule init` and `git submodule update` in your terminal while in the main directory of the project.

#### Other Installation Requirements
You can connect your application with [manticore](https://smartdevicelink.com/resources/manticore/) while running in TCP debug mode in order to test. For more information, [see the guildes](https://smartdevicelink.com/en/guides/iOS/getting-started/connecting-to-an-infotainment-system/).

#### Enabling Background Capabilities
iOS 5 introduced the capability for an iOS application to maintain a connection to an external accessory while the application is in the background. This capability must be explicitly enabled for your application.

To enable the feature for your application, select your application's build target, go to Capabilities, enable Background Modes, and select the External accessory communication mode.

![Enable External Accessory Background Mode](http://i.imgur.com/zxn4lsb.png)

#### SDL protocol strings
Your application must support a set of smartdevicelink protocol strings in order to be connected to smartdevicelink enabled head units. Go to your application's .plist, look at the source, and add the following code under the top level `dict`. Note: This is not required if you're only testing by connected to a wifi enabled head unit, but is required for USB and Bluetooth enabled head units.

```xml
<key>UISupportedExternalAccessoryProtocols</key>
<array>
<string>com.smartdevicelink.prot29</string>
<string>com.smartdevicelink.prot28</string>
<string>com.smartdevicelink.prot27</string>
<string>com.smartdevicelink.prot26</string>
<string>com.smartdevicelink.prot25</string>
<string>com.smartdevicelink.prot24</string>
<string>com.smartdevicelink.prot23</string>
<string>com.smartdevicelink.prot22</string>
<string>com.smartdevicelink.prot21</string>
<string>com.smartdevicelink.prot20</string>
<string>com.smartdevicelink.prot19</string>
<string>com.smartdevicelink.prot18</string>
<string>com.smartdevicelink.prot17</string>
<string>com.smartdevicelink.prot16</string>
<string>com.smartdevicelink.prot15</string>
<string>com.smartdevicelink.prot14</string>
<string>com.smartdevicelink.prot13</string>
<string>com.smartdevicelink.prot12</string>
<string>com.smartdevicelink.prot11</string>
<string>com.smartdevicelink.prot10</string>
<string>com.smartdevicelink.prot9</string>
<string>com.smartdevicelink.prot8</string>
<string>com.smartdevicelink.prot7</string>
<string>com.smartdevicelink.prot6</string>
<string>com.smartdevicelink.prot5</string>
<string>com.smartdevicelink.prot4</string>
<string>com.smartdevicelink.prot3</string>
<string>com.smartdevicelink.prot2</string>
<string>com.smartdevicelink.prot1</string>
<string>com.smartdevicelink.prot0</string>
<string>com.ford.sync.prot0</string>
<string>com.smartdevicelink.multisession</string>
</array>
```

#### Continue Integrating
Go through the [guide documentation](https://smartdevicelink.com/en/guides/iOS/getting-started/integration-basics/) to get started setting up your app to work with SDL!

### Running Tests
To run tests, you will need to bootstrap the Carthage testing libraries. To do so, first [install Carthage](https://github.com/Carthage/Carthage#installing-carthage).

Then, from the root project directory, run:
```bash
carthage bootstrap --platform ios
cd ../
```

At this point, you can run tests from Xcode, or, if you wish to run the tests exactly as they will be run on the CI server, run:

```bash
xcodebuild -project "SmartDeviceLink-iOS.xcodeproj" -scheme "SmartDeviceLink" -sdk "iphonesimulator10.0" -destination "OS=10.0,name=iPhone 7" -configuration Debug ONLY_ACTIVE_ARCH=NO RUN_CLANG_STATIC_ANALYZER=NO GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES GCC_GENERATE_TEST_COVERAGE_FILES=YES ENABLE_TESTABILITY=YES test
```

You can optionally pipe the result to [xcpretty](https://github.com/supermarin/xcpretty).

#### Lock Screen Screenshot Tests
We run some additional tests using [FBSnapshotTestCase](https://github.com/uber/ios-snapshot-test-case). These tests generate the lock screen view controller and compare it to generated screenshots. By default, the generated screenshots use the iPhone 11 / iPhone XR simulator. If you run unit tests against those simulators, the tests should pass.

##### Re-Generating Lock Screen Screenshots
If you need to change which simulator is used to generate the screenshots, or if you need to re-generate the screenshots for another reason, you can. Go to `SDLLockScreenViewControllerSnapshotTests.m` and take the following steps:

1. Uncomment the following line:

```objc
//    self.recordMode = YES;
```

2. Run unit tests on the simulator that you want to use to generate the screenshots. Tests should fail because record mode is on.

3. Re-comment out the line.

4. Run unit tests again; they should pass this time.
