#import "@local/polimi:1.0.1": *
#import "@local/plantuml:0.1.0"

#show raw.where(lang: "plantuml"): it => image(plantuml.path(it.text))


#show: polimi-thesis.with(
  title: "Best Bike Paths",
  subtitle: "Design Document",
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

== Scope

== Definitions, Acronyms, Abbreviations

=== Definitions
*User*: Term used to indicate both authenticated and unauthenticated individuals who interact with the application.

*Authenticated User*: User who are authenticated in their BBP account. An authenticated user has full access to the functionalities offered by the application.

*Unauthenticated User*: Users who do not have a BBP account, or who have an account but aren't currently authenticated within the system. These users have limited access to the application's functionalities.

*Bike Path*: A bike path is a collection of information associated with a specific route. This information may refer to a single user trip and, in that case, includes performance-related data describing the user’s ride, as well as qualitative information about the route itself.  
The term bike path is also used to indicate the aggregated information derived from multiple user-specific bike paths that follow the same route. This information will therefore exclude individual performance data and primarily consists of aggregated data describing the overall quality of the route.

*Bike Trip*: A bike trip indicates a cycling session that may optionally be recorded by the application at the cyclist’s discretion. During the trip, data is collected from the device’s GPS and motion sensors and may be enriched with meteorological information.

*Meteorological Data*: Meteorological data refers to information describing the atmospheric conditions during a bike trip, such as weather conditions, temperature, and wind speed.

*Motion Sensors*: This term refers to the user’s device’s hardware components that allow for the collection of performance-related and qualitative data about the bike trip. 
Specifically, the gyroscope of the device is responsible for measuring angular velocity and is used to identify obstacles along the path.
The accelerometer is responsible for measuring the acceleration of the user during the trip and contributes both to obstacle detection and to the computation of the user’s velocity.

*Obstacle*: An obstacle is a physical irregularity located along a bike path that may negatively affect the safety of cyclists.
Obstacles can be automatically detected through the device’s motion sensors or manually reported by the user, and are used by the system to compute the overall quality of the path.

*SMTP Server*: An SMTP server, or email service provider, is an external system responsible for sending transactional emails on behalf of the application.

*Status*: Term used to indicate the overall assessment of a path's quality, which can be either manually specified by the user or computed by the system based on the frequency of obstacles along the path.

*History Page*: A user’s history page is a section of the user’s profile that displays a list of previously recorded bike trips and allows the user to access detailed information about each trip.

=== Acronyms

*API*: Application Programming Interface \
*BBP*: Best Bike Paths \
*CPU*: Central Processing Unit \
*CTA*: Call To Action \
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
*REST*: Representational State Transfer \
*SQL*: Structured Query Language \
*SMTP*: Simple Mail Transfer Protocol \
*TLS*: Transport Layer Security \
*Wi-Fi*: Wireless Fidelity \

=== Abbreviations

*G*: Goal \
*WP*: World Phenomenon \
*SP*: Shared Phenomenon \
*D*: Domain Assumption \
*UC*: Use Case

== Version History
 
- Version 1: 07/01/2026

== Reference Documents

The following reference materials were used for the preparation of this document:
- The specification for the 2025/26 Requirement Engineering and Design Project for the Software Engineering II course.
- The WeBeep slides of the Software Engineering II course.
- Requirements and Specification Documents from previous years
- European Union, *General Data Protection Regulation (EU) 2016/679*, 2016.
- #link("https://www.iso.org/standard/75405.html")[ISO/IEC, *ISO/IEC/IEEE 24748-8:2019 Systems and software engineering -- Life cycle management*, 2019].
- #link("https://developer.apple.com/design/human-interface-guidelines")[Apple Inc., *Apple Human Interface Guidelines*, online documentation].
- #link("https://m3.material.io")[Google LLC, *Material Design Guidelines*, online documentation].
- #link("https://developer.apple.com/documentation/coremotion")[Apple Inc., *Core Motion Framework Documentation*, online documentation].
- #link("https://developer.apple.com/documentation/corelocation")[Apple Inc., *Core Location Framework Documentation*, online documentation].
- #link("https://developer.apple.com/documentation/weatherkit/")[Apple Inc., *WeatherKit Framework Documentation*, online documentation].

== Document Structure

1. *Introduction*: A description of the project that highlights its functional description.
2. *Architectural Design*: A description of the overall architecture of the system, focusing on its main components, their responsibilities, and interactions.
3. *User Interface Design*: An overview of the system’s user interface, describing how users interact with the system and how information is presented.
4. *Requirements Traceability*: An explanation on how the functional and non-functional requirements defined in the RASD are mapped to the architectural and design elements introduced in this document.
5. *Implementation, Integration And Test Plan*: The order in which the subcomponents of the system are planned to be implemented, integrated and tested.
6. *Effort spent*: Includes the amount of time dedicated by each member for the realization of each section of the document.
7. *References*: Reference to documents or tools used for writing this document.

= Architectural Design
== Overview
High-level components and their interaction
== Component view
== Deployment view
== Runtime view
This section describes the dynamic behavior of the Best Bike Paths (BBP) system by illustrating the flow of messages exchanged among architectural components for the most relevant use cases defined in the RASD. \
The runtime view focuses on the main success scenarios and highlights how the system components collaborate to realize the required functionalities. \
For clarity and consistency with the Software Architecture lectures, the following aspects are intentionally omitted: \
authorization and access-control checks, \
error handling and exceptional flows, \
caching and optimization mechanisms.\ 
All sequence diagrams represent only the main execution path. \
The system frontend is represented exclusively by a Mobile Application (iOS/Android), as specified in the RASD. \
Each runtime scenario corresponds directly to a use case defined in the RASD. Some use cases are included even when they do not introduce new backend components because they involve critical runtime interactions with device sensors, which are architecturally relevant for the system. \

#pagebreak() 
*[UC1] Authentication (Sign In / Sign Up)*\
This sequence diagram shows the flow of messages for the Authentication use case, which covers both Account Creation (UC1) and User Sign In (UC2) as specified in the RASD. \
The user initiates the authentication process through the mobile application by entering an email address. The request is forwarded to the backend through the Application Proxy and the API Gateway. The User Management Service checks whether the email is already registered in the DBMS. \
If the email is already registered, the user proceeds with the sign-in flow by providing credentials; the system verifies them and returns an authentication token.
Otherwise, the user proceeds with the sign-up flow: the system sends a verification code via the SMTP Server, the user inserts the code, and the system creates a new account in the DBMS. In both cases, the user completes authentication and can access restricted functionalities. \
#let AuthenticationSequenceDiagram = ```plantuml
title UC1- Authentication (Sign In / Sign Up)
actor User
boundary "Mobile App" as App
control "Application Proxy" as Proxy
control "API Gateway" as GW
control "User Management Service" as UMS
database "Database" as DB
entity "SMTP Server" as SMTP
User -> App : Tap "Sign In"\nEnter email
App -> Proxy : checkEmail(email)
Proxy -> GW
GW -> UMS : checkEmail(email)
UMS -> DBMS : userExists(email)?
DBMS --> UMS : exists / notExists
UMS --> App : emailStatus(exists?)
alt Email already registered 
  User -> App : Enter password\nConfirm sign-in
  App -> Proxy : signIn(email,password)
  Proxy -> GW
  GW -> UMS : signIn(email,password)
  UMS -> DBMS : verifyCredentials(email,password)
  DBMS --> UMS : valid
  UMS --> App : authentication token
else Email not registered 
  App -> Proxy : requestVerificationCode(email)
  Proxy -> GW
  GW -> UMS : requestVerificationCode(email)
  UMS -> SMTP : sendVerificationCode(email, code)
  SMTP --> UMS : sent
  User -> App : Insert verification code\nEnter registration data
  App -> Proxy : createAccount(name,email,password,code)
  Proxy -> GW
  GW -> UMS : createAccount(name,email,password,code)
  UMS -> DBMS : createUser(...)
  DBMS --> UMS : OK
  UMS --> App : registration success (+ token if defined)
end 
```
#figure(
  AuthenticationSequenceDiagram,
  kind: image,
  caption: [Authentication (Sign In / Sign Up) Sequence Diagram]
)
#pagebreak()
*[UC2] Start Automatic Recording* \ 
This sequence diagram shows the flow of messages for the Start Automatic Recording use case. \
An authenticated user starts a new recording session through the mobile application. Before starting the recording, the application verifies that the required permissions (e.g., location and motion sensors) are granted. If permissions are available, the Data Collection Manager activates GPS and motion sensors and starts collecting trip data. The collected data is filtered by the Data Preprocessing Manager and stored locally, while the Trip Statistics Manager continuously computes real-time statistics (e.g., time, distance, speed) that are displayed to the user during the ride. \
This use case causes the recording state to transition from Stopped to Recording. \

#let StartAutomaticRecordingSequenceDiagram = ```plantuml
title UC2 - Start Automatic Recording
actor "Authenticated User" as User
boundary "Mobile App" as App
control "Permission Manager" as PM
control "Data Collection Manager" as DCM
control "Data Preprocessing Manager" as DPM
control "Trip Statistics Manager" as TSM
database "Local Storage" as LS
entity "GPS" as GPS
entity "Accelerometer" as ACC
entity "Gyroscope" as GYR
User -> App : Tap "Start Recording"
App -> PM : checkRequiredPermissions()
PM --> App : granted
App -> DCM : startCollection()
DCM -> GPS : startLocationUpdates()
DCM -> ACC : startUpdates()
DCM -> GYR : startUpdates()
loop While recording
GPS --> DCM : location + accuracy
ACC --> DCM : acceleration sample
GYR --> DCM : gyroscope sample
DCM -> DPM : preprocess(samples)
DPM -> LS : store(preprocessedData)
DPM -> TSM : notify(preprocessedData)
TSM --> App : updateUI(stats)
end
```
#figure(
  StartAutomaticRecordingSequenceDiagram,
  kind: image,
  caption: [Start Automatic Recording Sequence Diagram]
)
#pagebreak()

*[UC3] Automatic Pause and Resume* \
This sequence diagram shows the flow of messages for the Automatic Pause and Resume use case. \
During an active automatic recording session, the mobile application continuously monitors the user’s activity in order to determine whether the user is currently biking or not. This monitoring is performed by the Trip Statistics Manager, which analyzes the preprocessed data provided by the Data Collection Manager (e.g., GPS updates and motion sensor data). \
When the Trip Statistics Manager detects that the user has stopped biking, it triggers an automatic pause of the recording session by suspending data collection and pausing the trip timer shown in the user interface. \
When biking activity is detected again, the Trip Statistics Manager triggers the automatic resumption of the recording session by reactivating data collection and restarting the trip timer. \
This use case causes repeated transitions between the Recording and Paused states until the user explicitly stops the recording session. \

#let AutomaticPauseResumeSequenceDiagram = ```plantuml
title UC3 - Automatic Pause and Resume
boundary "Mobile App" as App
control "Trip Statistics Manager" as TSM
control "Data Collection Manager" as DCM
control "Data Preprocessing Manager" as DPM
loop While recording session is active
  DCM -> DPM : provideCollectedData()
  DPM -> TSM : providePreprocessedData()
  TSM -> TSM : evaluateUserActivity()
  alt User stops biking
    TSM -> DCM : pauseCollection()
    TSM -> DPM : pauseProcessing()
    TSM -> App : pauseTimerAndUI()
  else User resumes biking
    TSM -> DCM : resumeCollection()
    TSM -> DPM : resumeProcessing()
    TSM -> App : resumeTimerAndUI()
  end
end
```
#figure(
  AutomaticPauseResumeSequenceDiagram,
  kind: image,
  caption: [ Automatic Pause and Resume Sequence Diagram]
)
#pagebreak()
*[UC4] Manual Pause and Resume* \ 
This sequence diagram shows the flow of messages for the Manual Pause and Resume use case. \ 
During an active recording session, the authenticated user may explicitly pause or resume the recording through the mobile application interface. \
When the user selects the Pause action, the mobile application requests the suspension of data collection. The Data Collection Manager and the Data Preprocessing Manager suspend their activities, and the trip timer shown to the user is paused. \
When the user selects the Resume action, data collection and preprocessing are reactivated, and the trip timer resumes.
This use case causes explicit transitions between the Recording and Paused states, independently of automatic activity detection. \
The manual pause and resume action has priority over automatic pause and resume action. \


#let ManualPauseResumeSequenceDiagram = ```plantuml
title UC4 - Manual Pause and Resume

actor "Authenticated User" as User
boundary "Mobile App" as App
control "Data Collection Manager" as DCM
control "Data Preprocessing Manager" as DPM

alt User pauses recording
  User -> App : Tap "Pause"
  App -> DCM : pauseCollection()
  App -> DPM : pauseProcessing()
  App -> User : Show paused state
else User resumes recording
  User -> App : Tap "Resume"
  App -> DCM : resumeCollection()
  App -> DPM : resumeProcessing()
  App -> User : Show recording state
end

```
#figure(
  ManualPauseResumeSequenceDiagram,
  kind: image,
  caption: [Manual Pause and Resume Sequence Diagram]
)
#pagebreak()

== Component interfaces
== Selected architectural styles and patterns
Please explain which styles/patterns you used, why, and how
== Other design decisions
= User interface design
Provide an overview on how the user interface(s) of your system will
look like; if you have included this part in the RASD, you can simply refer to what you have
already done, possibly providing here some extensions if applicable.
= Requirements Traceability
Explain how the requirements you have defined in the RASD
map to the design elements that you have defined in this document.
= Implementation, Integration And Test Plan
Identify here the order in which you plan
to implement the subcomponents of your system and the order in which you plan to integrate
such subcomponents and test the integration.



#heading(level: 4, numbering: none,  outlined: false,  "Account Management")

#heading(level: 4, numbering: none,  outlined: false,  "Permission Management")

#heading(level: 4, numbering: none,  outlined: false,  "Automatic Bike Path Recording")

#heading(level: 4, numbering: none,  outlined: false,  "Manual Bike Path Insertion")

#heading(level: 4, numbering: none,  outlined: false,  "Personal History Management")

#heading(level: 4, numbering: none,  outlined: false,  "Community Bike Path Browsing")


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
  ),
  caption: [The number of hours each group member has worked for this document]
)

= References

- *Typst* language and its online editor were used to build this document.
- *PlantUML* was used to define and create diagrams.
- *Alloy* was used for formal modeling and analysis.
- *GitHub* was used for version control and to automate diagram generation.
- *Google Docs* was used for collaborative writing.
- *Xcode* and *SwiftUI* were used to create UI mockups.
- *ChatGPT* and *Grammarly* were used for grammatical corrections.


#show: backmatter.with()


