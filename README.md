# Punky Brewster

Experimental foray into Swift and iOS development, manifesting in the form of a [Punky Brewster](http://www.punkybrewster.co.nz) app.

![](http://i.imgur.com/IayZEVQ.jpg)

## Development

Dependencies are managed by [CocoaPods](https://cocoapods.org).

Install dependencies with:

    pod install

You'll also need a OneSignal App ID. By default, it looks for one in your environment variables. You can set this with `launchctl`:

    # Allow environment variables to filter through to XCode (make sure to restart XCode afterwards)
    defaults write com.apple.dt.Xcode UseSanitizedBuildSystemEnvironment -bool NO
    
    # Set the value
    launchctl setenv ONESIGNAL_APP_ID mytokenhere

Open `Punky Brewster.xcworkspace`.

## Acknowledgements

Special thanks to Luke McFarlane (@lukemcfarlane).
