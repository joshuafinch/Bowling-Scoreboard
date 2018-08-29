# Bowling Scoreboard

A mobile application for one or two players of 10 pin bowling to track their scores.

## Table of Contents

- [About](#about)
- [Quick Start](#quick-start)
- [Features](#features)
- [Copyright & License](#copyright--license)

## About

This mobile application is built using Swift 4.1.2 and Xcode 9.4.1 for iOS devices running iOS 11.4.1

If attempting to run this code on future versions of Swift, Xcode, or iOS some additional work may be required to get this code running smoothly.

## Quick Start

The following steps will guide you through the process of running this application on your local machine, and device.

1. Ensure you have Xcode 9.4.1 installed
2. Checkout this repository
3. open `BowlingScoreboard.xcodeproj` with Xcode
4. Go to the project settings, and change the code signing team to your own

Code signing settings are left at automatic here for simplicity, you can set these to manual if needed but these steps will not take you through that process.

5. Attach an iPhone running iOS 11.4.1
6. Ensure the iPhone has development mode enabled, from the Devices & Simulators window: <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>2</kbd>
7. Clean, build and run the application on an iPhone running iOS 11.4.1

## Features

Below is the set of user stories that outline the intended functionality of this mobile application. Any assumptions that have been made, to limit or expand upon the scope will be listed as well.

### User Stories

- As a user I want to select either a 1 or 2 person game
- As a user when it is my turn I want to be able to input my score frame by frame
- As a user I want to see my running score per frame as well as the running score of my opponent
- As a user after the 10th (last) frame, I want to see a summary of the game and clearly see who won

### Stretch Goals

- As a user I want a fun animation when I score a strike
- As a user I want to see a list of my previous games and be able to tap in for a summary of the score

## Copyright & License

This software is released under the [MIT License](LICENSE.md).
