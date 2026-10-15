# TCA Workout Tracker
A toy app for testing out [the composable architecture](https://github.com/pointfreeco/swift-composable-architecture) with SwiftUI.

## Todos:
- [ ] Persistance - actually storing the workouts done
  - [ ] A history tab so you can see past exercises
  - [ ] PR announcements
- [ ] Rest timer
  - [ ] A live activity so you can see it on your lock screen 
- [ ] Cloud sync 
  - [ ] Store your data on the cloud
- [ ] More tests
  - [ ] Snapshot tests for the major screens.
  - [ ] Integration tests for the flows
- [ ] Accesibility
  - [ ] Review for dynamic type sizing
  - [ ] Review VoiceOver support
  - [ ] Ensure colours have enough contrast 
  - [ ] Support options like reduce motion. 



## The compsable architecture thoughts 
- It is quite verbose. Changes need to happen in lots of places.
  - However when using LLMs to generate the code this doesn't matter so much. 
- The extra structure might help LLMs stay on track. 
- I'm not a fan of being so dependant on a third party library
  - How long will it be supported for?
  - How quickly are major bugs resolved?
  - Moving to a different architecture would mean a whole rewrite. 
- Unit tests are nice and easy to write by design. 
- Very similar to Redux in react
  - Swift having a better type system than TS helps.
