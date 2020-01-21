# Pre-work - *Quick Tip*

**Quick Tip** is a tip calculator application for iOS.

Submitted by: **Howard (Luhao) Wang**

Time spent: **10** hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.

The following **optional** features are implemented:
* [ ] Settings page to change the default tip percentage.
* [x] UI animations
* [ ] Remembering the bill amount across app restarts (if <10mins)
* [ ] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

- [x] Implemented color theme selection (Red, Yellow, or Blue) in app settings

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='https://media.giphy.com/media/Ig3tMd58RIximHUdvu/giphy.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Initially, I thought about using SwiftUI, the new iOS 13 development technology, but after a steep learning curve, I decided it was best to stick with the traditional UIKit for faster understanding. The hardest part was attempting the UI animations, moving views up and down, and getting certain views to display correctly. Next came the debugging, unwrapping optional values, checking for nil, and more. Polishing the user experience and making it seamless was very difficult as well, there was a lot of extra work I had to do (mostly searching up how to do things), such as how to prevent the screen from rotating. At the end, the result was great, I added personalized settings to the app, as well as an app icon that looks very marketable :)

## License

    Copyright [2020] [Howard Wang]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
