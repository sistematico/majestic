# Firefox
###### This is Firefox themes ######

# Setup #

### Enable userChrome customization in about:config ###

* Navigate to about:config in the address bar and accept the risks.

* Search for toolkit.legacyUserProfileCustomizations.stylesheets and toggle it to true (by double clicking on it).
    
    _For a visual walkthrough [Watch me do it](https://imgur.com/fc4NN0t) or [YouTube](https://www.youtube.com/watch?v=levqpofIJ_k&feature=youtu.be.)_

### Locate and open your profile folder ###

Either of the following two methods work:

* Using the Firefox troubleshooting page Click on ☰ ➝ Help ➝ Troubleshooting Information or navigate to about:support in your address bar Under Application Basics, click on the the Open Folder button. You should now see your profile folder.

* Using the Firefox command line Press Shift+F2 Enter the command folder openprofile

    _[original article](https://www.reddit.com/r/FirefoxCSS/wiki/index/tutorials/)_

### Installation my Theme ###

* You should have a Chrome folder here (If not, create it)
* copy everything from the downloaded archive and paste it here
     
     _as a result, you should have a userChrome.css file and a content folder in the chrome folder (depending on the version, besides these two, there may be other files, but these two are required and necessary for correct work)_
* Restart Brouser
* Click on ☰ ➝ personalization and set avrything as in settings.png
     
     _Required! In the tabbar, you must move the "new tab" icon to the Navbar_

### How to get Blur Effect ###

Again go to about:config and search layout.css.backdrop-filter.enabled and switch it to true

# Recomendations #

   * This is [StartPage](https://addons.mozilla.org/ru/firefox/addon/infinity-new-tab-pro-firefox/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search) wich i use
   * This is for [costamization vertical scroll](https://addons.mozilla.org/en-GB/firefox/addon/custom-scrollbars/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
   * [Refresh button](https://addons.mozilla.org/ru/firefox/addon/australis-refresh-in-url-bar/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search) in AddressBar

# For linux/Mac #

If you have LEFT windows control buttons:
unzip linux.rar to content folder
