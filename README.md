Smart Alarm App
---------------
### Startup Systems Project @ Cornell Tech

[![Build Status](https://travis-ci.org/smart-alarm/ios.svg?branch=master)](https://travis-ci.org/smart-alarm/ios)

### Background
Users often set their alarm clocks expecting their morning routine and commute to take the usual amount of time. However, life is not always so static. Oftentimes there are unexpected accidents or events that causes delays and mess up these morning plans. If an alarm is not smart enough to warn us ahead of time and wake us up earlier when these events occur, our mornings can be ruined.

### Challenge
We propose to create an alarm app that will periodically check your morning commute and estimate the amount of time your commute will take and wake you up with enough time to make your appointments.

### Solution
Once registered with a profile, a user is prompted to save a "morning routine" in which he/she logs daily morning routine activities and the amount of time they typically take. For example, 10 minutes for breakfast, 15 minute shower, etc. This routine is used as a general "buffer" time when calculating final wakeup time.

Next, the user enters a destination location (e.g. work address) and a desired arrival time.

Using the calculated buffer time (from morning routine) and polling of traffic data (MapKit), a wakeup time is dynamicaaly set to wake up the user at the optimal time. In the event of heavy traffic, the alarm will wake up the user earlier to account for additional commute time.

### Tech Specs
* IDE: Xcode 7
* Programming language: Swift 2
* Continous Integration: Travis CI

### Links
* [Github](https://github.com/smart-alarm)
* [Project Management](https://waffle.io/gidglass/smart-alarm)

###Beta Distribution
[Fabric.io - Beta by Crashlytics](https://betas.to/Eeuq33Mb)

