#This is a repository written in Objective-C to demonstrate the use and examples using simple and complex Reactive Cocoa examples

#Reactive Cocoa Examples and Demo
_Disclaimer - Reactive Cocoa is an open source framework which operates on the principles of functional reactive programming paradigm. This project is maintained on GitHub by open source community on [GitHub](https://github.com/ReactiveCocoa/ReactiveCocoa) page._

Home Page - Dynamic Download
![alt text][dynamicdownload]
<br/><br/>
Verify Input fields and activate register button
![alt text][fieldsverify]
<br/><br/>
Apply filter and map function to input array sequence
![alt text][filtermap]
<br/><br/>
Home Screen
![alt text][home]
<br/><br/>
Showing progress indicator for heavy operation
![alt text][progress]
<br/><br/>
This is an Objective-C project to demonstrate the use and working of Reactive cocoa library in terms of using various system functions to simplify seemingly complicated tasks, ranging from user input to network requests.

I have divided this project into two portions - First part is demonstration of RAC function through interactive UI. However, there are some utilities for which it was not possible to show their working through an UI, I have created separate file names ```JKReactiveMiscelleneousExamples.{h, m}``` which enlists those functions and simple code to show how they exactly work.

Below is list of Reactive functions used in both modes : 

Utilities used on UI (All operations are achieved by means of RAC Stream and signals. This is in accordance with thinking in terms of FRP programming. As input value changes, program reacts to it accordingly. It is very useful to build and maintain such code which is quite responsive to user input)

1. Dynamically mapping input field to boolean value
2. Dynamically mapping input field to new value. Such as concatenating input string with another value
3. Dynamically inputting value from input field and assigning to another variable in the program on the fly
4. ```searchBarController``` working. How dynamically changing value is utilized and showcase on how to use _throttle_ function to limit value intake when user types in values relatively faster 
5. Download operation. It shows how heavy network operation could be moved to background thread and once value is retrieved it could be switched to main thread for an UI update
6. How to combine signals from multiple sources
7. How to combine signals and reduce them to a single value. e.g. Taking input from two different sources and combining them to produce a new merged signal
8. How to replace manual ```IBAction``` using standard Reactive ```RACCommand``` method
9. Showing command execution status after any event is fired. Reactive cocoa takes care of updating UI once operation is completed.
10. Using ```rac_sequence``` method to map and filter arrays
11. How to use ```RACStream``` functions subscribeNext and subscribeCompleted
12. How to setup and detect timeout for expensive network requests
13. How to add pause before firing ```next subscription```. Also shows how to ```subscribeNext``` signal based on certain condition. If condition if not satisfied, ```subscribeNext``` block won't get executed.
14. Input validation in simple form. Do not enable input button until all input fields are filled with valid and acceptable values
15. Dynamic image/data download operation. Update UI once operation is completed. Use of RACSchedular to move work back and fort between background and main threads. How to chain input signals
16. ```UISearchbar``` demo with dynamic update and mapping input string to an attributed string and displaying it on UI

Following is list of Reactive functions added to ```JKReactiveMiscelleneousExamples.{h, m}``` file : 

1. How to subscribe to signal first and then send value later using ```RACSubject``` objects
2. How to ```zip``` and ```reduce``` functions to combine outputs from multiple RAC Signals
3. Use of ```flattenMap```. ```flattenMap``` is used to convert a value to signal to which any subscribers can be joined in the future.
4. How to use ```RACSignal Replay``` method to avoid re-executing signal when multiple observers are attached to it.
5. How to use Reactive ```multicasting``` when we have single RACSignal and ```multiple subscribers```
6. How to use ```defer``` - This is very similar to createSignal method on ```RACSignal```
7. How to handle events such as button click with more sophisticated RAC techniques such as ```RACCommand``` and ```rac_signalForControlEvents```
8. How to make network requests using RAC
9. How to use ```switchToLatest``` API. Whenever we have dynamic event going on such as user typing in the search input field, multiple network requests would be sent out dynamically. However, results of all these requests come back in the meantime. ```switchToLatest``` allows us to grab only the latest signal and ignore older ones for convenience purpose.

[dynamicdownload]: https://github.com/jayesh15111988/ReactiveCocoaExamples/blob/master/ReactiveCocoaDemoScreenshots/dynamicdownload.png "Dynamic Images Download"
[fieldsverify]: https://github.com/jayesh15111988/ReactiveCocoaExamples/blob/master/ReactiveCocoaDemoScreenshots/fieldsverify.png "Verify Input fields and validate button"
[filtermap]: https://github.com/jayesh15111988/ReactiveCocoaExamples/blob/master/ReactiveCocoaDemoScreenshots/filtermap.png "Apply Filter and map functions to arrays using rac_sequence method"
[home]: https://github.com/jayesh15111988/ReactiveCocoaExamples/blob/master/ReactiveCocoaDemoScreenshots/home.png "Home Screen"
[progress]: https://github.com/jayesh15111988/ReactiveCocoaExamples/blob/master/ReactiveCocoaDemoScreenshots/progress.png "Progress bar when heavy operation is in progress"
