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
When engaging in any sport or physical activity, people quickly realize how important it is to log their performance, which helps maintain motivation and enables steady progress over time. \
It is also important to share this knowledge with the community, allowing less knowledgeable users to make safer and more informed decisions. \
The primary goal of the Best Bike Paths application is to provide its users with an intuitive software application that addresses both these needs. Specifically, it helps cyclists track their own routes while also discovering the safest and most reliable paths previously traveled by fellow users. \

== Purpose
The BBP application allows its users to interact with its constantly evolving database of bike paths recorded by others. After specifying a starting point and destination, the system will provide the user with a visual representation of the highest-quality bike paths connecting the two points. The quality of a bike path depends on a variety of parameters, including the frequency of encountered obstacles and the freshness of the collected data.
Once a path is selected, the user can view it on a map and follow it during their ride.
Authenticated users will be able to access the additional features, such as the automatic recording function, which collects data from the GPS, gyroscope, and accelerometer of the device while the user is travelling along the path and stores the data once the recording ends. The collected information will be processed by the system, allowing the user to view performance-related data and additional qualitative information about the travelled path after navigating to the corresponding section of the application. 
Additionally, the users will also be allowed to manually insert bike paths by specifying the necessary information, such as street names, obstacles, and status.
To maximize the performance of this application, a three-tiered architecture will be adopted, assigning to each tier the implementation of the presentation, application, and data layers, respectively. To optimize server load and response time, a microservice approach will be used for the back-end of the application.
Additional details regarding the application functions and architectural decisions will be provided in the following section.

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
*[UC5] Stop Recording and Save Trip* \
This sequence diagram shows the flow of messages for the Stop Recording and Save Trip use case. \
During an active recording session, the authenticated user ends the recording by selecting the Stop action in the mobile application and confirming the choice. The mobile application terminates GPS and sensor acquisition through the Data Collection Manager, finalizes the trip data stored locally, and prepares the trip package for persistence. \
The trip package is then submitted to the backend through the Application Proxy and the API Gateway. The Path Recording Service optionally enriches the trip with meteorological information by invoking the Weather API and reconstructs the travelled route using the Maps API. The service computes the required trip indicators (e.g., statistics and path status) and stores the finalized path in the DBMS. Finally, the mobile application is notified of the successful operation and the path becomes available in the user’s personal history. \This use case causes the recording state to transition from Recording to Stopped. \

#let StopRecordingSaveTripSequenceDiagram = ```plantuml
title UC5 - Stop Recording and Save Trip
actor "Authenticated User" as User
boundary "Mobile App" as App
control "Data Collection Manager" as DCM
database "Local Storage" as LS
control "Application Proxy" as Proxy
control "API Gateway" as GW
control "Path Recording Service" as PRS
database "DBMS" as DB
entity "Weather API" as WAPI
entity "Maps API" as MAPI
User -> App : Tap "Stop Recording"
App -> User : Show confirmation dialog
User -> App : Confirm
App -> DCM : stopLocationAndSensorUpdates()
DCM --> App : stopped
App -> LS : finalizeTripPackage()
App -> Proxy : submitRecordedTrip(tripPackage)
Proxy -> GW : forwardRequest()
GW -> PRS : submitRecordedTrip(tripPackage)
opt Meteorological enrichment
  PRS -> WAPI : getWeather(location, time)
  WAPI --> PRS : weather data
end
opt Route reconstruction
  PRS -> MAPI : reconstructRoute(locations[])
  MAPI --> PRS : route/streets
end
PRS -> PRS : computeStatisticsAndStatus()
PRS -> DB : storeTrip(userId, tripData)
DB --> PRS : OK
PRS --> GW : OK
GW --> App : OK
App -> User : Show saved / redirect to history
```

#figure(
  StopRecordingSaveTripSequenceDiagram,
  kind: image,
  caption: [ Stop Recording and Save Trip Sequence Diagram]
)
#pagebreak()
*[UC6] Automatic Obstacle Detection* \
This sequence diagram shows the flow of messages for the Automatic Obstacle Detection use case. \
During an active recording session, the mobile application continuously collects motion sensor data and preprocesses it. The Obstacle Detection Manager analyzes the preprocessed sensor stream to identify potential obstacles encountered along the ride. \
When a potential obstacle is detected, the mobile application shows a timed confirmation notification to the user. If the user confirms the notification or does not respond within the allowed timeout, the obstacle is considered valid and is associated with the ongoing recording session. If the user rejects the notification, the obstacle is discarded. \
The accepted obstacle is stored locally together with the trip data and contributes to the obstacle statistics of the current recording. \
This use case does not terminate the recording session; it can occur multiple times while the recording state remains Recording. \

#let AutomaticObstacleDetectionSequenceDiagram = ```plantuml
title UC6 - Automatic Obstacle Detection
actor "Authenticated User" as User
boundary "Mobile App" as App
control "Data Collection Manager" as DCM
control "Data Preprocessing Manager" as DPM
control "Obstacle Detection Manager" as ODM
database "Local Storage" as LS
loop While recording session is active
  DCM -> DPM : provideCollectedSensorData()
  DPM -> ODM : providePreprocessedSensorData()
  ODM -> ODM : detectObstacle()
  alt Obstacle detected
    ODM -> App : showTimedConfirmationAlert()
    opt User confirms
      App -> ODM : confirmObstacle()
    end
    opt User rejects
      App -> ODM : rejectObstacle()
    end
    opt User ignores (timeout)
      ODM -> ODM : autoAcceptObstacle()
    end
    alt Accepted
      ODM -> LS : storeObstacle(currentTrip, obstacle)
      ODM -> App : updateObstacleCountUI()
    else Rejected
      ODM -> App : discardObstacle()
    end
  end
end
```

#figure(
  AutomaticObstacleDetectionSequenceDiagram,
  kind: image,
  caption: [Automatic Obstacle Detection Sequence Diagram]
)
#pagebreak()
*[UC7] Manual Obstacle Insertion* \
This sequence diagram shows the flow of messages for the Manual Obstacle Insertion use case. \
During an active recording session, the authenticated user may manually report an obstacle through the mobile application interface. When the user performs the “Add Obstacle” action, the application creates a new obstacle entry associated with the current recording session and stores it locally together with the trip data. The user interface is updated to reflect the new obstacle count. \
This use case may occur multiple times while the recording state remains Recording, and it does not terminate or pause the recording session. \

#let ManualObstacleInsertionSequenceDiagram = ```plantuml
title UC7 - Manual Obstacle Insertion
actor "Authenticated User" as User
boundary "Mobile App" as App
control "Obstacle Detection Manager" as ODM
database "Local Storage" as LS
User -> App : Tap "Add Obstacle"
App -> ODM : registerManualObstacle()
ODM -> LS : storeObstacle(currentTrip, obstacle)
ODM --> App : updateObstacleCountUI()
```

#figure(
ManualObstacleInsertionSequenceDiagram,
  kind: image,
  caption: [Manual Obstacle Insertion Sequence Diagram]
)
#pagebreak()
*[UC8] Manual Path Insertion* \
This sequence diagram shows the flow of messages for the Manual Path Insertion use case. \ An authenticated user manually creates a bike path by specifying a starting point, a destination, and optional intermediate stops through the mobile application. For each inserted location, the mobile application interacts with an external Maps API to translate the provided address into geographic coordinates and to visualize the path on the map. \
After defining the complete path, the user selects the desired path quality status and privacy level. The mobile application then submits the manually created path to the backend through the Application Proxy and the API Gateway. The Path Recording Service validates and stores the path in the DBMS, making it available in the user’s personal history. \
This use case does not involve sensor data acquisition and does not affect the recording state. \

#let ManualPathInsertionSequenceDiagram = ```plantuml
title UC8 - Manual Path Insertion
actor "Authenticated User" as User
boundary "Mobile App" as App
entity "Maps API" as MAPI
control "Application Proxy" as Proxy
control "API Gateway" as GW
control "Path Recording Service" as PRS
database "DBMS" as DB
User -> App : Open "Manual Path Creation"
loop For each inserted location
  User -> App : Insert address
  App -> MAPI : reverseGeocode(address)
  MAPI --> App : coordinates
  App -> App : updateMap(coordinates)
end
User -> App : Select status and privacy
User -> App : Tap "Save Path"
App -> Proxy : submitManualPath(pathData)
Proxy -> GW : forwardRequest()
GW -> PRS : submitManualPath(pathData)
PRS -> DB : storeManualPath(userId, pathData)
DB --> PRS : OK
PRS --> App : confirmation
```

#figure(
ManualPathInsertionSequenceDiagram,
  kind: image,
  caption: [Manual Path Insertion Sequence Diagram]
)
#pagebreak()
*[UC9] Show Detailed View (Personal History)* \
This sequence diagram shows the flow of messages for the Show Detailed View use case. \
An authenticated user accesses their personal history through the mobile application. The application requests the list of the user’s recorded paths from the backend through the Application Proxy and the API Gateway. The Personal Paths Service retrieves the user’s paths from the DBMS (typically ordered by date) and returns the list to the mobile application. \
After the user selects a specific path, the mobile application requests the corresponding detailed information. The Personal Paths Service retrieves the complete data for the selected path from the DBMS, including route information and stored indicators. If available, the returned details may also include contextual information such as meteorological data associated with that trip. The mobile application then displays the detailed view to the user. \ 
This use case does not modify stored data; it only reads and visualizes information. \ 

#let ShowDetailedViewSequenceDiagram = ```plantuml
title UC9 - Show Detailed View (Personal History)
actor "Authenticated User" as User
boundary "Mobile App" as App
control "Application Proxy" as Proxy
control "API Gateway" as GW
control "Personal Paths Service" as PPS
database "DBMS" as DB
User -> App : Open "History"
App -> Proxy : getUserPaths(userId)
Proxy -> GW : forwardRequest()
GW -> PPS : getUserPaths(userId)
PPS -> DB : fetchPathsByUser(userId)
DB --> PPS : pathsList
PPS --> GW : pathsList
GW --> App : showPaths(pathsList)
User -> App : Select a path
App -> Proxy : getPathDetails(pathId)
Proxy -> GW : forwardRequest()
GW -> PPS : getPathDetails(pathId)
PPS -> DB : fetchPathDetails(pathId)
DB --> PPS : pathDetails
PPS --> GW : pathDetails
GW --> App : showDetails(pathDetails)
```

#figure(
ShowDetailedViewSequenceDiagram,
  kind: image,
  caption: [Show Detailed View Sequence Diagram]
)
#pagebreak()
*[UC10] Set Bike Path Privacy* \
This sequence diagram shows the flow of messages for the Set Bike Path Privacy use case. \
An authenticated user changes the visibility of one of their previously stored bike paths by updating its privacy status. The user accesses the detailed view of a path through the mobile application and selects the desired privacy level (public or private). \
The mobile application forwards the update request to the backend through the Application Proxy and the API Gateway. The Personal Paths Service updates the privacy attribute of the selected path in the DBMS. Once the operation is completed, the mobile application is notified and reflects the updated visibility status. \
This use case causes a state transition of the path visibility between Private and Public, without modifying the recorded path data. \

#let SetBikePathPrivacySequenceDiagram = ```plantuml
title UC10 - Set Bike Path Privacy
actor "Authenticated User" as User
boundary "Mobile App" as App
control "Application Proxy" as Proxy
control "API Gateway" as GW
control "Personal Paths Service" as PPS
database "DBMS" as DB
User -> App : Open path details
User -> App : Change privacy setting\n(Public / Private)
App -> Proxy : setPathPrivacy(pathId, visibility)
Proxy -> GW : forwardRequest()
GW -> PPS : setPathPrivacy(pathId, visibility)
PPS -> DB : updatePrivacy(pathId, visibility)
DB --> PPS : OK
PPS --> GW : OK
GW --> App : confirmation
App -> User : Show updated privacy state
```

#figure(
SetBikePathPrivacySequenceDiagram,
  kind: image,
  caption: [Set Bike Path Privacy Sequence Diagram]
)
#pagebreak()
*[UC11] Delete Bike Path* \
This sequence diagram shows the flow of messages for the Delete Bike Path use case. \
An authenticated user deletes one of their previously stored bike paths from their personal history. The user accesses the detailed view of the selected path and requests deletion. The mobile application shows a confirmation dialog to avoid accidental deletions; after confirmation, the deletion request is forwarded to the backend through the Application Proxy and the API Gateway. \
The Personal Paths Service removes the path and its related stored data from the DBMS. Once the operation completes, the mobile application refreshes the history list and the deleted path is no longer available. \
This use case causes a state transition of the selected path from Existing to Deleted in persistent storage. \ 

#let DeleteBikePathSequenceDiagram = ```plantuml
title UC11 - Delete Bike Path
actor "Authenticated User" as User
boundary "Mobile App" as App
control "Application Proxy" as Proxy
control "API Gateway" as GW
control "Personal Paths Service" as PPS
database "DBMS" as DB
User -> App : Open path details
User -> App : Tap "Delete Path"
App -> User : Show confirmation dialog
User -> App : Confirm deletion
App -> Proxy : deletePath(pathId)
Proxy -> GW : forwardRequest()
GW -> PPS : deletePath(pathId)
PPS -> DB : deletePath(pathId)
DB --> PPS : OK
PPS --> GW : OK
GW --> App : deletion confirmed
App -> Proxy : getUserPaths(userId)
Proxy -> GW : forwardRequest()
GW -> PPS : getUserPaths(userId)
PPS -> DB : fetchPathsByUser(userId)
DB --> PPS : updatedPathsList
PPS --> GW : updatedPathsList
GW --> App : showUpdatedHistory(updatedPathsList)
```

#figure(
DeleteBikePathSequenceDiagram,
  kind: image,
  caption: [Delete Bike Path Sequence Diagram]
)
#pagebreak()
*[UC12] Browse Community Paths* \
This sequence diagram shows the flow of messages for the Browse Community Paths use case. \
A user (authenticated or not) searches for bike paths between an origin and a destination through the mobile application. The request is forwarded to the backend through the Application Proxy and the API Gateway and handled by the Path Recommendation Service. \
The service retrieves candidate public paths from the DBMS and computes a ranking according to the path quality and available metadata, as defined in the RASD. The ranked results are returned to the mobile application, which visualizes them on a map using the Maps API. If a path contains incompatible roads, the mobile application highlights this information to the user. \
If the user is authenticated, they may select one of the suggested community paths and start a new recording session with the selected path shown as a suggested route. \
This use case does not modify community data; it only reads and visualizes public paths. \

#let BrowseCommunityPathsSequenceDiagram = ```plantuml
title UC12 - Browse Community Paths
actor User
boundary "Mobile App" as App
control "Application Proxy" as Proxy
control "API Gateway" as GW
control "Path Recommendation Service" as PRS
database "DBMS" as DB
entity "Maps API" as MAPI
User -> App : Open "Find Paths"\nEnter origin + destination\nTap "Search"
App -> Proxy : searchCommunityPaths(origin, destination)
Proxy -> GW : forwardRequest()
GW -> PRS : searchCommunityPaths(origin, destination)
PRS -> DB : fetchPublicCandidatePaths(origin, destination)
DB --> PRS : candidatePaths + metadata
PRS -> PRS : rankPaths(candidatePaths, metadata)
PRS --> GW : rankedPaths + compatibilityInfo
GW --> App : rankedPaths + compatibilityInfo
App -> MAPI : renderPathsOnMap(rankedPaths)
MAPI --> App : map updated
App -> User : Show ranked list\nHighlight incompatible roads
opt User is authenticated
  User -> App : Select suggested path
  App -> User : Open recording screen\nwith suggested route
end
```

#figure(
BrowseCommunityPathsSequenceDiagram,
  kind: image,
  caption: [Browse Community Paths Sequence Diagram]
)
#pagebreak()
*[UC13] Sign Out* \
This sequence diagram shows the flow of messages for the Sign Out use case. \ 
An authenticated user ends their session by selecting the logout action in the mobile application. Since authentication is managed through a token/session stored locally on the device, signing out is performed by removing the locally stored authentication information. \ 
After the token is deleted, the mobile application returns to an unauthenticated state and the user can no longer access restricted functionalities until they authenticate again. \ 
This use case causes the authentication state to transition from Authenticated to Unauthenticated, without modifying any persistent data in the backend. \

#let SignOutSequenceDiagram = ```plantuml
title UC13 - Sign Out
actor "Authenticated User" as User
boundary "Mobile App" as App
User -> App : Tap "Logout"
App -> User : Show confirmation dialog
User -> App : Confirm
App -> App : clearLocalToken()/clearSession()
App -> User : Show unauthenticated state
```

#figure(
SignOutSequenceDiagram,
  kind: image,
  caption: [Sign Out Sequence Diagram]
)
#pagebreak()
*[UC14] Account Deletion* \
This sequence diagram shows the flow of messages for the Account Deletion use case. \
An authenticated user requests the deletion of their account through the mobile application. The application shows a confirmation dialog to prevent accidental deletions. After confirmation, the request is forwarded to the backend through the Application Proxy and the API Gateway. \
The User Management Service removes the user account and the related account data from the DBMS. Once the deletion is completed, the mobile application is notified and the user is returned to an unauthenticated state, since the account no longer exists. \
This use case causes the authentication state to transition from Authenticated to Unauthenticated and permanently removes the user account from persistent storage. \

#let AccountDeletionSequenceDiagram = ```plantuml
title UC14 - Account Deletion
actor "Authenticated User" as User
boundary "Mobile App" as App
control "Application Proxy" as Proxy
control "API Gateway" as GW
control "User Management Service" as UMS
database "DBMS" as DB
User -> App : Tap "Delete Account"
App -> User : Show confirmation dialog
User -> App : Confirm deletion
App -> Proxy : deleteAccount(userId)
Proxy -> GW : forwardRequest()
GW -> UMS : deleteAccount(userId)
UMS -> DB : deleteAccountData(userId)
DB --> UMS : OK
UMS --> GW : OK
GW --> App : deletion confirmed
App -> App : clearLocalSession()
App -> User : Show unauthenticated state
```

#figure(
AccountDeletionSequenceDiagram,
  kind: image,
  caption: [Account Deletion Sequence Diagram]
)
#pagebreak()

== Component interfaces
== Selected architectural styles and patterns
Please explain which styles/patterns you used, why, and how
== Other design decisions

= User Interface Design
=== User Interfaces

As already stated in the RASD, Best Bike Paths will be an app for mobile devices (iOS and Android). 
The User Interface will be optimized for touch screens and will follow their platform device guidelines (Human Interface Guidelines for iOS and Material Design for Android). Compliance with these standards ensures a consistent user experience and facilitates the implementation of accessibility best practices.
User interaction occurs through touch input, gestures, and native UI components.
Since the app relies on motion and location device features, the interface will include UI elements to request permission to interact with these device capabilities, following the platform-specific guidelines.

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Account Management")
When an unauthenticated user open the app, @ui-account-management-home-unauthenticated is shown. From here the user can start browsing community bike paths, or sign into the app.

When an authenticated user open the app @ui-account-management-home-authenticated is shown. From here the user can start browsing community bike paths, access their bike path history, add or record a new bike path.

The user can access the account page by tapping the account button, located in the trailing section of the navigation bar in both @ui-account-management-home-unauthenticated and @ui-account-management-home-authenticated. The user can also access the account page by tapping the sign in button in @ui-account-management-home-unauthenticated.

*Unauthenticated Account Page* \
If the unauthenticated user navigates to the account page a new modal replace the _Community Bike Paths_ one as shown in @ui-account-management-home-account-unhauthenticated. The user can now fill the email text field as in @ui-account-management-home-account-unhauthenticated-filled and submit. 

If the email is not registered with an existing user account, the sign up flow starts by showing a text field for verifying the user provided email as in @ui-account-management-account-emailverification. The user fill with the received verification code as in @ui-account-management-account-emailverification-filled and submit. The sign up form in @ui-account-management-account-signup is shown and the user fill it as in @ui-account-management-account-signup-filled. After submitting the form the user is authenticated with their new account and @ui-account-management-home-authenticated is shown.

If the email is registered with an existing user account, the sign in flow starts by showing a password secure text field for verifying the user credential as in @ui-account-management-account-signin. The user fill with the account password as in @ui-account-management-account-signin-filled and submit. If the password is wrong @ui-account-management-account-signin-wrongpassword is shown. Otherwise, the user is authenticated with their account and @ui-account-management-home-authenticated is shown.

*Authenticated Account Page* \
If the authenticated user navigates to the account page @ui-account-management-account-authorized modal is shown. From here the user can sign out or cancel their account. Since those actions are disruptive a confirmation dialog is presented before performing them, as shown in @ui-account-management-account-authorized-signoutconfirmation and @ui-account-management-account-authorized-deleteaccountconfirmation

#pagebreak()
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 45%)[
      #figure(
        image("ui/account-management/home-unauthenticated.png", width: 66.7%),
          caption: [Home page as unauthenticated user]
      ) <ui-account-management-home-unauthenticated>
    ]
  ][
  ][
    #block(width: 45%)[
      #figure(
        image("ui/account-management/home-authenticated.png", width: 66.7%),
          caption: [Home page as authenticated user]
      ) <ui-account-management-home-authenticated>
    ]
  ]
]
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 45%)[
      #figure(
        image("ui/account-management/account-unhauthenticated.png", width: 66.7%),
          caption: [Account page as unauthenticated user]
      ) <ui-account-management-home-account-unhauthenticated>
    ]
  ][
  ][
    #block(width: 45%)[
      #figure(
        image("ui/account-management/account-unhauthenticated-filled.png", width: 66.7%),
          caption: [Account page as authenticated user after entering data]
      ) <ui-account-management-home-account-unhauthenticated-filled>
    ]
  ]
]
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 45%)[
      #figure(
        image("ui/account-management/account-emailverification.png", width: 66.7%),
          caption: [Account email verification page]
      ) <ui-account-management-account-emailverification>
    ]
  ][
  ][
    #block(width: 45%)[
      #figure(
        image("ui/account-management/account-emailverification-filled.png", width: 66.7%),
          caption: [Account email verification page after entering data]
      ) <ui-account-management-account-emailverification-filled>
    ]
  ]
]
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 45%)[
      #figure(
        image("ui/account-management/account-signup.png", width: 66.7%),
          caption: [Account sign-up page]
      ) <ui-account-management-account-signup>
    ]
  ][
  ][
    #block(width: 45%)[
      #figure(
        image("ui/account-management/account-signup-filled.png", width: 66.7%),
          caption: [Account sign-up page after entering data]
      ) <ui-account-management-account-signup-filled>
    ]
  ]
]
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 30%)[
      #figure(
        image("ui/account-management/account-signin.png"),
          caption: [Account sign-up page]
      ) <ui-account-management-account-signin>
    ]
  ][
    #block(width: 30%)[
      #figure(
        image("ui/account-management/account-signin-filled.png"),
          caption: [Account sign-up page after entering data]
      ) <ui-account-management-account-signin-filled>
    ]
  ][
    #block(width: 30%)[
      #figure(
        image("ui/account-management/account-signin-wrongpassword.png"),
          caption: [Account sign-in page after entering wrong password]
      ) <ui-account-management-account-signin-wrongpassword>
    ]
  ]
]
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 30%)[
      #figure(
        image("ui/account-management/account-authorized.png"),
          caption: [Account page as authorized user]
      ) <ui-account-management-account-authorized>
    ]
  ][
    #block(width: 30%)[
      #figure(
        image("ui/account-management/account-authorized-signoutconfirmation.png"),
          caption: [Account page as authorized user sign-out confirmation dialog]
      ) <ui-account-management-account-authorized-signoutconfirmation>
    ]
  ][
    #block(width: 30%)[
      #figure(
        image("ui/account-management/account-authorized-deleteaccountconfirmation.png"),
          caption: [Account page as authorized user delete account confirmation dialog]
      ) <ui-account-management-account-authorized-deleteaccountconfirmation>
    ]
  ]
]

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Permission Management")

When the system needs a capability permission for a feature, for example the user location to record bike path, a sheet modal is shown.

*Not Determined Permission Page* \
If the capability is available and the user never denied the authorization (from the system dialog), @ui-capability-management-requestcapability-notdetermined is shown.
Here the user can see what capability the app need to access and why.
If the user decide to give their permission, the system dialog in @ui-capability-management-requestcapability-notdetermined-systemdialog is shown, and the user can allow the app to user the capability.
Otherwise the user can close the modal and don't use the app feature.

*Denied Permission Page* \
If the capability is available and the user denied the authorization (from the system dialog) @ui-capability-management-requestcapability-denied is shown.
Here the user can see what capability the app need to access and why.
If the user decide to give their permission, they must open settings and change the access authorization status manually. 
Otherwise the user can close the modal and don't use the app feature.

*Unavailable Permission Page* \
If the capability is unavailable @ui-capability-management-requestcapability-unavailable is shown. 
Here the user can see what capability the app need to access and why.
The user can just close the modal and don't use the app feature.

#pagebreak()
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 45%)[
      #figure(
        image("ui/capability-management/requestcapability-notdetermined.png", width: 66.7%),
          caption: [Request capability page when capability access is not determined]
      ) <ui-capability-management-requestcapability-notdetermined>
    ]
  ][
  ][
    #block(width: 45%)[
      #figure(
        image("ui/capability-management/requestcapability-notdetermined-systemdialog.png", width: 66.7%),
          caption: [System capability authorization dialog]
      ) <ui-capability-management-requestcapability-notdetermined-systemdialog>
    ]
  ]
]
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 45%)[
      #figure(
        image("ui/capability-management/requestcapability-denied.png", width: 66.7%),
          caption: [Request capability page when capability access is denied]
      ) <ui-capability-management-requestcapability-denied>
    ]
  ][
  ][
    #block(width: 45%)[
      #figure(
        image("ui/capability-management/requestcapability-unavailable.png", width: 66.7%),
          caption: [Request capability page when capability access is unavailable]
      ) <ui-capability-management-requestcapability-unavailable>
    ]
  ]
]

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Automatic Bike Path Recording")

When the authenticated user open the path record page a full-screen map and a modal sheet are shown.

*Idle Recording Page* \
When the recoding is idle @ui-automatic-path-recording-pathrecording-idle is shown.  \
The map shows the user marker (and a suggested route, if it was selected before).\
The modal shows a stopwatch, the weather data (if available) and the start button. \
distance), the pause button and the add obstacle button. \
The recording can be started manually by the user or automatically by the app when the user start cycling (if motion capability access is available). \

*Active Recording Page* \
When the recording is active @ui-automatic-path-recording-pathrecording-active is shown. \
The map shows the user marker, start marker, and the followed route (and a suggested route, if it was selected before). \
The modal shows the running stopwatch, the weather data (if available), the performance data (all of them if motion capability access is available, otherwise only distance), the pause button and the add obstacle button. \
The recording can be paused manually by the user or automatically by the app when the user stop cycling (if motion capability access is available). \
An obstacle can be registered manually by the user or automatically by the app when the device shakes (if motion capability access is available). When an obstacle is registered an alert notification is presented, as in @ui-automatic-path-recording-pathrecording-obstaclealert, to confirm or cancel the obstacle detection, if the notification is ignored the obstacle detection is confirmed.

*Paused Recording Page* \
When the recording is paused @ui-automatic-path-recording-pathrecording-paused is shown. \
The map shows the user marker, start location, and the followed route (and a suggested route, if it was selected before). \
The modal shows the stopwatch, the weather data (if available), the performance data (all of them if motion capability access is available, otherwise only distance), the resume button, the stop button and the add obstacle button. \
The recording can be resumed manually by the user or automatically by the app when the user start cycling (if motion capability access is available). \
An obstacle can be registered manually by the user. When an obstacle is registered an alert notification is presented to confirm or cancel the obstacle detection, if the notification is ignored the obstacle detection is confirmed.

*Stopped Recording Page* \
When the recording is paused @ui-automatic-path-recording-pathrecording-paused is shown. \
The map shows the user marker, start marker, the followed route and end marker. \
The modal shows the stopwatch, the weather data (if available), the performance data (all of them if motion capability access is available, otherwise only distance), the calculated path road status, the path privacy status toggle and the save button. \


#pagebreak()
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 30%)[
      #figure(
        image("ui/automatic-path-recording/pathrecording-idle.png"),
          caption: [Recording page before starting]
      ) <ui-automatic-path-recording-pathrecording-idle>
    ]
  ][
    #block(width: 30%)[
      #figure(
        image("ui/automatic-path-recording/pathrecording-active.png"),
          caption: [Recording page while active]
      ) <ui-automatic-path-recording-pathrecording-active>
    ]
  ][
    #block(width: 30%)[
      #figure(
        image("ui/automatic-path-recording/pathrecording-obstaclealert.png"),
          caption: [Recording page notification after an obstacle is detected or inserted by the user]
      ) <ui-automatic-path-recording-pathrecording-obstaclealert>
    ]
  ]
]
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 45%)[
      #figure(
        image("ui/automatic-path-recording/pathrecording-paused.png", width: 66.7%),
          caption: [Recording page when paused]
      ) <ui-automatic-path-recording-pathrecording-paused>
    ]
  ][
  ][
    #block(width: 45%)[
      #figure(
        image("ui/automatic-path-recording/pathrecording-stopped.png", width: 66.7%),
          caption: [Recording page when stopped]
      ) <ui-automatic-path-recording-pathrecording-stopped>
    ]
  ]
]

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Manual Bike Path Insertion")

When the authenticated user open the path insertion page a full-screen map and a modal sheet are shown.

The map shows the user marker, the markers of the locations provided by the user, and the route connecting them.
The modal shows the road status stepper for the path, the path privacy status, a list of the locations composing the route, and a search bar to look up locations.
\ \ \ \ \ \ \ \ \ \ \ \ \ \ 


#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 45%)[
      #figure(
        image("ui/manual-path-insertion/pathinsertion.png", width: 66.7%),
          caption: [Insertion page]
      ) <ui-manual-path-insertion-pathinsertion>
    ]
  ][
  ][
    #block(width: 45%)[
      #figure(
        image("ui/manual-path-insertion/pathinsertion-filled.png", width: 66.7%),
          caption: [Insertion page after entering data]
      ) <ui-manual-path-insertion-pathinsertion-filled>
    ]
  ]
]

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Personal History Management")

When the authenticated user open the app and has at least recorded or added one path, the history page is shown has in @ui-personal-path-history-hystory.

When the user select a path a full-screen map and a modal sheet are shown as in @ui-personal-path-history-history-detail and @ui-personal-path-history-history-detail-fullscreen. \
The map shows the path route, start marker, end marker and, if the path was added manually, all the locations provided by the user to compose it. \
The modal shows all the available path information, the path route status stepper (if path was manually added), the path privacy status toggle, the record new path button and the delete button. \
When the user edits the path information (with the toggle or the stepper), the confirm button on the trailing section of the modal navigation bar is enabled, as in @ui-personal-path-history-history-detail-edited. \
When the user starts a new path from here, a bike path recording session begins, with the selected path displayed on the map as a suggested route for the user to follow.

#pagebreak()
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
  ][
    #block(width: 45%)[
      #figure(
        image("ui/personal-path-history/history.png", width: 66.7%),
          caption: [History in home page as authenticated user]
      )  <ui-personal-path-history-hystory>
    ]
  ][
  ]
]
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 30%)[
      #figure(
        image("ui/personal-path-history/history-detail.png"),
          caption: [Personal path detail page]
      ) <ui-personal-path-history-history-detail>
    ]
  ][
    #block(width: 30%)[
      #figure(
        image("ui/personal-path-history/history-detail-fullscreen.png"),
          caption: [Personal path detail page in full-screen]
      ) <ui-personal-path-history-history-detail-fullscreen>
    ]
  ][
    #block(width: 30%)[
      #figure(
        image("ui/personal-path-history/history-detail-edited.png"),
          caption: [Personal path detail page after being edited]
      ) <ui-personal-path-history-history-detail-edited>
    ]
  ]
]

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Community Bike Path Browsing")

When the user is in the home page and tap on the search bar of the _Community Bike Paths_ modal a full-screen map is shown, as in @ui-community-paths-browsing-browsing-focused.

The user enters a start location, as in @ui-community-paths-browsing-browsing-startentered. The map shows the start marker. \
The user enters an end location, as in @ui-community-paths-browsing-browsing-endentered. The map shows the start and end markers, and the confirm button on the trailing section of the modal navigation bar is enabled.

*Community Path List Page* \
After the user tap the confirm button, the app loads their results in a list, ranked by a path quality score, as in @ui-community-paths-browsing-browsing-list. \
The list rows display the path route in the map, its quality score and, if the path is not optimal for bike (for example, it contains an highway), an alert is shown.
When the user select a path row, the full-screen map shows the path and the confirm button on the trailing section of the modal navigation bar is enabled.

*Community Path Detail Page* \
When the user tap the confirm button, a modal sheet is shown as in @ui-community-paths-browsing-browsing-detail-authenticated if the user is authenticated, or in @ui-community-paths-browsing-browsing-detail-authenticated if the user is unauthenticated. \
The map shows the path route, start marker, end marker and, if the path was added manually, all the locations provided by the user to compose it. \
The modal shows all the publicly available path information and if the user is authenticated the record new path button. \
When the user starts a new path from here, a bike path recording session begins, with the selected path displayed on the map as a suggested route for the user to follow.
If the path is not optimal for bike (for example, it contains an highway) an alert is shown.


#pagebreak()
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 29%)[
      #figure(
        image("ui/community-paths-browsing/browsing-focused.png"),
          caption: [Community browser page]
      ) <ui-community-paths-browsing-browsing-focused>
    ]
  ][
    #block(width: 29%)[
      #figure(
        image("ui/community-paths-browsing/browsing-startentered.png"),
          caption: [Community browser page after entering start location]
      ) <ui-community-paths-browsing-browsing-startentered>
    ]
  ][
    #block(width: 29%)[
      #figure(
        image("ui/community-paths-browsing/browsing-endentered.png"),
          caption: [Community browser page after entering end location]
      ) <ui-community-paths-browsing-browsing-endentered>
    ]
  ]
]
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 29%)[
      #figure(
        image("ui/community-paths-browsing/browsing-list.png"),
          caption: [Community path list page]
      ) <ui-community-paths-browsing-browsing-list>
    ]
  ][
    #block(width: 29%)[
      #figure(
        image("ui/community-paths-browsing/browsing-detail-authenticated.png"),
          caption: [Community path detail as authenticated user]
      ) <ui-community-paths-browsing-browsing-detail-authenticated>
    ]
  ][
    #block(width: 29%)[
      #figure(
        image("ui/community-paths-browsing/browsing-detail-unauthenticated.png"),
          caption: [Community path detail as unauthenticated user]
      ) <ui-community-paths-browsing-browsing-detail-unauthenticated>
    ]
  ]
]

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


