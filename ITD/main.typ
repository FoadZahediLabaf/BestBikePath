#import "@local/polimi:1.0.1": *
#import "@local/plantuml:0.1.0"

#show raw.where(lang: "plantuml"): it => image(plantuml.path(it.text))


#show: polimi-thesis.with(
  title: "Best Bike Paths",
  subtitle: "Implementation and Testing Document",
  author: "Lorenzo Fiamingo\nAlexander Gabriel Fox\nFoad Zahedi Labaf",
  advisor: "",
  coadvisor: "",
  tutor: "",
  academic-year: "2025/2026",
  chair: none,
  language: "en",
  colored-headings: true,
)

#toc
#list-of-figures
#list-of-tables

#show: mainmatter.with()

= Introduction

== Purpose
In this document, we illustrate the implementation of the various software components previously discussed in the related Design Document for the Best Bike Paths application. The document also describes the adopted frameworks and programming languages, as well as the testing plan.

== Scope
The main goad of this document is to describe how and which requirements have been implemented in the application, while also illustrating the different software tools that were use during the implementation process and the reasons for their adoptions. 
The final section describes the test cases used during the testing phase, focusing on unit testing and the methodology adopted for integration testing.

== Definitions, Acronyms, Abbreviations

=== Definitions
*User*: Term used to indicate both authenticated and unauthenticated individuals who interact with the application.

*Authenticated User*: User who is authenticated in their BBP account. An authenticated user has full access to the functionalities offered by the application.

*Unauthenticated User*: Users who do not have a BBP account, or who have an account but aren't currently authenticated within the system. These users have limited access to the application's functionalities.

*Bike Path*: A bike path is a collection of information associated with a specific route. This information may refer to a single user trip and, in that case, includes performance-related data describing the user’s ride, as well as qualitative information about the route itself.  
The term bike path is also used to indicate the aggregated information derived from multiple user-specific bike paths that follow the same route. This information will therefore exclude individual performance data and primarily consists of aggregated data describing the overall quality of the route.

*Bike Trip*: A bike trip indicates a cycling session that may optionally be recorded by the application at the cyclist’s discretion. During the trip, data is collected from the device’s GPS and motion sensors and may be enriched with meteorological information.

*Meteorological Data*: Meteorological data refers to information describing the atmospheric conditions during a bike trip, such as weather conditions, temperature, and wind speed.

*Motion Sensors*: This term refers to the user’s device’s hardware components that allow for the collection of performance-related and qualitative data about the bike trip. 
Specifically, the gyroscope of the device is responsible for measuring angular velocity and is used to identify obstacles along the path.
The accelerometer is responsible for measuring the acceleration of the user during the trip and contributes both to obstacle detection and to the computation of the user’s velocity.

*SMTP Server*: An SMTP server, or email service provider, is an external system responsible for sending transactional emails on behalf of the application.

*Status*: Term used to indicate the overall assessment of a path's quality, which can be either manually specified by the user or computed by the system based on the frequency of obstacles along the path.


=== Acronyms

*API*: Application Programming Interface \
*BBP*: Best Bike Paths \
*DBMS*: DataBase Management System \
*EU*: European Union \
*GDPR*: General Data Protection Regulation \
*GPS*: Global Positioning System \
*HTTPS*: HyperText Transfer Protocol Secure \
*ISO* : International Organization for Standardization \
*IEC*: International Electrotechnical Commission \
*IEEE*: Institute of Electrical and Electronics Engineers \
*JSON*: JavaScript Object Notation\
*JWT*: JSON Web Token \
*KV*: Key-Value \
*MVVM*: Model-View-ViewModel \
*NPM*: Node Package Manager \
*REST*: Representational State Transfer \
*SQL*: Structured Query Language \
*SPM*: Swift Package Manager \
*SMTP*: Simple Mail Transfer Protocol \
*Wi-Fi*: Wireless Fidelity \

=== Abbreviations

*R*: Requirement

== Version History
 
- Version 1: 01/02/2026

== Reference Documents

The following reference materials were used for the preparation of this document:
- The Requirement Analysis and Specification Document.
- The Design Document
- The specification for the 2025/26 Requirement Engineering and Design Project for the Software Engineering II course.
- The WeBeep slides of the Software Engineering II course.
- I&T assignment provided in WeBeep.
- European Union, *General Data Protection Regulation (EU) 2016/679*, 2016.
- #link("https://www.iso.org/standard/75405.html")[ISO/IEC, *ISO/IEC/IEEE 24748-8:2019 Systems and software engineering -- Life cycle management*, 2019].
- #link("https://developer.apple.com/design/human-interface-guidelines")[Apple Inc., *Apple Human Interface Guidelines*, online documentation].
- #link("https://m3.material.io")[Google LLC, *Material Design Guidelines*, online documentation].
- #link("https://developer.apple.com/documentation/coremotion")[Apple Inc., *Core Motion Framework Documentation*, online documentation].
- #link("https://developer.apple.com/documentation/corelocation")[Apple Inc., *Core Location Framework Documentation*, online documentation].
- #link("https://developer.apple.com/documentation/weatherkit/")[Apple Inc., *WeatherKit Framework Documentation*, online documentation].

== Document Structure

1. *Introduction*: A brief overview of the contents of the document and its purpose.
2. *Requirement and Functions*: Illustrates the implemented functions and the requirements that they fulfill.
3. *Development Frameworks*: Describes the development frameworks and programming languages adopted for the project, along with a discussion of the advantages and disadvantages associated with these choices.
4. *Source Code*: Explains the structure of the backend and frontend source code.
5. *Testing*: Describes the test cases that were written for testing the application's functionalities.
6. *Installation Instructions*: Instructions for installation and deployment of the application.
7. *Effort spent*: Includes the amount of time dedicated by each member for the realization of each section of the document.
8. *References*: Reference to documents or tools used for writing this document.

= Requirement and Functions
This section illustrates the implementation status of each requirement defined in the Requirements and Specifications Document. The requirements that are not implemented are related to the "automatic recording" function, which was excluded as indicated by the _I&T_ assignment.
#heading(level: 4, numbering: none,  outlined: false,  "Account Management")

*R1*: The system shall allow an unauthenticated user to create an account. \
_Implemented_ \
*R2:* The system shall allow an unauthenticated user to sign into the app. \
_Implemented_ \
*R3*: The system shall allow an authenticated user to sign out from the app. \
_Implemented_ \
*R4*: The system shall allow an authenticated user to delete their account.\
_Implemented_ \

#heading(level: 4, numbering: none,  outlined: false,  "Permission Management")

*R5*: The system shall request the user’s permission to use a device capability. \
_Not implemented_ \

*R6*: The system shall properly handle user permission denial.\
_Not implemented_ \
#heading(level: 4, numbering: none,  outlined: false,  "Automatic Bike Path Recording")

*Start Recording* \
*R7*: The system shall allow the authenticated user to start the automatic recording mode of a bike path. \
_Not implemented_ \

*R8*: The system shall use the GPS to track the user’s real-time position during the trip. \
_Not implemented_ \

*R9*: The system shall use the device’s sensors to collect information about obstacles along the path and the speed of the user. \
_Not implemented_ \

*R10*: The system shall display the current trip data (current duration time, map of the path, average speed, top speed, weather conditions, distance covered) while the user is biking. \
_Not implemented_ \

*R11*: The system shall prompt the user for confirmation of a detected obstacle while biking. \
_Not implemented_ \

*R12*: The system shall allow the authenticated user to insert an obstacle manually.
_Not implemented_ \

*Stop Recording* \
*R13*: The system shall allow the authenticated user to manually stop the automatic recording of a bike path. \ 
_Not implemented_ \

*R14*: The system shall stop collecting GPS data once the authenticated user selects “Stop Recording”. \
_Not implemented_ \

*R15*: The system shall stop collecting sensor data once the authenticated user selects “Stop Recording”. \
_Not implemented_ \

*R16*: The system shall compute the status for the recorded path based on the frequency of obstacles. \
_Not implemented_ \

*R17*: The system shall store the path and its associated status in the authenticated user’s personal history. \
_Not implemented_ \

*R18*: The system shall cancel the recording if the accuracy of the GPS data drops under a certain threshold (over 10 meters for more than 15 seconds). \
_Not implemented_ \

*Pause and Resume* \
*R19*: The system shall automatically pause recording when the authenticated user stops biking. \
_Not implemented_ \

*R20*: The system shall automatically resume recording when the authenticated user starts biking. \
_Not implemented_ \

*R21*: The system shall allow the user to manually pause the recording. \
_Not implemented_ \

*R22*: The system shall allow the user to manually resume the recording. \
_Not implemented_ \

#heading(level: 4, numbering: none,  outlined: false,  "Manual Bike Path Insertion")

*R23:*The system shall allow the authenticated user to manually create a path by inserting a starting point, destination, intermediary stops and defining privacy and a quality status. \
_Implemented_ \

#heading(level: 4, numbering: none,  outlined: false,  "Personal History Management")

*User Bike Path List* \
*R24*: The system shall display a list of the user’s previously recorded paths in chronological order when accessing their history page.
_Implemented_ \

*User Bike Path Detail* \
*R25*: The system shall display all the collected data of a personal path when the user visits its dedicated page. \
_Implemented_ \

*R26*: The system shall allow the user to set the privacy status of the path. \
_Implemented_ \

*R27*: The system shall allow the user to delete their personal bike paths.\
_Implemented_ \

#heading(level: 4, numbering: none,  outlined: false,  "Community Bike Path Browsing")

*R28*: The system shall allow the user to browse publicly available bike paths by specifying a starting point and a destination. \
_Implemented_ \

*R29*: The system shall show the user the matching paths, sorting them by their system-computed average quality score (calculated based on the public user path instances). \
_Implemented_ \

*R30*: The system shall display for each path the route map along with the system-computed quality score. \
_Implemented_ \

*R31*: The system should display an alert badge if a path contains incompatible roads for biking. \
_Implemented_ \

*R32*: The system shall allow the user to select a path as the suggested route for a new automatic recording session.\
_Not implemented_ \

= Development Frameworks
Adopted development frameworks (this section could either include simply references
to sections in the DD where we find information about your choices and/or any new
choice that you have made):
a. Adopted programming languages and their advantages and disadvantages.
b. Any middleware you have adopted and its advantages and disadvantages.
c. Any API you did not include in the DD.

== Frameworks

=== Frontend
*Swift UI* \
The user interface was built using SwiftUI, Apple's declarative framework to build user interfaces across all Apple platforms. By defining the UI using it's MVVM model, the app maintains a reactive flow where the view updates automatically in response to data changes, significantly reducing the glue code typically required in UIKit. \

*SwiftUI-AsyncButton*\
A specialized Swift Package (installed via SPM) that extends standard button functionality to natively support asynchronous operations. It simplifies the UI lifecycle by automatically managing loading states and preventing redundant triggers during concurrent executions.

*SwiftUI-Introspect*\
A Swift Package used to access the underlying UIKit components of SwiftUI views. Specifically, it's here used to intercept the _UISheetPresentationController_ to implement advanced customizations for modal sheets—such as precise detent control and gestures that are central to the BBP app's user experience.

*Firebase iOS SDK*\
The core suite used to bridge the mobile client with backend services. It facilitates secure user authentication via Firebase Auth and provides the communication layer for invoking Cloud Functions, ensuring seamless data flow between the iOS app and the serverless environment.


*MapKit* \
MapKit was integrated to handle all geospatial requirements. It provides the core mapping interface, handles user location tracking, and renders the polyline paths that represent bike paths. It also provide the Directions API, that can be used to retrieve detailed step-by-step navigation and route data based on start and end points.

*WeatherKit* \
WeatherKit was integrated to retrieve current weather data during user path recording.

*CoreMotion* \
Used to obtain device motion data (accelerometers and gyros) and user activity detection.

*CoreLocation* \
Used to obtain user location and speed data.

=== Backend
*Firebase* \
The application's backend was implemented using Firebase Cloud Functions, deployed on Firebase’s serverless infrastructure. The cloud functions interact with the Cloud Firestore database via the Firebase Admin SDK, which ensures secure and privileged access to the project’s data without exposing credentials to the client. User Authentication is handled by Firebase Auth that enables secure access control and identity verification, ensuring that each user can only interact with their own data or authorized community resources through unique, cryptographically signed tokens.

*Geofire-Common* \
A specialized framework within the Firebase ecosystem, integrated to perform proximity searches in Firestore by leveraging geohashing for efficient spatial querying.

*Turf.js* \
A GeoJSON handling framework we adopted to enhance the robustness of path similarity algorithms

== Programming Languages
=== Frontend
*Swift* \
Swift is a strongly typed language used for Apple platforms development, in this case, iOS. It's known for its performance, safety, and modern syntax.

=== Backend
*TypeScript* \
The backend Cloud Functions are written in TypeScript, a superset of JavaScript that introduces static typing through optional type annotations. This allows many errors to be detected at compile time and provides clear information about the types of parameters each function accepts and the type of its returned value. The use of TypeScript  improves code readability, though it makes the code slightly more verbose and requires compilation to JavaScript before deployment.

= Source Code Structure
The project is organized into two primary repositories: the *iOS Client* and the *Firebase Backend*. This separation ensures a clean decoupling of concerns, where the mobile app handles user interaction and sensor data, while the cloud infrastructure manages data persistence and heavy geospatial calculations.

== iOS Client Structure
The Xcode project is organized into logical modules that separate by feature data management, UI components, and hardware interactions. This structure facilitates modular development and clear separation of concerns.

- *CapabilityAccess*: Manages the integration with hardware and system services. It includes `LocationManager`, `MotionManager`, and `WeatherManager`, acting as a bridge between Apple's native frameworks and the app's business logic.
- *CommunityPath*: Handles all features related to shared routes. It includes the data sourcing logic (`CommunityPathSource`) and the UI components for searching and displaying community-contributed paths.
- *Content*: The core UI container of the application. It hosts the `ContentMap`, the main `ContentView`, and the `Coordinator` pattern used to manage complex interactions between the map and the interface.
- *Extension*: Contains Swift extensions used to augment existing types. Notable examples include custom error handling (`AnyLocalizedError`) and UI state extensions for asynchronous operations.
- *Path & UserPath*: Dedicated modules for path data structures and user-specific route history, ensuring that the geographic logic is decoupled from the UI.
- *User*: Manages the user lifecycle, from identity models (`User`) to authentication and account management interfaces.
- *Modifiers & LocalSearch*: Specialized folders for custom SwiftUI view modifiers (like `SheetInsetting`) and location search auto-completion features.

== Firebase Backend (Functions Environment)
The backend logic is centralized within the `functions/` directory, structured to facilitate development, local emulation, and automated testing:

- *src*: The TypeScript source code.
  - *index.ts*: The entry point where Cloud Functions (HTTPS and Triggers) are exported.
  - *managers*: Module-specific logic (e.g., `pathManager.ts`, `userManager.ts`) that isolates business rules from the Firebase transport layer in `index.ts`.
  - *constants*: Shared constant value providing a single source-of-truth.
- *\_\_tests\_\_*: A comprehensive test suite using Jest. It contains unit tests for the manager modules, using mocked environments for Firestore and Turf.js to ensure logic reliability.
- *package.json*: Manages dependencies and defines scripts for linting, compiling, testing and deploying the functions.

== Dependency Management
The project relies on two main package managers:
- *SPM (Swift Package Manager)*: Used for all iOS third-party libraries, integrated directly into Xcode.
- *NPM (Node Package Manager)*: Used for the backend to manage TypeScript, Firebase Admin SDK, and geospatial libraries.


= Testing

This section outlines the verification strategies employed to ensure the application's reliability, ranging from individual logic components to the complete end-to-end user flow.

== Backend Business Logic Unit Testing

The backend business logic, implemented via Firebase Cloud Functions, was validated using the Jest framework. The primary objective was to verify the "Managers" in isolation, ensuring that geospatial algorithms and data processing rules remain accurate regardless of external infrastructure status.

=== Mocking Strategy and Isolation Due to the serverless nature of the backend, unit tests do not interact with live Firestore or Firebase Auth instances. Instead, a sophisticated mocking strategy was adopted to simulate the environment:

*Dependency Mocking* \
By utilizing `jest.mock()`, complex external modules such as `firebase-admin` and `@turf/turf` were replaced with stub implementations that return predictable data.

*Database Simulation* \
The hierarchical nature of Firestore queries (e.g., `collection().where().get()`) was reconstructed using nested Jest mocks. This allows the suite to simulate various database states easily (such as empty results, multiple document returns, or execution errors).

*Temporal Control* \
To validate time-sensitive logic (e.g., filtering out community reports older than a year), the Timestamp object was mocked to simulate specific points in time, ensuring the filtering logic behaves as expected.

=== Key Test Cases

*T1*: Community Status Calculation \
Verified that the system correctly aggregates user votes into a weighted average while successfully ignoring expired or invalid reports.

*T2*: Path Similarity Algorithm \
Validated the GeoJSON processing logic to ensure that routes are identified as "similar" even when minor GPS drifts occur, while distinct paths are correctly rejected.

AGGIUNGERE ALTRE

*Outcome*\
All unit tests passed successfully, achieving a code coverage of over 90% across core modules. This ensures that every non trivial logical branch (if/else) and error handler (catch) has been executed and verified.

== System Testing

System testing was performed to validate the integration between the iOS client and the Firebase backend, ensuring the "End-to-End" (E2E) flow satisfies the functional requirements.

- User Authentication
  - Sign In
  - Account Creation
- User Account
  - Sign Out
  - Account Deletion
- User Path Insertion
- User Path Recording
  - Manual Object Insertion
  - Automatic Object Detection
  - Manual Pause/Resume
  - Automatic Pause/Resume
- User Path Detail
  - Path Status Update
  - Path Privacy Update
  - Path Deletion
  - Start User Path Recording
- Community Path Search
- Community Path Detail
  - Start User Path Recording


=== Main Test Cases | Test Case | Description | Expected Outcome | Result | | :--- | :--- | :--- | :--- | | User Onboarding | New user signs up via the iOS app and initializes their profile. | User record created in Firebase Auth and Firestore User collection. | Pass | | Path Recording | Recording a bike path with CoreMotion/GPS and saving it. | Path polyline and sensor data correctly stored and visible in "My Paths". | Pass | | Community Discovery | Searching for paths near the current location using the map. | Relevant paths retrieved via Geohashing and rendered correctly on MapKit. | Pass | | Feedback Loop | Rating a community path and checking for status updates. | The communityPathManager updates the global status based on the new vote. | Pass |


= Installation Instructions

To distribute BBP on iOS, we utilize Apple's *TestFlight* platform. Depending on the current status of the Apple review process, there are two ways to access the build:

== Option 1: Public Link
If the build has already been approved by Apple, you can join the testing group immediately via the following link:
- #link("INSERT_LINK_HERE")[TestFlight Public Invitation]

== Option 2: Internal Testing (Manual Addition)
If the public link is not yet active, we will need to add you to our internal development team manually. Please follow these steps:

+ *Send your Apple ID email:* Provide us with the email address associated with your Apple account.
+ *Accept the Invitation:* You will receive an email from Apple via App Store Connect. You must click the link inside that email to authorize your device. If you never logged into App Store Connect you will have to log and accept the terms.
+ *Join the Group:* Once you have accepted the invite, we will add you to the "Internal Testers" group, and you will receive an email with a link to add BBP to your TestFlight dashboard.

== Prerequisites
- An iPhone running *iOS 26.0* or later.
- The *TestFlight* app (downloadable from the App Store).
- A valid Apple ID.

= Available acceptance testing infrastructure
THIS LIKE MANY OF BEFORE IS AI

We provide two primary environments for executing acceptance tests. While both are suitable for functional verification, physical hardware is required for final sign-off on hardware-dependent features.

== 1. Physical iOS Devices
The most reliable method for acceptance testing, ensuring the app behaves exactly as it will for the end user.
- *Scope:* Full access to hardware APIs (Camera, FaceID, Sensors, Bluetooth).
- *Network:* Testing under real-world conditions (5G, fluctuating Wi-Fi, airplane mode).
- *Performance:* Accurate profiling of thermal throttling and battery consumption.

== 2. iOS Simulator (macOS)
The iOS Simulator is part of the Xcode toolset. Note that this is a *simulator* (mimicking software behavior) rather than an *emulator* (mimicking hardware).
- *Environment:* Runs natively on macOS (Silicon/Intel), providing high performance for UI automation.
- *Constraints:*
    - *Hardware:* No support for Camera, Motion Sensors (Accelerometer/Gyroscope), or Bluetooth.
    - *Architecture:* Runs on `arm64` (Apple Silicon) or `x86_64` (Intel), which may hide memory-specific bugs present on physical ARM devices.
    - *Push Notifications:* Limited simulation; requires manual payload injection via JSON drag-and-drop.

=== Comparison Summary
#table(
  columns: (1fr, 1fr, 1fr),
  inset: 10pt,
  align: horizon,
  [*Feature*], [*Physical Device*], [*macOS Simulator*],
  [Hardware Sensors], [Fully Supported], [Not Supported],
  [Execution Speed], [Real-time], [Accelerated],
  [App Store/IAP], [Full Testing], [Sandbox Only],
  [Touch Gestures], [Multi-touch (10 fingers)], [Mouse/Pointer (Limited)]
)

= Effort Spent

#figure(
  table(
    columns: 4,
    table.header([], [*Foad Zahedi Labaf*], [*Lorenzo Fiamingo*], [*Alexander Gabriel Fox*]),
    [*Section 1*], [], [], [],
    [*Section 2*], [], [], [],
    [*Section 3*], [], [], [],
    [*Section 4*], [], [], [],
    [*Section 5*], [], [], [],
    [*Section 6*], [], [], [],
  ),
  caption: [The number of hours each group member has worked for this document]
)

= References

- *Typst* language and its online editor were used to build this document.
- *PlantUML* was used to define and create diagrams.
- *Draw.io* was used for the realization of architecture and deployment diagrams
- *Alloy* was used for formal modeling and analysis.
- *GitHub* was used for version control and to automate diagram generation.
- *Google Docs* was used for collaborative writing.
- *Xcode* and *SwiftUI* were used to create UI mockups.
- *ChatGPT* and *Grammarly* were used for grammatical corrections.

#show: backmatter.with()
