#import "@local/polimi:1.0.1": *
#import "@local/plantuml:0.1.0"
#import "@preview/pintorita:0.1.4"

#show raw.where(lang: "plantuml"): it => image(plantuml.path(it.text))
#show raw.where(lang: "pintora"): it => pintorita.render(it.text)


#show: polimi-thesis.with(
  title: "Best Bike Paths",
  subtitle: "Requirements Analysis and Specification Document",
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
Biking is an immensely beneficial activity, providing both physical and mental benefits. To encourage more people to take up this activity, it is crucial to provide them with the necessary tools to enhance their experience. 
Best Bike Paths aims to make biking a more rewarding experience by providing an intuitive software application that automatically records the paths that users take while exploring the world around them. 
This app is able to automatically record these paths by accessing the various sensors and GPS of the user’s device, but also allows its users to manually add these paths.
The application securely stores this information to allow its users to revisit their trips and track their progress as they increase their proficiency in this sport. 
These users will be able to publicly share these paths, allowing others to choose recommended bike paths based on their overall quality.
BBP’s ultimate goal is to offer its users a valuable tool that streamlines the process of cataloging their bike trips and cultivates a community of bikers by allowing them to share their experiences.

=== Goals
*G1*: Authenticated users want to automatically record bike path data while they are biking. \
*G2*: Authenticated users want to manually insert bike paths by specifying streets and status. \
*G3*: Authenticated users want to approve or reject obstacles detected by the system. \
*G4*: Authenticated users want to manually record an obstacle while they are biking. \
*G5*: Authenticated users want to retrieve all the collected data of their personal bike paths. \
*G6*: Authenticated users want to be able to share their recorded bike paths with the community. \
*G7*: Authenticated users want to enrich the data of their bike paths with relevant statistics (average speed, total distance, duration) and meteorological information, if available. \
*G8*: After specifying the start and destination, users want the ability to browse the paths (with the same starting point and destination) published by other authenticated users and ranked based on quality and data freshness. \
*G9*: The users want to ride along paths that are compatible with bikes.

== Scope
The purpose of this application is to provide relevant and accurate information about bike paths. In order to do this, BBP offers a wide array of functionalities, such as the ability to collect information about the followed paths, either by allowing users to manually insert the data or through an automated recording function that interacts with the GPS and sensors of the device on which the app resides. The collected information will be securely stored in a remote database, and can optionally be made publicly available. \
Users will be able to access and manage their stored information through the app.
This data can then be used by BBP to further develop its recommendation system, which will suggest bike paths based on the evaluations provided by other users or computed by the system. \
This application is primarily intended for authenticated users who will be able to record or manually insert new bike paths to track their cycling experiences. However, the BBP app will also allow unauthenticated users to partially access its functionalities, mainly the ability to browse publicly available bike paths. \
To enable automatic recordings of bike paths, the BBP application accesses the device’s GPS interface to determine the user’s exact location while biking, as well as other sensor interfaces to collect more relevant information associated with the travelled path. The app will also access an external API for the collection of meteorological data. \
This application is therefore intended to run on a mobile device equipped with GPS, motion sensors, and internet connectivity for the automatic collection and the remote storage of data in the system’s database.

=== World Phenomena
*WP1*: The user decides to take a bike trip. \
*WP2*: Weather conditions change over time. \
*WP3*: Accelerometer and gyroscope collects device motion data. \
*WP4*: GPS collects device location data. \
*WP5*: Street infrastructure changes over time (new streets are built, existing streets are upgraded, downgraded, or decommissioned). \
*WP6*: Path conditions change over time due to natural degradation, weather, or maintenance. \
*WP7*: The user starts and stops biking. \
*WP8*: The user velocity changes. \
*WP9*: The user encounters an obstacle. \
*WP10*: Stoplight changes color. \
*WP11*: The user's device’s internet connection changes over time.

=== Shared Phenomena

*World Controlled* \
*SP1*: The user creates an account. \
*SP2*: The user signs in and out of their account. \
*SP3*: The user deletes their account. \
*SP4*: The user starts, stops and pauses the recording of the bike path. \
*SP5*: The user selects or inserts street segments of a bike path. \
*SP6*: The user sets the status of the path. \
*SP7*: The user sets the privacy of the path. \
*SP8*: The user confirms or rejects obstacles detected by the system. \
*SP9*: The user manually adds an obstacle. \
*SP10*: The user deletes one of their bike paths. \
*SP11*: The user selects a starting point and a destination when browsing community bike paths. \
*SP12*: The users choose which path in the proposed routes should be followed. \
*SP13*: GPS provides the location samples. \
*SP14*: Accelerometer and gyroscope share motion data with the system. \
*SP15*: External services provide meteorological information.

*Machine Controlled* \
*SP16*: The system records GPS and sensor data during a user’s trip. \
*SP17*: The system displays the travelled path. \
*SP18*: The system displays the selected path to follow.  \
*SP19*: The system displays a notification to the user after detecting a possible obstacle. \
*SP20*: The system displays the current travel time and additional statistics about the trip while recording. \
*SP21*: The system pauses the recording when the user slows down.  \
*SP22*: The system collects weather data from the weather API when recording stops. \
*SP23*: The system displays  the user’s personal bike paths in their  history.  \
*SP24*: The system displays ranked community bike paths between a chosen origin and destination. \
*SP25*: The system shows detailed information for any selected path. \
*SP26*: The system alerts the user when a selected path contains incompatible streets for biking.


#figure(
  caption: [Mapping between goals and phenomena],
  table(
    columns: 3,
    table.header([], [*Shared Phenomena*], [*World Phenomena*]),
    [*G1*], [SP2, SP4, SP7, SP13, SP14, SP16, SP17, SP20, SP21],
            [WP1, WP3, WP4, WP7, WP8, WP11],
    [*G2*], [SP2, SP5, SP6, SP7, SP17],
            [WP5],
    [*G3*], [SP2, SP8, SP19],
            [WP9],
    [*G4*], [SP2, SP4, SP9],
            [WP7, WP9],
    [*G5*], [SP2, SP23, SP25],
            [],
    [*G6*], [SP2, SP7, SP24, SP25],
            [],
    [*G7*], [SP2, SP13, SP14, SP15, SP20, SP22, SP25],
            [WP2, WP3, WP4, WP8],
    [*G8*], [SP11, SP12, SP18, SP24, SP25],
            [WP5, WP6],
    [*G9*], [SP18, SP26],
            [WP5, WP6, WP10],
  )
)

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
Obstacles can be automatically detected through the device’s motion sensors or manually reported by the user, and are used by the system to assess and compute the overall quality of the path.

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
 
- Version 1.0: #datetime.today().display("[day]/[month]/[year]")

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
1. *Introduction*: a description of the project that highlights the objectives that it aims to satisfy as well as the core interactions between the application and the environment in which it operates.
2. *Overall Description*: a more detailed description of the functionalities provided by the application, including real-world scenarios and descriptions of the types of users that interact with the system.
3. *Specific Requirements*: includes an overview of the main interfaces provided or used by the system as well as an exhaustive list and analysis of the main requirements that guarantee satisfaction of the project’s main objectives, including diagrams that describe the interaction between the system and the environment.
4. *Formal analysis using Alloy*: a formal description of the domain and an analysis of some of the product’s requirements through Alloy in order to objectively determine the satisfaction of specific goals.
5. *Effort spent*: Includes the amount of time dedicated by each member for the realization of each section of the document.
6. *References*: reference to documents or tools used for writing this document.

= Overall Description

== Product Perspective

=== Scenarios

#heading(level: 4, numbering: none,  outlined: false,  "Account Management")

*Unauthenticated user signs up an account* \
The user, after downloading the Best Bike Paths app, opens it on their device. Since the user is anonymous the app displays a _Content Unavailable_ view explaining what the user is missing, since they’re not logged in, and a CTA to sign in. The user decides to create an account in order to take full advantage of the app’s capabilities. After tapping the sign-in button, the app presents a modal. The user is prompted to insert an email, which the app uses to discern if the user is new and should create a new account or, if already taken, to log in. The user inserts their email and the app verifies the email is not used by another account.  The app then displays a _verify-email_ page where the user has to insert a one-time code sent to their email. After correctly inserting the code, the app displays a page with a name, password and password-confirmation text fields.  After inserting the new requested data, the modal is dismissed and the user is redirected to the home view.

*Authenticated user deletes their account* \
An authenticated user opens the BBP application and accesses their personal profile settings.
The user selects the option to delete their account. The system informs the user that deleting the account will permanently remove all data associated with the user, including personal profile information, recorded trips, and any bike paths previously published by the user.
After the user confirms this action, the system deletes the account and all related data from the database and terminates the user session.

*Unauthenticated user signs into their account* \
A user, after some time, decides to use the Best Bike Paths app again and opens it. After tapping the sign-in button, the app presents a modal. The authenticated user is prompted to insert an email, which the app uses to discern if the user is new and should create a new account or, if already taken, to log in. After the user inserts an email belonging to an account, the app shows a password box. If the password is wrong, the app reports the error.  After inserting the correct password, the modal is dismissed and the user is redirected to the home view. 

*Authenticated user signs out of their account* \
An authenticated user presses the sign-out button. The app signs the user out of their account, redirecting them to the home page, where he can browse community bike paths. However, the user will now have to perform the log-in to access the full functionalities of the application.

#heading(level: 4, numbering: none,  outlined: false,  "Permission Management")

*System asks permission to use a device capabilities (GPS case example)* \
The authenticated user decides to record his first ride and taps the Start Recording button. A modal explaining why the app must access location data is displayed. The modal contains accept and cancel buttons. If the user selects the Cancel option, the modal is dismissed and the user remains on the home screen. If the  user selects the Continue option, the system presents the dialog requesting permission to access the location. If the user grants permission, the view to record the bike path is presented, otherwise the user remains in the home, and the next time this capability would be needed, he will be required to give permission through the device’s system settings app.
The same flow of events will be replicated wherever other capabilities are required by the application.

#heading(level: 4, numbering: none,  outlined: false,  "Automatic Bike Path Recording")

*Authenticated user presses start button before biking* \
While on the home page, the user presses the Start Recording button. The app displays the path recording page, consisting of a map, a timer, and a Start button. If the user presses the Start button the system begins the time-lapse, and displays a Stop button, a Pause button and relevant information regarding the trip, such as the covered distance, current speed, average speed and top speed.

*Authenticated user pauses recording* \
While a trip recording is in progress, the user temporarily stops biking and selects the option to pause the recording.
The system suspends the collection of GPS and sensor data and stops the trip timer. 
When the user decides to resume biking, the user selects the Resume option. The system continues the recording, continues collecting GPS and sensor data, and updates the trip statistics accordingly until the trip is stopped or paused again.

*System detects obstacles and asks for the Authenticated User’s confirmation* \
While biking, the user encounters an obstacle and rides over it. The device records vibrations and speed changes via the gyroscope and accelerometer, recognizing the obstacle. The system displays a timed alert to give users the opportunity to confirm the presence of the obstacle. 
The user may either confirm or reject the detected obstacle. If the user ignores the alert, after a certain amount of time the app will silently accept and add the obstacle to the path data.

*Authenticated user adds an obstacle while biking* \
While biking, the user encounters an obstacle and rides near it without the system detecting it. The user therefore decides to notify the presence of this obstacle and opens the BBP application, presses the “Add Obstacle” button, and closes the app.
The system records the obstacle and adds it to the current path information. 

*Authenticated user stops at a red light* \
While biking, the user encounters a red light and stops. The system registers the sudden change in the bike’s velocity and pauses the recording. The user quickly opens the application on their device and sees that the time-lapse has paused. After putting away their device, the stoplight turns green, and the user resumes biking. The system recognizes that the bike has started to move and therefore resumes the time-lapse.

*Authenticated user stops biking and stops recording* \
After having reached their destination, the user opens the BBP application, which is currently recording the path that they have taken up to this point. The user presses a button to stop the recording. The application prompts the user for confirmation to terminate the recording. After the user selects the “Confirm” option, the system ends the recording and shows a recap of the trip, allowing the user to review the collected and to set the privacy status of the path. After user confirmation, the system displays the user's personal history page.

#heading(level: 4, numbering: none,  outlined: false,  "Manual Bike Path Insertion")

*Manual Path Recording * \
After navigating to the page dedicated to the manual creation of bike paths, the authenticated user specifies a starting point and destination of the path. The system displays the map and allows the user to define the bike path by selecting the streets composing the route.
Before saving the bike path, the user selects a privacy and quality status to associate with the path. The system stores the path in the user’s personal history, making it available for later review and optional publication.

#heading(level: 4, numbering: none,  outlined: false,  "Personal History Management")

*Authenticated user visits their history page* \
After the authenticated user opens the BBP application on their device, they navigate to their history page, where they can view a list of all the paths that they’ve travelled (organized by chronological order). Each path shows a limited amount of information, such as the beginning and destination of the trip, the date when the trip was taken, and the total duration.
There is also an option to select a specific path to view additional information, such as a visual representation of the traveled path, average speed, meteorological information, and the obstacles encountered along the trail, as well as a button that makes the information about that path public.

*Authenticated user deletes a bike path* \
After opening the BBP app on their device and navigating to their history page, the user notices that a bike path was added by mistake. To remove it, the user selects the path to open its dedicated page, where they can find the button that allows them to delete the bike path. The system asks for confirmation before permanently removing it from the database. After confirming the action, the system deletes it and updates the user’s history page.

*Authenticated user toggles bike path privacy status* \
After navigating to their history page, the user selects a bike path that is currently private and presses the button that allows the system to make the information about it public. Following this action, the system updates both the path status within the database and the user’s history view. The user then presses the button again after changing his mind, causing another update of the UI. The system subsequently makes the information associated with the path private.

#heading(level: 4, numbering: none,  outlined: false,  "Community Bike Path Browsing")

*User searches for a path* \
The user navigates to the browsing page and enters a starting point and destination. The highest-quality bike paths connecting the two points are displayed to the user, along with their respective rank. The user can select a path to view its details. If the user is authenticated, they are presented with the option to start the automatic recording function. If the user selects this option, they will be redirected to a page displaying the map with the selected path, a timer, and other metrics.

#pagebreak()
=== Class Diagram

The diagram models the main entities of the Best Bike Path application.
A `User` represents the account of an authenticated user that can create and own multiple `BikePath` objects.

`BikePath` represents a single bike ride made by a user. It's an abstract class containing common route information, such as date, visibility, and route structure. \
It can be specialized into two class: 
- `AutomaticBikePath`, which is recorded by the device in automatic recording mode and may include `Performance` and `Weather` object that holds corresponding data, road quality status.
- `ManualBikePath`, whose locations and road quality status is directly assigned by the user.

The road path is represented by an ordered array of `Location`s, which are used by map services to reconstruct the path and reverse geocode street names and directions.

The quality of a bike path is expressed through the `BikePathStatus` enumeration, either computed automatically or set manually.

#let classDiagram =```plantuml
class User {
  paths: BikePath[*]
}

class EmailPasswordCredential {
  email: String {unique}
  passwordHash: String
}

abstract class BikePath {
  date: Date
  isPublic: Bool
  locations: Location[*]
  ' hasHighways(): Bool (removed since it comes from MapKit)
}

class AutomaticBikePath {
  obstaclesCount: Int
  distance: Double
  time: Double
  activeTime: Double
  performance: Performance {optional}
  weather: Weather {optional}
  computeStatus(): BikePathStatus
}

class ManualBikePath {
  status: BikePathStatus
}

class Performance {
  averageSpeed: Double
  peakSpeed: Double
}

class Weather {
  temperature: Double
  humidity: Double
  windSpeed: Double
}

class Location {
  latitude: Double
  longitude: Double
}

enum BikePathStatus {
  excellent
  good
  fair
  poor
  impassable
}

' Associations / multiplicities
User "1" *-- "1" EmailPasswordCredential
BikePath "*" <-- "1" User
BikePath "1" *-- "1..*" Location

BikePath <|-- AutomaticBikePath
BikePath <|-- ManualBikePath

AutomaticBikePath "1" *-- "0..1" Performance
AutomaticBikePath "1" *-- "0..1" Weather
```
#figure(
  classDiagram,
  kind: image,
  caption: [App Class Diagram]
)

#pagebreak()
=== State Diagrams

*Account Life-Cycle*

This state diagram describes the evolution of a user’s account. 

Initially, the user doesn’t possess a BBP account and is therefore `Unauthenticated` and `Unregistered`. Once the user follows the necessary steps for signing up, they will have a dedicated account to which they have to still sign in. 
After completing the sign in process, they will obtain the necessary access tokens for verifying their identity within the system and will thus be authenticated.


If the user decides to sign out, they will move back into the `Registered` state and will have to complete the sign in process again. If the user deletes their account, all the data associated with the user will be deleted from the database and their session will be terminated and will thus move to the initial state.

#let accountStateDiagram = ```plantuml
left to right direction
hide empty description
state Unauthenticated{
    state Registered 
    state Unregistered
}
[*] --> Unregistered
Unregistered --> Authenticated : Create account
Authenticated --> Registered : Sign out
Registered --> Authenticated : Sign in
Authenticated --> Unregistered : Delete account
```
#figure(
  accountStateDiagram,
  kind: image,
  caption: [Account Life-Cycle State Diagram]
)

#pagebreak()
*Capability Life-Cycle*

This state diagram describes the evolution of a device capability. 

Initially, a capability may be `Unavailable`, meaning the device doesn't support or can't access the capability. Alternatively, the capability may be `NotDetermined`, meaning the user has not chosen whether the app can use the capability.

When the capability is in the `NotDetermined` state, the system may request authorization from the user through a permission dialog. If the user grants permission, the capability transitions to the `Authorized` state and becomes usable by the application. Otherwise, if the user denies the permission request, the capability transitions to the Denied state and cannot be used. The capability may only transition to the `Authorized` state if the user manually enables it through the device’s system settings. 

Once in the `Denied` state the application can't request the permission anymore through the system dialog. `Authorized` capability may transition back to the `Denied` state if the user revokes the permission from the system settings.

#let capabilityStateDiagram = ```plantuml
left to right direction
hide empty description
state NotUsable{
    state Unavailable 
    state NotDetermined 
    state Denied
}
state Usable{
    state Authorized
}
[*] --> Unavailable
[*] --> NotDetermined
NotDetermined --> Denied : User accept permission in dialog
NotDetermined --> Authorized : User deny permission dialog
Denied --> Authorized : Toggle permission in settings
Authorized --> Denied
```
#figure(
  capabilityStateDiagram,
  kind: image,
  caption: [Capability Life-Cycle State Diagram]
)

#pagebreak()
*Path Life-Cycle*

The state diagram describes the different states in which a path can be in during its life-cycle. 

The life-cycle of a bike path can begin in two ways:
- `AutomaticRecording`: the device starts the recording of a new bike path when it senses that the user is currently biking.
- `ManualInsertion`: the user manually adds a new bike path by specifying relevant details such as the start, the street names along the route, the destination, and the status.

After the user confirms the completion of the bike path, the system saves it to the database.
Each bike path is associated with a `Privacy` attribute that determines the privacy status of the bike path (public or private). 
By default, when the bike path is first added, the `Privacy` attribute is set to “private”, but can be later modified according to the user’s preferences.

The bike path can optionally enter the `Deleted` state, where the bike path is permanently removed from the database, at the user’s discretion.

#let pathStateDiagram = ```plantuml
left to right direction
hide empty description
[*] --> AutomaticRecording
[*] --> ManualInserting
AutomaticRecording --> Completed : Stop\nRecording
ManualInserting --> Completed: Manual\nInsertion
Completed --> Deleted : Delete\nPath
state Completed {
       state Privacy {
        [*] --> Private
        Private --> Public : Publish
        Public --> Private : Unpublish
    }
}
Deleted --> [*]
```
#figure(
  pathStateDiagram,
  kind: image,
  caption: [Path Life-Cycle State Diagram]
)

#pagebreak()
*Automatic Recording*

The state diagram describes the recording process of a bike path as the user is biking and the device automatically records the followed route.

When the user stops biking, the device’s sensors detect a sudden drop in velocity. 
When the system reads this information, it concludes that the user is no longer biking and therefore temporarily pauses the recording. This prevents the collection of inaccurate trip statistics, such as the final calculation of the average speed or the total active biking time. 
The user is also allowed to manually pause and resume the recording independently of the actual motion-state of the device.
While paused, no obstacle will be detected.
The user can also optionally pause and resume the recording at their discretion.

When the user resumes biking, the system detects the movement and resumes the recording once the velocity reaches a threshold that indicates that the user is currently biking.

The termination of the recording, which is manually performed by the user, can only occur when the user has stopped. If any errors occur during this process, they must be effectively handled by the system.

#let automaticRecordingStateDiagram = ```plantuml
hide empty description
[*] --> Active: User is biking
Active --> Paused : Velocity drops\nbelow threshold
Active --> Paused : User pauses\nrecording
Paused --> Active : Velocity rises\nabove threshold
Paused --> Active : User resumes recording
Active --> Canceled : Sensor / GPS failure\nor inaccurate data
Paused --> Canceled : Sensor / GPS failure\nor inaccurate data
Paused --> [*] : User stops recording
note on link
Stop Recording use case
end note
note left of Active
- Collect GPS data
- Update trip metrics
end note
Canceled --> [*]
```
#figure(
  automaticRecordingStateDiagram,
  kind: image,
  caption: [Automatic Recording State Diagram]
)

#pagebreak()
== Product Functions

#heading(level: 4, numbering: none,  outlined: false,  "Account Management")

*User Account Sign-up* \
The system allows users to create a personal account by providing their credentials and accepting applicable terms and privacy notices. The system shall validate input data and prevent account duplication.

*User Account Sign-in* \
The system allows unauthenticated users to access their personal account by providing their credentials.

*User Account Sign-in* \
The system allows authenticated users to sign out of their personal account.
 
*User Account Deletion* \
The system allows authenticated users to delete their personal account.

#heading(level: 4, numbering: none,  outlined: false,  "Permission Management")

*Permissions Management* \
The system shall request and manage the permissions required to get the proper access level to the device services necessary for the correct functioning of the application.
Permission requests shall be issued only when the related functionality is required and shall clearly inform the user about the purpose of each requested permission.
The system shall request the following permissions:
- Location Services, including background location access, to enable ride tracking;
- Motion sensors (accelerometer and gyroscope), to support bike activity detection and obstacle identification;
- Notifications, including support for Live Activities where available, to inform the user about ride status and obstacle confirmation events.
The system shall handle cases in which permissions are denied or revoked by disabling dependent functionalities and notifying the user of the resulting limitations.


#heading(level: 4, numbering: none,  outlined: false,  "Automatic Bike Path Recording")

*Manual Control* \
The system shall allow the user to start a recording by pressing a dedicated button before biking. 
Once the ride recording starts or resumes, the system should start tracking the path and allow the user to pause the recording by pressing a dedicated button.
Once the ride recording pauses, the system should stop tracking the path and allow the user to resume or end the recording by pressing a dedicated button.
Once the ride recording ends, the system should stop tracking the user path and allow the user to review the collected information and set the path’s privacy status.

*Automatic Activity Detection* \
The system should be capable of recognizing if the user is biking by using sensor data. The platform provides frameworks capable of providing the current user motion activity (`CNMotionActivityManager` on iOS, and `ActivityRecognitionClient` on Android). 
Based on the detected change in the user's current activity (whether they are biking or not), the system will perform specific actions: when in recording mode, the system should resume or pause the recording; when not in recording mode, the system should suggest the user to start a new recording session.

*Manual Obstacle Reporting* \
The system shall allow the user to report the presence of an obstacle by pressing a dedicated button.

*Automatic Obstacle Detection* \
The system should be able to detect an obstacle by using data collected from the device's sensors and prompt the user for confirmation.

*Stop Recording* \
The automatic path recording is manually terminated at the user’s discretion. When the user selects “Stop Recording”, the system prompts the user for confirmation. After the user confirms, the system stops collecting data from the GPS and the sensors and allows the user to review the collected information, such as obstacles, street names, performance statistics, and set the privacy status of the path. The system then saves the path information in the database and redirects the user to their personal history page.

#heading(level: 4, numbering: none,  outlined: false,  "Manual Bike Path Insertion")

*Manual Insertion* \
The system allows users to manually insert a path by selecting a starting point, destination, and intermediary stops connecting the two points. Once the user selects a quality and privacy status for the path, the system will store it in the database.

#heading(level: 4, numbering: none,  outlined: false,  "Personal History Management")

*Publish/Unpublish Paths* \
The system allows users to publish their paths. When the user presses the “Publish” button, the system updates the privacy status of the selected path in the database, marking it as “Public”. Once the path is made public, it becomes visible and accessible to other users. 
The system also allows the user to revert previously published paths back to “Private”. The process is analogous to the previous one, triggering an update in the database to reflect the new privacy status.

*View Detailed Path Information* \
The system allows users to access a detailed view of their travelled paths. After choosing this option, the system will display relevant information related to the path, such as a map of the route, the total duration, the active biking time, the date of the recording, the average speed, the top speed, the encountered obstacles, the status, and, when available, relevant meteorological information.

*Personal Path Deletion* \
The system allows users to delete their previously recorded paths from their personal history. When a path is deleted, the system removes all the data associated with it from the database, ensuring that it is no longer accessible to any user.

#heading(level: 4, numbering: none,  outlined: false,  "Community Bike Path Browsing")

*Bike Path search and Ranking* \
the system allows users, both authenticated and unauthenticated, to search for bike paths by specifying an origin and a destination.
When multiple paths are available, the system computes a score for each path and presents the results ranked according to their quality and reliability, both as a list and on a map. After selecting a path, authenticated users are redirected to a page displaying the route on a map, along with a timer and performance-related statistics, and will be given the option to start an automatic recording session. If the user refuses, information about the trip won't be stored in the user's personal history.



== User Characteristics

=== Unauthenticated User

Users who haven’t created an account or haven't logged in yet, and who don’t have a valid, non-expired authentication token, will still be able to access the application but will be restricted from using certain functionalities that require user authentication. 
More specifically, an unauthenticated user can look up community bike paths (by inserting a starting point and a destination), which will be displayed on a map, and their system-computed path ranking.

=== Authenticated User
An authenticated user possesses a valid access token for authentication. Authenticated users have full access to the functionalities provided by the BBP application, including those offered to unauthenticated users. 
Authenticated users can automatically record travelled bike paths, but the system also collects relevant trip data and will occasionally prompt the user for confirmation of encountered obstacles. Completed trips will be stored by the system and can be viewed by the user in the corresponding section of their personal history page. These users will also be able to optionally publish them, allowing the system to use this information to assess the quality of the bike path and enabling recommendations to other users. 
These users are also able to browse bike paths and optionally select one to follow before optionally activating the automatic recording functionality.
Authenticated users are also capable of manually inserting new bike paths by specifying the streets, privacy, and status associated with the path.

== Assumptions, Dependencies And Constraints

=== Regulatory policies

BBP collects and processes user location data, motion sensor data, and information about road conditions such as obstacles and path status. This information must be handled in full compliance with the General Data Protection Regulation (GDPR), ensuring that personal and location data are stored securely and used only for the purposes of trip recording, path recommendation, and community-based path evaluations.
Users should grant permission for the application to access location services, motion sensors, and notifications on their devices.
Furthermore, any publishable information contributed by users becomes visible to the community and must be treated as user-generated content, respecting applicable regulations on data sharing and responsibility.
BBP relies on external mapping and meteorological services, whose terms of use and licensing policies must also be respected.

=== Domain assumptions

*D1*: Users have internet access when interacting with online services provided by BBP. \
*D2*: The road network in the real world is correctly represented in the external map provider used by BBP. \
*D3*: The GPS provides an accuracy measurement along with the location data. \
*D4*: Sensors on the users’ devices, when available, operate correctly. \
*D5*: Meteorological services provide accurate weather information for specific locations and time intervals \
*D6*: Users’ devices have sufficient resources (battery, storage and processing capability) for BBP to work properly. \
*D7*: Users’ device timestamps are sufficiently accurate to correlate collected trip data with meteorological information. \
*D8*: No major changes in traffic conditions or speed limits occur during the time required to finish a trip.\

= Specific Requirements

== External Interface Requirements

=== User Interfaces

Best Bike Paths will be an app for mobile devices (iOS and Android). 
The User Interface will be optimized for touch screens and will follow their platform device guidelines (Human Interface Guidelines for iOS and Material Design for Android). Compliance with these standards ensures a consistent user experience and facilitates the implementation of accessibility best practices.
User interaction occurs through touch input, gestures, and native UI components.
Since the app relies on motion and location device features, the interface will include UI elements to request permission to interact with these device capabilities, following the platform-specific guidelines.

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Account Management")
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 45%)[
      #figure(
        image("ui/account-management/home-unauthenticated.png", width: 66.7%),
          caption: [Home page as unauthenticated user]
      )
    ]
  ][
  ][
    #block(width: 45%)[
      #figure(
        image("ui/account-management/home-authenticated.png", width: 66.7%),
          caption: [Home page as authenticated user]
      )
    ]
  ]
]
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 45%)[
      #figure(
        image("ui/account-management/account-unhauthenticated.png", width: 66.7%),
          caption: [Account page as unauthenticated user]
      )
    ]
  ][
  ][
    #block(width: 45%)[
      #figure(
        image("ui/account-management/account-unhauthenticated-filled.png", width: 66.7%),
          caption: [Account page as authenticated user after entering data]
      )
    ]
  ]
]
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 45%)[
      #figure(
        image("ui/account-management/account-emailverification.png", width: 66.7%),
          caption: [Account email verification page]
      )
    ]
  ][
  ][
    #block(width: 45%)[
      #figure(
        image("ui/account-management/account-emailverification-filled.png", width: 66.7%),
          caption: [Account email verification page after entering data]
      )
    ]
  ]
]
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 45%)[
      #figure(
        image("ui/account-management/account-signup.png", width: 66.7%),
          caption: [Account sign-up page]
      )
    ]
  ][
  ][
    #block(width: 45%)[
      #figure(
        image("ui/account-management/account-signup-filled.png", width: 66.7%),
          caption: [Account sign-up page after entering data]
      )
    ]
  ]
]
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 30%)[
      #figure(
        image("ui/account-management/account-signin.png"),
          caption: [Account sign-up page]
      )
    ]
  ][
    #block(width: 30%)[
      #figure(
        image("ui/account-management/account-signin-filled.png"),
          caption: [Account sign-up page after entering data]
      )
    ]
  ][
    #block(width: 30%)[
      #figure(
        image("ui/account-management/account-signin-wrongpassword.png"),
          caption: [Account sign-in page after entering wrong password]
      )
    ]
  ]
]
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 30%)[
      #figure(
        image("ui/account-management/account-authorized.png"),
          caption: [Account page as authorized user]
      )
    ]
  ][
    #block(width: 30%)[
      #figure(
        image("ui/account-management/account-authorized-signoutconfirmation.png"),
          caption: [Account page as authorized user sign-out confirmation dialog]
      )
    ]
  ][
    #block(width: 30%)[
      #figure(
        image("ui/account-management/account-authorized-deleteaccountconfirmation.png"),
          caption: [Account page as authorized user delete account confirmation dialog]
      )
    ]
  ]
]

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Permission Management")
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 45%)[
      #figure(
        image("ui/capability-management/requestcapability-notdetermined.png", width: 66.7%),
          caption: [Request capability page when capability access is not determined]
      )
    ]
  ][
  ][
    #block(width: 45%)[
      #figure(
        image("ui/capability-management/requestcapability-notdetermined-systemdialog.png", width: 66.7%),
          caption: [System capability authorization dialog]
      )
    ]
  ]
]
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 45%)[
      #figure(
        image("ui/capability-management/requestcapability-denied.png", width: 66.7%),
          caption: [Request capability page when capability access is denied]
      )
    ]
  ][
  ][
    #block(width: 45%)[
      #figure(
        image("ui/capability-management/requestcapability-unavailable.png", width: 66.7%),
          caption: [Request capability page when capability access is unavailable]
      )
    ]
  ]
]

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Automatic Bike Path Recording")
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 30%)[
      #figure(
        image("ui/automatic-path-recording/pathrecording-idle.png"),
          caption: [Recording page before starting]
      )
    ]
  ][
    #block(width: 30%)[
      #figure(
        image("ui/automatic-path-recording/pathrecording-active.png"),
          caption: [Recording page while active]
      )
    ]
  ][
    #block(width: 30%)[
      #figure(
        image("ui/automatic-path-recording/pathrecording-obstaclealert.png"),
          caption: [Recording page notification after an obstacle is detected or inserted by the user]
      )
    ]
  ]
]
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 45%)[
      #figure(
        image("ui/automatic-path-recording/pathrecording-paused.png", width: 66.7%),
          caption: [Recording page when paused]
      )
    ]
  ][
  ][
    #block(width: 45%)[
      #figure(
        image("ui/automatic-path-recording/pathrecording-stopped.png", width: 66.7%),
          caption: [Recording page when stopped]
      )
    ]
  ]
]

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Manual Bike Path Insertion")
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 45%)[
      #figure(
        image("ui/manual-path-insertion/pathinsertion.png", width: 66.7%),
          caption: [Insertion page]
      )
    ]
  ][
  ][
    #block(width: 45%)[
      #figure(
        image("ui/manual-path-insertion/pathinsertion-filled.png", width: 66.7%),
          caption: [Insertion page after entering data]
      )
    ]
  ]
]

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Personal History Management")
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
  ][
    #block(width: 45%)[
      #figure(
        image("ui/personal-path-history/history.png", width: 66.7%),
          caption: [History in home page as authenticated user]
      )
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
      )
    ]
  ][
    #block(width: 30%)[
      #figure(
        image("ui/personal-path-history/history-detail-fullscreen.png"),
          caption: [Personal path detail page in full-screen]
      )
    ]
  ][
    #block(width: 30%)[
      #figure(
        image("ui/personal-path-history/history-detail-edited.png"),
          caption: [Personal path detail page after being edited]
      )
    ]
  ]
]

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Community Bike Path Browsing")
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 29%)[
      #figure(
        image("ui/community-paths-browsing/browsing-focused.png"),
          caption: [Community browser page]
      )
    ]
  ][
    #block(width: 29%)[
      #figure(
        image("ui/community-paths-browsing/browsing-startentered.png"),
          caption: [Community browser page after entering start location]
      )
    ]
  ][
    #block(width: 29%)[
      #figure(
        image("ui/community-paths-browsing/browsing-endentered.png"),
          caption: [Community browser page after entering end location]
      )
    ]
  ]
]
#align(center)[
  #stack(dir: ltr, spacing: 5%)[
    #block(width: 29%)[
      #figure(
        image("ui/community-paths-browsing/browsing-list.png"),
          caption: [Community path list page]
      )
    ]
  ][
    #block(width: 29%)[
      #figure(
        image("ui/community-paths-browsing/browsing-detail-authenticated.png"),
          caption: [Community path detail as authenticated user]
      )
    ]
  ][
    #block(width: 29%)[
      #figure(
        image("ui/community-paths-browsing/browsing-detail-unauthenticated.png"),
          caption: [Community path detail as unauthenticated user]
      )
    ]
  ]
]

#pagebreak()
=== Hardware Interfaces

To ensure the user makes the most of the app's capabilities, the user’s device should be equipped with the following hardware components (the app should handle their unavailability properly):
- Gyroscope, to detect the device orientation
- Accelerometer, to detect device movements
- GPS module, to detect the device location

The device will also need a stable and reliable connection to the internet to make the app work properly. When no network interface is available, the application continues to operate in offline mode, storing data locally, and when connectivity is restored synchronizes with backend services.

=== Software Interfaces

*OS Motion Services* \ 
_CoreMotion on iOS, SensorManager on Android_ \
The app uses native motion frameworks to access data from the available onboard hardware (Accelerometer and Gyroscope) and to detect user activity changes.

*OS Location Services* \ 
_CoreLocation on iOS, Fused Location Provider on Android_ \
The app uses native location frameworks to determine the device’s geographic location.

*Mapping and Routing Services* \
_Apple Maps MapKit on iOS, Google Maps SDK on Android_ \
The app uses mapping and routing frameworks in order to display maps, calculate paths, geocoding (and reverse geocoding) locations.

*Weather Services* \
_WeatherKit on iOS, OpenWeatherMap API on Android_ \
The app can use weather frameworks or api to enrich trips with weather data.

*Network State Monitoring Services* \
_Network on iOS, NetworkMonitor on Android_
The app uses these services to monitor the network in order to make the UI respond to connectivity changes.

*Best Bike Paths Backend* \
The app will communicate with the Best Bike Paths backend through a REST API in order to sync user accounts and store and retrieve user data and community paths. The backend communicates with other external or internal components (e.g., SMTP Server, DBMS, etc.).

=== Communication Interfaces

*Network Connectivity Requirements* \
The system requires one or more of the following active network interfaces:
- Wi-Fi (IEEE 802.11)
- Cellular Data Network (3G / 4G / 5G)
When no network interface is available, the application continues to operate in offline mode, storing data locally, and when the connectivity is restored synchronizes with backend services.


*Communication Protocols* \
- HTTPS Protocol, to communicate with the backend

*Data Exchange Formats* \
- JSON, to use with the backend REST API.

*Authentication and Security* \
All communication with back-end services must be authenticated and authorized, by using:
- TLS (Transport Layer Security) encryption
- Bearer token-based authentication
- Throttling and Rate Limiting

#pagebreak()
== Functional Requirements

#heading(level: 4, numbering: none,  outlined: false,  "Account Management")

*R1*: The system shall allow an unauthenticated user to create an account. \
*R2:* The system shall allow an unauthenticated user to sign into the app. \
*R3*: The system shall allow an authenticated user to sign out from the app. \
*R4*: The system shall allow an authenticated user to delete their account.

#heading(level: 4, numbering: none,  outlined: false,  "Permission Management")

*R5*: The system shall request the user’s permission to use a device capability. \
*R6*: The system shall properly handle user permission denial.

#heading(level: 4, numbering: none,  outlined: false,  "Automatic Bike Path Recording")

*Start Recording* \
*R7*: The system shall allow the authenticated user to start the automatic recording mode of a bike path. \
*R8*: The system shall use the GPS to track the user’s real-time position during the trip. \
*R9*: The system shall use the device’s sensors to collect information about obstacles along the path and the speed of the user. \
*R10*: The system shall display the current trip data (current duration time, map of the path, average speed, top speed, weather conditions, distance covered) while the user is biking. \
*R11*: The system shall prompt the user for confirmation of a detected obstacle while biking. \
*R12*: The system shall allow the authenticated user to insert an obstacle manually.

*Stop Recording* \
*R13*: The system shall allow the authenticated user to manually stop the automatic recording of a bike path. \ 
*R14*: The system shall stop collecting GPS data once the authenticated user selects “Stop Recording”. \
*R15*: The system shall stop collecting sensor data once the authenticated user selects “Stop Recording”. \
*R16*: The system shall compute the status for the recorded path based on the frequency of obstacles. \
*R17*: The system shall store the path and its associated status in the authenticated user’s personal history. \
*R18*: The system shall cancel the recording if the accuracy of the GPS data drops under a certain threshold (over 10 meters for more than 15 seconds). \

*Pause and Resume* \
*R19*: The system shall automatically pause recording when the authenticated user stops biking. \
*R20*: The system shall automatically resume recording when the authenticated user starts biking. \
*R21*: The system shall allow the user to manually pause the recording. \
*R22*: The system shall allow the user to manually resume the recording.


#heading(level: 4, numbering: none,  outlined: false,  "Manual Bike Path Insertion")

*R23:*The system shall allow the authenticated user to manually create a path by inserting a starting point, destination, intermediary stops and defining privacy and a quality status.

#heading(level: 4, numbering: none,  outlined: false,  "Personal History Management")

*User Bike Path List* \
*R24*: The system shall display a list of the user’s previously recorded paths in chronological order when accessing their history page.

*User Bike Path Detail* \
*R25*: The system shall display all the collected data of a personal path when the user visits its dedicated page. \
*R26*: The system shall allow the user to set the privacy status of the path. \
*R27*: The system shall allow the user to delete their personal bike paths.

#heading(level: 4, numbering: none,  outlined: false,  "Community Bike Path Browsing")

*R28*: The system shall allow the user to browse publicly available bike paths by specifying a starting point and a destination. \
*R29*: The system shall show the user the matching paths, sorting them by their system-computed average quality score (calculated based on the public user path instances). \
*R30*: The system shall display for each path the route map along with the system-computed quality score. \
*R31*: The system should display an alert badge if a path contains incompatible roads for biking. \
*R32*: The system shall allow the user to select a path as the suggested route for a new automatic recording session.


#pagebreak()
=== Use Case Diagram

#let useCaseDiagram = ```plantuml
"User" as user
"Registered User" as ruser
"Weather Service" as weather
"GPS and Sensors" as sensors
"Map Service" as map
"SMTP Server" as email
user <|- ruser

rectangle "Best Bike Paths"{

    package "Account Management"{
    usecase "Account Creation"
    usecase "User Sign-In"
    usecase "User Sign-Out"
    usecase "Account Deletion"
    }

    package "Permission Management"{
    usecase "Request Device Capability"
    }

    package "Automatic Bike Path Recording"{

    usecase "Manual Controls"
    usecase "Activity Detection"
    usecase "Automatic Obstacle Detection"
    usecase "Manual Obstacle Insertion"
    usecase "Stop Recording"

    usecase "Automatic Recording"

    }

    package "Manual Bike Path Insertion"{
    usecase "Manual Path Insertion"
    }

    package "Personal History Management"{
    usecase "Set Bike Path Privacy"
    usecase "Delete Bike Path"
    usecase "Show Detailed View"

    }

    package "Community Bike Path Browsing"{
    usecase "Browse Community Paths"
    }

}

left to right direction
user -> (User Sign-In) : <initiate>
user --> (Account Creation): <initiate>

user --> (Browse Community Paths): <initiate>
left to right direction
ruser --> (Automatic Recording): <initiate>


(Automatic Recording) <-- weather: <participate>


left to right direction
(Automatic Recording) ..> (Manual Controls): <include>
(Automatic Recording) ..> (Activity Detection): <include>
(Automatic Recording) ..> (Stop Recording): <include>

(Automatic Obstacle Detection) ..> (Automatic Recording): <extend>
(Manual Obstacle Insertion) ..> (Automatic Recording): <extend>

(Browse Community Paths) ..> (Automatic Recording): <extend>


ruser --> (Account Deletion): <initiate>
ruser --> (Manual Path Insertion): <initiate>
ruser --> (Show Detailed View): <initiate>
ruser --> (Set Bike Path Privacy): <initate>
ruser --> (User Sign-Out): <initiate>
ruser --> (Request Device Capability): <participate>
ruser --> (Delete Bike Path): <initiate>



map --> (Show Detailed View)
map --> (Browse Community Paths)

left to right direction
(Account Creation) <-- email: <participate>

(Automatic Recording) <-- sensors: <participate>
```
#figure(
  useCaseDiagram,
  kind: image,
  caption: [Use Case Diagram]
)
#pagebreak()
=== Use Cases

#heading(level: 4, numbering: none,  outlined: false,  "Account Management")
*UC1 Account Creation*
#table(
  columns: 2,
  [*Name*], [Account Creation],
  [*Actors*], [Unauthenticated User, SMTP Server],
  [*Entry Conditions*], [
    - User opens BBP application on their device and navigates to the account page.
  ],
  [*Event Flow*], [
  	+	User opens the account page.
  	+	The application displays an email field.
  	+	The unauthenticated user enters their email.
  	+	The application asks the Backend to verify the email.
  	+	The Backend checks whether an account with that email exists.
  	+	The application displays the email verification code field.
  	+	The application requests the Backend to send a verification code.
  	+	The Backend generates a one-time code and stores (code → email) in the KV store (TTL: 1 hour).
  	+	The Backend sends the code to the user via SMTP and confirms success.
  	+	The application shows a “Code Sent” banner.
  	+	The user enters the verification code.
  	+	The application asks the Backend to validate the code.
  	+	The Backend verifies the code–email association.
  	+	The application displays the sign-up form.
  	+	The user enters name and password and accepts the privacy terms.
  	+	The application sends the sign-up request.
  	+	The Backend revalidates the code, creates the account, and returns 201 Created with an authentication token.
  	+	The application displays the authenticated homepage.
  ],
  [*Exit Conditions*], [
    - User account is created and the user is authenticated (token issued).
  ],
  [*Exceptions*], [
    - Email already registered (User redirected to sign-in flow)
    - SMTP delivery fails
    - KV store save or read error.
    - Verification code is invalid, expired (TTL exceeded), or does not match the provided email.
    - Database error prevents account creation.
    - No internet connection prevents Backend communication.
  ],
)

#pagebreak()
*UC2 User Sign-In*
#table(
  columns: 2,
  [*Name*], [User Sign-In],
  [*Actors*], [Unauthenticated User],
  [*Entry Conditions*], [
    - Unauthenticated User (with an existing account) opens BBP application on their device and navigates to the account page.
  ],
  [*Event Flow*], [
    + User opens the account page.
    + The application displays the email text field.
    + User inserts their email.
    + The application requests the backend to check whether the user exists
    + The backend queries the database to verify the existence of the account.
    + The backend confirms that the user exists.
    + The application displays the password text field.
    + User inserts their password
    + The application sends the sign-in request to the backend
    + The backend retrieves the account data from the database
    + The backend checks the provided credentials against the stored ones:
      - If credentials are not valid:
        + The backend returns 401 Unauthorized.
        + The application displays an authentication error message to the user.
      - If credentials are valid:
        + The backend returns 200 OK, along with the authentication token.
        + The application shows the homepage as a logged-in user.
  ],
  [*Exit Conditions*], [
    - User is authenticated (token issued)
  ],
  [*Exceptions*], [
    - Internal error prevents retrieving account data from the database.
    - Backend error prevents credential validation or token generation.
    - No internet connection prevents backend communication.
  ],
)

#pagebreak()
*UC3 Account Deletion*
#table(
  columns: 2,
  [*Name*], [Account Deletion],
  [*Actors*], [Authenticated User],
  [*Entry Conditions*], [
    - User is authenticated in the BBP application.
    - User is on the account page.
  ],
  [*Event Flow*], [
    + User presses the “Delete Account” button.
    + The application shows a confirmation dialog.
    + User confirms by pressing the Confirm button.
    + The application sends an authenticated request to the Backend to delete the user account.
    + The Backend requests the database to delete the account
    + The database confirms the deletion
    + The Backend returns 200 OK to the Frontend.
    + The application updates the UI and shows the homepage as an unauthenticated user.
  ],
  [*Exit Conditions*], [- User account is deleted and the user is signed out ],
  [*Exceptions*], [
    - Authentication fails (missing/invalid/expired token) -> Backend returns 401 Unauthorized.
    - Internal error prevents the database from deleting the account.
    - No internet connection prevents Backend communication.
    - The account cannot be deleted (e.g., account not found / already deleted) -> Backend returns an error.
  ],
)

#pagebreak()
*UC4 User Sign-Out*
#table(
  columns: 2,
  [*Name*], [User Sign-Out],
  [*Actors*], [Authenticated User],
  [*Entry Conditions*], [
    - User is authenticated in the BBP application.
    - User is on the account page.
  ],
  [*Event Flow*], [
    + User presses the “Sign out” button.
    + The application shows a confirmation dialog.
    + User confirms by pressing the Confirm button.
    + The application clears the local authentication state (e.g., token/session)
    + The application updates the UI and shows the homepage as an anonymous user.
  ],
  [*Exit Conditions*], [
    - User is signed out of the application.
  ],
  [*Exceptions*], [
    - Internal error prevents clearing the local authentication state
  ],
)

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Permission Management")

*UC5 Request Device Capability Permission*
#table(
  columns: 2,
  [*Name*], [Request Device Capability Permission],
  [*Actors*], [User, Capability Provider],
  [*Entry Conditions*], [
    - The user is using the BBP application and a feature requires access to a device capability (e.g., location, motion sensors, notifications)
  ],
  [*Event Flow*], [
    + The application determines that a device capability is required.
    + The application requests the current authorization status from the Capability Provider.
      - If capability access is unavailable:
        + The Capability Provider returns unavailable.
        + The application informs the user and continues without the capability.
      - If capability access was denied:
        + The Capability Provider returns denied.
        + The application displays a modal explaining why the capability is needed and provides instructions to enable permission in system settings.
        + The following loop repeats until the user either continues without the capability or enables permission in settings:
          - Continue without capability
            + User presses “Cancel”.
            + The application continues without the capability.
          - User authorize capability access.
            + User authorize capability access in system settings.
            + User reopen application.
            + The application continues with the capability.
      - If capability access is authorized:
          + The Capability Provider returns authorized.
          + The application continues with the capability.
      - If capability access is not determined:
          + The Capability Provider returns notDetermined.
          + The application shows a modal explaining why the capability is needed.
          + User chooses one of the following:
            - Deny permission
              + User presses “Cancel”.
              + The application continues without the capability.
            - Request permission
              + User presses “Continue”.
              + The application shows the system permission dialog.
              + If the user denies in the system dialog, the application continues without the capability.
              + If the user grants in the system dialog, the application continues with the capability.
  ],
  [*Exit Conditions*], [
    - The application proceeds either with the required capability (authorized) or without it (denied/unavailable), depending on the user decision and platform status.
  ],
  [*Exceptions*], [
    - Internal error prevents reading authorization status from the Capability Provider.
    - The system permission dialog cannot be displayed 
  ],
)

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Automatic Bike Path Recording")

*UC6 Automatic Recording With Manual Controls*
#table(
  columns: 2,
  [*Name*], [Automatic Recording With Manual Controls],
  [*Actors*], [Authenticated User],
  [*Entry Conditions*], [
    - The authenticated user opens the BBP application on their device and is on the recording screen (recording feature available).
  ],
  [*Event Flow*], [
    + User presses the “Start” button.
    + The application starts the activity recording and shows the recording UI.
    + While the recording is active, the following events may occur repeatedly until the user stops the recording:
      - Resume recording (if currently paused)
        + User presses the “Resume” button.
        + The application resumes the timer.
        + The application updates the UI to reflect the resumed state.
      - Pause recording (if currently recording)
        + User presses the “Pause” button.
        + The application pauses the timer.
        + The application updates the UI to reflect the paused state
    + User presses the “Stop Recording” button (if currently paused).
    + The application stops the activity recording and ends the recording session (Stop Recording Use Case).
  ],
  [*Exit Conditions*], [
    - Recording session is stopped.
  ],
  [*Exceptions*], [
    - The recording cannot be started (e.g., required permissions missing or device sensors unavailable)
    - Internal errors.
    - Missing connection.
  ],
)

#pagebreak()
*UC7 Automatic Recording With Activity Detection*
#table(
  columns: 2,
  [*Name*], [Automatic Recording With Activity Detection],
  [*Actors*], [Authenticated User, Sensor API (Device Activity Recognition)],
  [*Entry Conditions*], [
    - User opens BBP application on their device.
    - User is on the recording screen and activity recognition capability is available.
  ],
  [*Event Flow*], [
    + User presses the “Start” button.
    + The application subscribes to device activity recognition updates by calling the Sensor API.
    + While the recording session is active, the following loop repeats until the user stops the recording:
      - If the Sensor API detects cycling activity:
        + The Sensor API notifies the application that the user is cycling.
        + The application starts or resumes the timer.
        + The application updates the UI to reflect the “recording” state.
      - If the Sensor API detects non-cycling activity (e.g., stationary, walking, etc.):
        + The Sensor API notifies the application with a non-cycling state.
        + The application pauses the timer.
        + The application updates the UI to reflect the “paused” state.
    + User presses the “Stop” button.
    + The application stops receiving activity updates by calling the Sensor API.
    + The application ends the recording session(Stop Recording Use Case).
  ],
  [*Exit Conditions*], [
    - Recording session is stopped.
    - Subscription to Device Activity Detection is terminated.
  ],
  [*Exceptions*], [
    - Activity recognition is unavailable or permission is missing (the application continues without automatic pause/resume).
    - Sensor API fails to start or stop activity updates (internal/device error).
  ],
)

#pagebreak()
*UC8 Manual Obstacle Insertion*
#table(
  columns: 2,
  [*Name*], [Manual Obstacle Insertion],
  [*Actors*], [Authenticated User],
  [*Entry Conditions*], [
    - User is authenticated and has started a bike activity recording.
    - User is on the recording screen.
  ],
  [*Event Flow*], [
    + User presses the “Start” button to begin recording.
    + While the recording session is active, the following steps may occur repeatedly until the recording stops:
      - User presses the “Add Obstacle” button.
        + The application increments the obstacle counter associated with the current recording.
        + The application shows an obstacle confirmation dialog.
        + The user chooses one of the following actions:
          - Confirm or ignore the dialog:
            + User presses “Confirm” or does not interact with the dialog.
            + The obstacle remains recorded.
          - Cancel:
            + User presses “Cancel”.
            + The application decrements the obstacle counter, discarding the obstacle.
  ],
  [*Exit Conditions*], [
    - Obstacle count reflects the user confirmations.
  ],
  [*Exceptions*], [
    - Internal error prevents updating the obstacle counter.
    - Recording session is interrupted unexpectedly (e.g., application is terminated or crashes).
  ],
)

#pagebreak()
*UC9 Automatic Obstacle Detection*
#table(
  columns: 2,
  [*Name*], [Automatic Obstacle Detection],
  [*Actors*], [Authenticated User],
  [*Entry Conditions*], [
    - User opens BBP application on their device.
    - User is on the recording screen and starts a recording session.
    - Motion sensor capability is available and authorized.
  ],
  [*Event Flow*], [
    + User presses the “Start” button.
    + The application starts motion sensor monitoring by subscribing to:
      - Accelerometer updates 
      - Gyroscope updates 
    + While the recording session is active, the following loop repeats until the recording stops:
      - The Sensor API provides accelerometer data to the application.
      - The Sensor API provides gyroscope data to the application.
      - The application processes sensor data to perform obstacle detection.
      - If an obstacle is detected:
        - The application increments the obstacle count for the current recording.
        - The application shows an obstacle confirmation dialog to the user.
        - The user chooses one of the following actions:
          - Confirm or ignore the dialog:
            - The obstacle remains recorded.
          - Cancel:
            - The application decrements the obstacle count and discards the detected obstacle.
  ],
  [*Exit Conditions*], [
    - Motion sensor updates are terminated.
    - Obstacle count reflects confirmed (or non-cancelled) detected obstacles.
  ],
  [*Exceptions*], [
    - Accelerometer/gyroscope access is unavailable or permission is missing (the application continues without automatic obstacle detection).
    - Sensor API fails to start/stop updates (device/platform error).
    - Sensor data is noisy or delayed, producing false- positives/negatives in obstacle detection.
    - Internal error prevents updating obstacle count or displaying the confirmation dialog.
  ],
)

#pagebreak()
*UC10 Stop Recording*
#table(
  columns: 2,
  [*Name*], [Stop Recording],
  [*Actors*], [Authenticated User, Weather API],
  [*Entry Conditions*], [
    - User stops biking and opens the BBP application.
  ],
  [*Event Flow*], [
    + The application displays the current data about the trip.
    + User selects the option to end the automatic recording of the path.
    + The application prompts the user for confirmation.
    + User confirms termination of the recording.
    + The application stops collecting GPS data.
    + The application stops collecting data from gyroscope and accelerometer.
    + Optional: The application collects meteorological data from an external weather API service.
    + The application computes performance and path statistics based on the collected data.
    + The application saves the path data in the database.
    + The application redirects the user to the home page.
  ],
  [*Exit Conditions*], [
    - The application correctly saves the path data in the database.
  ],
  [*Exceptions*], [
    - Internal Error prevents the system from saving the path in the database
    - Missing Internet connection
  ],
)
#pagebreak()

#heading(level: 4, numbering: none,  outlined: false,  "Manual Bike Path Insertion")
*UC11 Manual Path Insertion*
#table(
  columns: 2,
  [*Name*], [Manual Path Insertion],
  [*Actors*], [Authenticated User, Map Service],
  [*Entry Conditions*], [- User navigates to Manual Insertion page],
  [*Event Flow*], [
    + The user accesses the functionality for manual bike path creation.
    + The user inserts street segment addresses
    + The system retrieves the corresponding locations of the addresses from an external Map Service
    + The system displays the map corresponding to the selected area.
    + The user selects the path status
    + The user selects the privacy status
    + The user presses the "Save" button
    + The system stores the bike path in the database],
  [*Exit Conditions*], [
    - A new bike path is stored in the database.
  ],
  [*Exceptions*], [
    - Internal Error prevents the path from being stored in the database
    - Missing Internet connection
    - User inserts streets that are not connected.
  ],
)


#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Personal History Management")

*UC12 Show Detailed View*
#table(
  columns: 2,
  [*Name*], [View Detailed Information],
  [*Actors*], [Authenticated User],
  [*Entry Conditions*], [
    - User opens BBP application on their device.
  ],
  [*Event Flow*], [
    + User navigates to their history page.
    + Application shows a list of paths associated with the user.
    + User selects a specific path to view more details.
    + The system displays the information:
        - System displays the visual representation of the path on a map.
        - System displays the status of the path.
        - System displays the privacy status.
        - System displays the date.
        - Optional: System displays the total time.
        // - Optional: System displays the active time.
        - Optional: System displays the average speed.
        - Optional: System displays the top speed.
        - Optional: System displays the total travelled distance.
        // - Optional: System displays the obstacles that were encountered.
        - Optional: System displays meteorological data.
  ],
  [*Exit Conditions*], [
    - User views the additional information.
  ],
  [*Exceptions*], [
    - Internal error prevents the system from fetching the data.
    - No internet connection.
  ],
)


#pagebreak()
*UC13 Set Bike Path Privacy*
#table(
  columns: 2,
  [*Name*], [Set Bike Path Privacy],
  [*Actors*], [Authenticated User],
  [*Entry Conditions*], [
    - User opens BBP application on their device.
  ],
  [*Event Flow*], [
    + User opens their history page.
    + The application shows a list of paths associated with the user.
    + User selects the desired path.
    + The system displays the path detail view.
    + User sets privacy toggle.
      - Toggle is set to "Off":
        + The user sets the privacy toggle off and saves.
        + The application updates the database by setting the path status to “Private”.
      - Toggle is set to "On":
        + The user sets the privacy toggle on and saves.
        + The application updates the database by setting the path status to “Public”.
  ],
  [*Exit Conditions*], [
    - Path has the selected privacy.
  ],
  [*Exceptions*], [
    - Internal error prevents the database from being updated.
    - No internet connection.
  ],
)

#pagebreak()
*UC14 Delete Bike Path*
#table(
  columns: 2,
  [*Name*], [Delete Bike Path],
  [*Actors*], [Authenticated User],
  [*Entry Conditions*], [ 
    - User opens BBP app and has at least one stored trip in personal history.
  ],
  [*Event Flow*], [
    + The user navigate to their History Page.
    + The system displays the list of recorded paths.
    + The user selects the desired path.
    + The system displays the path’s detailed view.
    + The user presses the “Delete” button.
    + The system asks for confirmation.
    + The user confirms.
    + The system deletes the path from the database.
  ],
  [*Exit Conditions*], [
    - The selected path is deleted from the database.
  ],
  [*Exceptions*], [
    - The path doesn’t exist in the database.
    - Missing Internet connection.
    - Internal error prevents the system from deleting the path from the database.
  ],
)

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Community Bike Path Browsing")
*UC15 Browse Community Paths*
#table(
  columns: 2,
  [*Name*], [Browse Community Paths],
  [*Actors*], [User],
  [*Entry Conditions*], [
    - User opens the BBP app.
    - The system contains publishable path information generated by users.
  ],
  [*Event Flow*], [
    + The user navigates to the community path browsing page.
    + The user specifies a starting point and a destination.
    + The system finds paths (with “Public” privacy status) connecting the two points.
    + The system evaluates each path using quality and freshness.
    + The system asks the Map Service to display each path.
    + The Map Service displays the ranked list of paths on a map.
    + Optional: if the user is authenticated they can select a path and start an automatic recording session.
  ],
  [*Exit Conditions*], [
    - The application correctly displays the ranked list of paths.
  ],
  [*Exceptions*], [
    - Cannot compute any path between the starting point and destination.
    - Origin/destination not recognized.
    - Map service is unavailable
  ],
)
#pagebreak()
=== Sequence Diagrams

#heading(level: 4, numbering: none,  outlined: false,  "Account Management")
*UC1 Account Creation*
#let accountCreationSequenceDiagram = ```plantuml
autonumber
actor User
boundary "BBP App" as Frontend
control "Backend" as Backend
database "Database" as DB
collections "KV Store" as KV
queue "SMTP Server" as SMTP
activate User
activate Frontend
User ->> Frontend: Open account page
Frontend -> User: Show email textfield
User ->> Frontend: Insert email
Frontend -> Backend: userExists(email)
activate Backend
Backend -> DB: userExists(email)
activate DB
DB --> Backend: 200 OK (false)
deactivate DB
Backend --> Frontend: 200 OK (false)
deactivate Backend
Frontend -> User: Show email verification textfield
Frontend -> Backend: sendVerificationCode(email)
activate Backend
Backend -> Backend: generateCode()
Backend -> KV: save(code, email)\n[TTL: 1H]
activate KV
KV --> Backend: 201 Created
deactivate KV
Backend ->> SMTP: enqueueVerificationEmail(email, code)
activate SMTP
SMTP ->> User: Deliver verification email
SMTP --> Backend: 200 OK
deactivate SMTP
Backend --> Frontend: 200 OK
deactivate Backend
Frontend -> User: Show code sent banner
User -> Frontend: Insert verification code
Frontend -> Backend: verifyCode(email, code)
activate Backend
Backend -> KV: getEmail(code)
activate KV
KV --> Backend: 200 OK (email)
deactivate KV
Backend -> Backend: checkEmail(email1, email2)
Backend --> Frontend: 200 OK
deactivate Backend
Frontend --> User: Show account signup form
User ->> Frontend: Insert name, password\naccept consents & privacy
Frontend -> Backend: signup(name, email, password, code)
activate Backend
Backend -> KV: getEmail(code)
activate KV
KV --> Backend: 200 OK (email)
deactivate KV
Backend -> Backend: checkEmail(email1, email2)
Backend -> DB: createAccount(name, email, password)
activate DB
DB --> Backend: 201 Created
deactivate DB
Backend --> Frontend: 201 Created (token)
deactivate Backend
Frontend -> User: Show homepage as logged user
```

#figure(
  accountCreationSequenceDiagram,
  kind: image,
  caption: [Account Creation Sequence Diagram]
)

#pagebreak()
*UC2 User Sign-In*
#let userSignInSequenceDiagram = ```plantuml
autonumber
actor User
boundary "BBP App" as Frontend
control "Backend" as Backend
database "Database" as DB
activate User
activate Frontend
User ->> Frontend: Open account page
Frontend -> User: Show email textfield
User ->> Frontend: Insert email
Frontend -> Backend: userExists(email)
activate Backend
Backend -> DB: userExists(email)
activate DB
DB --> Backend: 200 OK (true)
deactivate DB
Backend --> Frontend: 200 OK (true)
deactivate Backend
Frontend -> User: Show password textfield
User ->> Frontend: Insert password
Frontend -> Backend: signin(email, password)
activate Backend
Backend -> DB: getAccount(email)
activate DB
DB --> Backend: 200 OK (account)
deactivate DB
Backend -> Backend: checkCredentials(password, password)
alt Not valid credentials
  Backend --> Frontend: 401 Unauthorized
  Frontend -> User: Show error
else Valid credentials
  Backend --> Frontend: 200 OK (account, token)
  deactivate Backend
  Frontend -> User: Show homepage as logged user
end
```
#figure(
  userSignInSequenceDiagram,
  kind: image,
  caption: [User Sign-in Sequence Diagram]
)

#pagebreak()
*UC3 Account Deletion*
#let accountDeletionSequenceDiagram = ```plantuml
autonumber
actor User
boundary "BBP App" as Frontend
control "Backend" as Backend
database "Database" as DB
activate User
activate Frontend
User ->> Frontend: Press delete account button
Frontend -> User: Show confirmation
User ->> Frontend: Press confirm button
Frontend -> Backend: deleteAccount(email)
activate Backend
note over Frontend, Backend
  Request authenticated
end note
Backend -> DB: deleteAccount(email)
activate DB
DB --> Backend: 200 OK (true)
deactivate DB
Backend --> Frontend: 200 OK (true)
deactivate Backend
Frontend -> User: Show homepage as unauthenticated user
```
#figure(
  accountDeletionSequenceDiagram,
  kind: image,
  caption: [Account Deletion Sequence Diagram]
)

#pagebreak()
*UC4 User Sign-Out*
#let userSignOutSequenceDiagram = ```plantuml
autonumber
actor User
boundary "BBP App" as Frontend
activate User
activate Frontend
User ->> Frontend: Press logout account button
Frontend -> User: Show confirmation dialog
User ->> Frontend: Press confirm button
Frontend -> Frontend: deleteToken()
Frontend -> User: Show homepage as unauthenticated user
```
#figure(
  userSignOutSequenceDiagram,
  kind: image,
  caption: [User Sign-Out Sequence Diagram]
)

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Permission Management")

*UC5 Request Device Capability Permission*
#let requestCapabilitySequenceDiagram = ```plantuml
autonumber
actor User
boundary "BBP App" as Frontend
entity "Capability Provider" as CP
boundary "System Settings" as Settings
activate User
activate Frontend
Frontend -> Frontend: Needs device capability
Frontend -> CP: getAuthorizationStatus
activate CP
alt Capability access is unavailable
  CP --> Frontend: unavailable
  Frontend -> Frontend: Continue without capability
else Capability access was denied
  CP --> Frontend: denied
  Frontend -> User: Show a modal explaining\nwhy the capability is needed\nand instructionsto give\npermission in system settings
  loop Until user presses 'Cancel' or authorize capability access in settings
    alt Continue
      User ->> Frontend: Press 'Cancel' button
      Frontend -> Frontend: Continue without capability
    else Authorize capability access
      User ->> Settings: Authorize capability access
      activate Settings
      Settings -> CP: updateCapabilityAuthorization('authorized')
      deactivate Settings
      User ->> Frontend: Open application
      CP -> Frontend: updateCapabilityAuthorization('authorized')
      Frontend -> Frontend: Continue with capability
    end
  end
else Capability access is authorized
  CP --> Frontend: authorized
  Frontend -> Frontend: Continue with capability
else Capability access is not determined
  CP --> Frontend: notDetermined
  deactivate CP
  Frontend -> User: Show a modal explaining\nwhy the capability is needed
  alt Cancel
    User ->> Frontend: Press 'Cancel' button
  else Continue
    User ->> Frontend: Press 'Continue' button
    Frontend -> User: Show system dialog\nto give permission
    alt Not allow usage
      User ->> Frontend: Press 'Don't allow' button
      Frontend -> Frontend: Continue without capability
    else Allow usage
      User ->> Frontend: Press 'Allow' button
      Frontend -> Frontend: Continue with capability
    end
  end
end
deactivate CP
```
#figure(
  requestCapabilitySequenceDiagram,
  kind: image,
  caption: [User Sign-Out Sequence Diagram]
)

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Automatic Bike Path Recording")
*UC6 Automatic Recording With Manual Controls*
#let automaticRecordingManualControlsSequenceDiagram = ```plantuml
autonumber
actor User
boundary "BBP App" as Frontend
activate User
activate Frontend
User ->> Frontend: Press "start" button
loop Until recording stops
  alt User presses "resume" button
    User ->> Frontend: Press "resume" button
    Frontend -> Frontend: Resume timer
    Frontend -> User: Show updated UI
  else User presses "pause" button
    User ->> Frontend: Press "pause" button
    Frontend -> Frontend: Pause timer
    Frontend -> User: Show updated UI
  end
end
User ->> Frontend: Press "Stop Recording" button
```
#figure(
  automaticRecordingManualControlsSequenceDiagram,
  kind: image,
  caption: [Automatic Recording With Manual Controls Sequence Diagram]
)

#pagebreak()
*UC7 Automatic Recording With Activity Detection*
#let automaticRecordingManualActivityDetectionSequenceDiagram = ```plantuml
autonumber
actor User
boundary "BBP App" as Frontend
control "Sensor API" as CP
activate User
activate Frontend
User ->> Frontend: Press 'start' button
Frontend -> CP: startActivityUpdates(handler)
activate CP
loop Until recording stops
  alt User starts biking
    CP ->> Frontend: cycling
    Frontend -> Frontend: Start/resume timer
    Frontend -> User: Show updated UI
  else User stops biking
    CP ->> Frontend: stationary / walking / ...
    Frontend -> Frontend: Pause timer
    Frontend -> User: Show updated UI
  end
end
User -> Frontend: Press 'stop' button
Frontend -> CP: stopActivityUpdates()
deactivate CP
```
#figure(
  automaticRecordingManualActivityDetectionSequenceDiagram,
  kind: image,
  caption: [Automatic Recording With Activity Detection Sequence Diagram]
)

#pagebreak()
*UC8 Manual Obstacle Insertion*
#let manualObstacleInsertionSequenceDiagram = ```plantuml
autonumber
actor User
boundary "BBP App" as Frontend
activate User
activate Frontend
User ->> Frontend: Press 'start' button
loop Until recording stops
  User ->> Frontend: Press 'add obstacle' button
  Frontend -> Frontend: Increment obstacle count
  Frontend -> User: Show obstacle confirmation dialog
  alt User confirms or ignores dialog
    User ->> Frontend: Press 'confirm' button
  else User cancels
    User ->> Frontend: Press 'cancel' button
    Frontend -> Frontend: Decrement obstacle count
  end
end
User ->> Frontend: Press 'stop' button
```
#figure(
  manualObstacleInsertionSequenceDiagram,
  kind: image,
  caption: [Manual Obstacle Insertion Sequence Diagram]
)

#pagebreak()
*UC9 Automatic Obstacle Detection*
#let automaticObstacleDetectionSequenceDiagram = ```plantuml
autonumber
actor User
boundary "BBP App" as Frontend
control "Sensor API" as CP
activate User
activate Frontend
User ->> Frontend: Press "start" button
Frontend -> CP: startAccelerometerUpdates(handler)
activate CP
Frontend -> CP: startGyroUpdates(handler)
loop Until recording stops
  CP ->> Frontend: accelerometerData
  CP ->> Frontend: gyroData
  Frontend -> Frontend: detectObstacle(accelerometerData, gyroData)
  opt Obstacle is detected
    Frontend -> Frontend: Increment obstacle count
    Frontend -> User: Show obstacle confirmation dialog
    alt User confirms or ignores dialog
      User ->> Frontend: Press "confirm" button
    else User cancels
      User ->> Frontend: Press "cancel" button
      Frontend -> Frontend: Decrement obstacle count
    end
  end
end
User ->> Frontend: Press "stop" button
Frontend -> CP: stopAccelerometerUpdates()
Frontend -> CP: stopGyroUpdates()
deactivate CP
```
#figure(
  automaticObstacleDetectionSequenceDiagram,
  kind: image,
  caption: [Automatic Obstacle Detection Sequence Diagram]
)

#pagebreak()
*UC10 Stop Recording*
#let stopRecordingSequenceDiagram = ```plantuml
autonumber
skinparam SequenceMessageAlign center
actor User
boundary "BBP App" as App
control "GPS/Sensor" as Sensors
database "Database" as DB
boundary "Weather API" as API
activate User
activate App
User ->> App: Select "Stop Recording"
App -> User: Request for confirmation
User ->> App: Confirm
App -> Sensors: Stop collecting data
activate Sensors
Sensors --> App: Confirmation
deactivate Sensors
App -> API: Meteorological data request
alt Meteorological data available
    activate API
    API --> App: Meteorological data
else Meteorological data unavailable
    API --> App: Data unavailable
    deactivate API
end
App --> App: Compute path statistics
App -> DB: Save path data 
activate DB
DB --> App: Path data saved
deactivate DB
App -> User: Show Homepage
```
#figure(
  stopRecordingSequenceDiagram,
  kind: image,
  caption: [Stop Recording Sequence Diagram]
)

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Manual Bike Path Insertion")
*UC11 Manual Path Insertion*
#let manualPathInserionSequenceDiagram = ```plantuml
autonumber
actor "User" as U
boundary "BBP App " as UI
boundary "Map Service" as MAP
database "BBP Database" as DB
== Open manual creation ==
activate U
activate UI
U ->> UI : Open "Manual Path Creation"
UI -> U : Show form
== Insert Street Segments ==
loop Until all street segment are inserted
  U ->> UI : Insert street segment address
  UI -> MAP : reverseGeocode(streetAddress)
  activate MAP
  MAP --> UI : streetLocation
  deactivate MAP
  UI -> UI : Store street location
  UI -> MAP : addLocationToMap(streetLocation)
  activate MAP
  MAP -->> UI : updateShownMapArea
  deactivate MAP
  UI -> U : Show map with updated area
end
== Select Status == 
U ->> UI : Select path status
UI -> UI : Store path status
== Set Privacy ==
U ->> UI : Set path privacy
UI -> UI : Store path privacy
== Save ==
U ->> UI : Tap "Save"
UI -> DB : savePath(streetLocations, status, privacy, date)
activate DB
DB --> UI : OK
deactivate DB
UI -> U : Show path added to history
```
#figure(
  manualPathInserionSequenceDiagram,
  kind: image,
  caption: [Manual Path Insertion Sequence Diagram]
)

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Personal History Management")
*UC12 Show Detailed view* 
#let showUserPathDetailedViewSequenceDiagram = ```plantuml
autonumber
actor "User" as User
boundary "BBP App " as App
database "BBP Database" as db
activate User
activate App
User ->> App: Open application
App -> User: Show History Page 
App -> db: getPaths(user)
activate db
db --> App: userPaths
deactivate db
App -> User: Show user paths 
User ->> App: Select path
App -> User: Show Detailed view
App -> db: getUserPathDetails(userPath)
activate db
db --> App: userPathDetail
deactivate db
App -> User: Show Path Details
opt Performance data available
    App -> User: Show Performance data
end
opt Meteorological data available
    App -> User: Show Meteorological data
end
```
#figure(
  showUserPathDetailedViewSequenceDiagram,
  kind: image,
  caption: [Show Detailed View Sequence Diagram]
)

#pagebreak()
*UC13 Set Bike Path Privacy*
#let setPrivacySequenceDiagram = ```plantuml
autonumber
actor "User" as User
boundary "BBP App " as App
database "BBP Database" as db
activate User
activate App
User ->> App: Open application
App -> User: Show History page 
activate db
App -> db: getPaths(user)
db --> App: userPaths
deactivate db
App -> User: Show user paths 
User ->> App: Select path
App -> User: Show Detailed view
alt Publish bike path
    User ->> App: Set privacy toggle to "On"
    User ->> App: Press save button
    activate db
    App -> db: setPrivacyStatus(userPath, "Public") 
    db --> App: OK
    deactivate db
else Unpublish bike path
    User ->> App: Set privacy toggle to "Off"
    User ->> App: Press save button
    activate db
    App -> db: setPrivacyStatus(userPath, "Private") 
    db --> App: OK
    deactivate db
end
App -> User: Notify User
deactivate App
```
#figure(
  setPrivacySequenceDiagram,
  kind: image,
  caption: [Set Bike Path Privacy Sequence Diagram]
)

#pagebreak()
*UC14 Delete Bike Path*
#let deleteBikePathSequenceDiagram = ```plantuml
autonumber
actor "Authenticated User" as U
boundary "BBP App " as UI
database "BBP Database" as DB
activate U
activate UI
== Open history ==
U ->> UI : Open History Page
UI -> DB : getPaths(user)
activate DB
DB --> UI : pathList
deactivate DB
UI -> U : Show user paths
== Delete trip ==
U ->> UI : Select path
UI-> DB: getUserPathDetails(userPath)
activate DB
DB --> UI: userPathDetail
deactivate DB
UI-> U: Show Path Details
U ->> UI: Delete Path
UI -> U : Show confirmation dialog
alt User cancels deletion
  U ->> UI : Tap "Cancel"
else User confirms deletion
  U ->> UI : Tap "Confirm"
  UI -> DB : deletePath(path)
  activate DB
  DB --> UI : OK
  deactivate DB
  UI -> DB : getPaths(user)
  activate DB
  DB --> UI : pathList
  deactivate DB
  UI -> U : Show History Page
end
deactivate UI
```
#figure(
  deleteBikePathSequenceDiagram,
  kind: image,
  caption: [Delete Bike Path Sequence Diagram]
)

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Community Bike Path Browsing")
*UC15 Browse Community Paths*
#let browseCommunityPathSequenceDiagram = ```plantuml
autonumber
actor "User" as U
boundary "BBP App " as UI
boundary "Routing/Map Service" as MAP
database "BBP Database" as DB
activate UI
activate U
== Open feature ==
U ->> UI : Open "Find Paths"
UI -> U : Show search form
== Submit query ==
U ->> UI : Enter start + destination
UI -> DB : fetchPathMetadata(start, destination)
activate DB
DB --> UI: paths + metadata
deactivate DB
UI -> UI : rankPaths(paths, metadata)
UI -> MAP : mapPaths(paths)
activate MAP
MAP --> UI : map
deactivate MAP
UI -> U : Display ranked list and render paths on map
opt User is authenticated
  U ->> UI : Select a Path
  UI -> U : Show “Start Recording” Button
  U ->> UI : Press “Start Recording” Button
  UI -> U : Show Automatic Recording Page\nwith selected path displayed on the map
end
deactivate UI
deactivate U
```
#figure(
  browseCommunityPathSequenceDiagram,
  kind: image,
  caption: [Browse Community Paths Sequence Diagram]
)

#pagebreak()
== Performance Requirements

Regarding the performance analysis of our system, the BBP application must ensure a satisfactory user experience. To achieve this, the system must provide the user with the requested data within an adequate period of time, specifically when interacting directly with the UI.

Therefore, the system will apply pagination when potentially large quantities of data are requested by the user, for example when retrieving ranked lists of community bike paths from the database.

The system must also ensure that more computationally intensive back-end operations don’t reduce the responsiveness of the application, especially when computing aggregated quality scores and displaying one or more alternative paths on a map to the user.

While biking, the app must periodically collect GPS and sensor data to guarantee a high degree of accuracy of the followed route (within 10 meters of the actual position of the user), while also maintaining a relatively low level of battery consumption and CPU usage.

The following table provides the ideal maximum duration for each operation under normal load conditions.

#figure(
  table(
    columns: 2,
    table.header([*Operation*], [*Maximum duration*]),
    [Page loading], [≤ 2s],
    [Map rendering (single path)], [≤ 3s],
    [Map rendering (multiple paths)], [≤ 5s],
    [User sign-in / sign-up], [≤ 2s],
    [Database update (profile update)], [≤ 2s],
    [Database update (path saving)], [≤ 3s],
    [GPS sampling interval], [≤ 3s],
    [Sensor sampling interval], [≤ 0.1s],
  ),
  caption: [Maximum duration of operations]
)

#pagebreak()
== Design Constraints

=== Standards Compliance

The Best Bike Paths application must comply with the following standards and guidelines:

*Platform Design Guidelines*
- Apple Human Interface Guidelines (iOS)
- Google Material Design (Android)

*Privacy and Data Protection Requirements*
- GDPR (EU General Data Protection Regulation) for handling user data
- Compliance with licensing and usage requirements of any third-party service (e.g., Google Maps API)

*Development Requirements*
- ISO/IEC/IEEE 24748-8 (Agile) to establish a formal Life cycle management framework for the application development process.

=== Hardware Limitations

*Minimum Deployment Versions* \
To ensure access to modern platform-specific API, guarantee compatibility with recent device capabilities, and maintain ongoing operating system support, the application limits its deployment targets to N and N-1 major OS versions. As of Q4 2025, the current resulting minimum supported versions are:
- iOS 18
- Android 15 (minimum deployment target for Google Play store from 2025)
These constraints ensure that the application runs only on devices that offer sufficient processing power and updated security features.

*Minimum Technical Specifications* \
The application is designed assuming at least the following device characteristics, derived from the full Android 15 system recommended requirements:
- CPU: 64-bit Quad-core or higher.
- RAM: minimum of 4 GB of device RAM.
- Storage: minimum of 32 GB.
- Display: HD+ (720p) or better.

*Sensors* \
We can assume the presence of the following sensors for the mobile app, but their unavailability properly should be handled:
- GPS module
- Accelerometer
- Gyroscope

*Internet connection* \
The mobile device must be able to connect to the internet (the app should also be capable of handling interruptions of network access).

=== Any Other Constraint

*Permission and user consent* \
The system’s functionality is constrained by user-granted permissions (e.g., location, motion sensors), the app should be able to disable dependent features and provide appropriate fallbacks or user feedback.

*Dependency on Third-Party Services* \
The app may depend on external services (e.g., SMTP Server, Google Maps on Android, host services for Backend). Any outages, API policy changes, or rate limits imposed by these providers may impact performance or functionality of the app.

*Offline Operation* \
In the absence of network connectivity the app should be able to store the information locally and sync them once the connection it’s available again.

#pagebreak()
== Software System Attributes

=== Reliability
When interacting with the application outside of biking, the system should ensure access to its main functionalities even during serious failures. To guarantee this, the system must be implemented with fault-tolerance mechanisms that allow its components to degrade gracefully.

Regarding the automatic recording functionality, the system must ensure that any failures due to GPS and motion-sensor malfunctions or imprecise and conflicting data do not lead to application crashes and loss of data. This unfinished path information must therefore be durable, consistent, and recoverable. To ensure these properties, the data must be reliably stored on the user’s device using mechanisms that reduce any risk of corruption and that allow recovery when possible.

Finally, the inability to connect to external services, specifically for retrieving meteorological data, must be appropriately handled.

=== Availability
While the system doesn’t offer any emergency-related service, the system should still guarantee a relatively high availability percentage to allow both unauthenticated and authenticated users to access its services.
An appropriate target should be the standard 99%, which corresponds to 3.65 days of downtime per year.

_Further details will be provided in the corresponding Design Document_

=== Security
The application must ensure the protection of the users’ sensitive data. This should be guaranteed by hashing passwords and using a secure, encrypted connection to prevent man-in-the-middle attacks. 
Network requests related to authentication-protected features should always be accompanied by a valid JWT, which will be verified by the server.

The system should also employ mechanisms that protect the database against SQL injections.
GPS data can be collected once the user gives explicit permission when prompted and only when the user enables automatic recording.

All noise-filtering operations should happen on the client-side to reduce server load and minimize exposure of sensitive data on the network.

While automatic recording is active, GPS data should be encrypted on the user’s device and eliminated from the user’s device when the data transfer is completed.
On the server, location data must be stored securely and encrypted according to server-side policies.\

_Further details will be provided in the corresponding Design Document_

=== Maintainability
The system should be implemented using design patterns that promote scalability, reusability, and maintainability of its components.
Any maintenance activities should be scheduled in a way that minimizes their impact on users as much as possible.

_Further details will be provided in the corresponding Design Document_

=== Portability
The application should be able to run on the main mobile operating systems, specifically Android and iOS. The app should be supported by mobile devices, like smartphones and tablets, as long as they  respect the hardware limitations outlined in Section 3.4.2. 

= Formal Analysis Using Alloy
The Alloy analysis of our BBP project allows for a formal demonstration of how the requirements defined in the previous section are both necessary and sufficient for the satisfaction of our initially defined goals.

This analysis mainly focuses on the representation of some of the core functions provided by the application, such as the  “path browsing” functionality through which users are given bike path recommendations based on a quality score, and the publishing functionality that allows users to make their paths available to the public, as well as the way the system manages the validity of each recorded bike path.\
We also focus on the management of user permissions for accessing device capabilities (e.g., notifications, sensors, GPS) and the protection of sensitive user data.

For the sake of simplicity and clarity, some elements that define our system have been simplified, allowing for better readability of both the code and the diagrams, while still capturing the essential constraints and behaviors. The main simplifications are listed below:
- There is no distinction between unauthenticated and authenticated users
- GPS and sensor data is excluded from the bike path representations
- The process through which a street is considered compatible is omitted
- No distinction is made between different types of obstacles
- Paths are  acyclic
- Paths aren't necessarily formed by a connected sequence of street segments

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Community Path Browsing")

```alloy
sig User{
	paths: set Path
}

sig Path{
	streets: some Street,
	start: one Street,
	end: one Street,
	var obstacles: set Obstacle,
	status: one Status,
	creator: one User,
	var privacy: one Privacy,
	alert: one Alert,
}{
    start in streets
    end in streets
}

sig RecommendedPath{
	streets: some Street,
	instances: some Path,
	quality: one Int,
	alert: one Alert}{
	
	//every path instance must have the same streets
	all p1, p2 : instances | p1.streets = p2.streets

	// the RecommendedPath streets must be equal to the streets of its instances
 streets = instances.streets
	
	//the alert badge of the RecommendedPath is active if it contains at least one street that is incompatible
	alert=On iff (some s: streets | s.compatible = No)
	
	all p: instances | p.privacy = Public

	all p1, p2: instances | p1.start = p2.start and p1.end = p2.end
}



sig Query {
    qStart: lone Street,
    qEnd: lone Street,
    requester: one User,
    var results: set RecommendedPath
}

sig Street{
	connectedTo: set Street,
	compatible: one Compatibility
}{
	no s: connectedTo | s = this
}

abstract sig Obstacle{}

enum Status{Optimal, Medium, RequiresMaintenance}

enum Privacy{Public, Private}

enum Alert{On, Off}

enum Compatibility{Yes, No}

//Each recorded path is owned by its creator
fact Ownership{
    all p: Path, u: User | p in u.paths implies p.creator = u
}

fact ValidPath {
  all p: Path | {
     some p.streets
     //everything in the path must be reachable from start
     all s: p.streets | s in p.start.^connectedTo

	   all s:p.streets | s in p.streets.connectedTo

	    //no cycles
     p.start != p.end
    }
}

fact badPathAlert{
  	  all p:Path | (some s: p.streets | s.compatible = No) iff p.alert = On
}

fun start[rp: RecommendedPath]: one Street {
  rp.instances.start
}

fun end[rp: RecommendedPath]: one Street {
    rp.instances.end
}

fact ComputeQualityScore {
    all rp: RecommendedPath |
        rp.quality = score[rp]
}

//to model data freshness in the quality score computation, only one user path
//is considered, representing the most recently recorded instance, while older
//path instances are ignored.

fun obstacleCount[p: RecommendedPath]: Int {
    # { o: Obstacle | one i: p.instances | o in i.obstacles }
}

fun score[p: RecommendedPath]: Int {
    obstacleCount[p]
}

//the query returns a set of path recommendations with the same beginning and end
//as the ones specified in the query
fact QueryProducesResults {
    always (
        all q: Query |
            (some q.qStart and some q.qEnd) implies
            after (
                q.results = { p: RecommendedPath | start[p] = q.qStart and end[p] = q.qEnd}
            )
    )
}

//each query produces the top three best path recommendations
fact TopThreeBest {
	all q: Query |
		let matched = { p: RecommendedPath | start[p] = q.qStart and end[p] = q.qEnd } |
        
    //No matched path outside the results has better quality
		all p: matched - q.results | all r: q.results | r.quality <= p.quality and	#q.results <= 3
}
```

@alloy-community-path-browsing-world1 shows an example of two paths, both owned by the same user and associated with their respective data. The two paths contain the same set of streets but differ in the information attached to them. For instance, the obstacles encountered along each path are different, which reflects a realistic scenario that may occur in practice.
The two paths also have different status values. Although the computation of the status was excluded from this Alloy representation, this situation is still plausible, since users can create their own paths and assign different statuses despite having the same route.
Another characteristic is the presence of an incompatible street in the paths, which causes the Alert signature associated with each path to be in the “On” state.

#figure(
  image("alloy/community-path-browsing/world1.png"),
  caption: [Two paths with same route]
) <alloy-community-path-browsing-world1>

The following assertion verifies that each query requested by the user will only contain the RecommendedPaths with the highest rating, allowing the user to view the best possible paths between two points.
The quality of each path recommendation is computed by selecting the number of obstacles in a  single “path instance”. The selected paths are the ones with the lowest scores. This is clearly a simplification to illustrate how the overall quality of a path is determined by the recorded data, but in reality it must consider many more factors that can’t be clearly illustrated through an Alloy model.

```alloy
assert BestPathsAreRecommended {
  all q: Query |
    (some q.qStart and some q.qEnd) implies
    eventually (
      let matched = { p: RecommendedPath | start[p] = q.qStart and end[p] = q.qEnd } |

      //The results contain the highest-quality paths
      all p: matched - q.results | all r: q.results | p.quality >= r.quality
    )
}
```
#figure(
  image("alloy/community-path-browsing/BestPathsAreRecommended.png", height: 10%),
  caption: [`BestPathsAreRecommended` assertion execution]
)

The following assertion shows how every user will be visually notified if a certain path may not be suitable for biking, therefore allowing the user to follow specific paths with the full knowledge of the possible risks associated with them.
```alloy
assert NoFalseAlerts {
    all p: Path | p.alert = On implies some s: p.streets | s.compatible = No
}
```
#figure(
  image("alloy/community-path-browsing/NoFalseAlerts.png", height: 10%),
  caption: [`NoFalseAlerts` assertion execution]
)

The assertion below verifies that only public paths are returned to the user following a query, thereby forbidding the use of private paths in constructing the query response and protecting the user’s private data.
```alloy
assert NoPrivatePathsInQueryResults {
    all q: Query |
        all rp: q.results |
            all p: rp.instances |
                p.privacy = Public
}
```
#figure(
  image("alloy/community-path-browsing/NoPrivatePathsInQueryResults.png", height: 10%),
  caption: [`NoPrivatePathsInQueryResults` assertion execution]
)

@alloy-community-path-browsing-world2 illustrates an example of a query execution. The query returns two path recommendations to the user. Each recommendation is computed based on a set of path instances, which are used to determine the overall quality of the path. In this example, both path recommendations consist of a single instance, each with the same start and end points specified in the query, but following different routes between them. Each recommendation is associated with a quality score, calculated based on the characteristics of its path instances, particularly the number of obstacles.
#figure(
  image("alloy/community-path-browsing/world2.png"),
  caption: [Query execution]
) <alloy-community-path-browsing-world2>

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Permission Management")

In the following section we analyze the management capability permissions and requests for access. A capability represents any device feature requiring user authorization, such as localization services, motion sensors, and notifications.

A capability is considered usable by the application only if the user has explicitly granted authorization. Authorization for a capability may be requested directly from the user only when the capability is available on the device and the system has not previously requested permission for it.

If the user denied the system permission request, the capability permission should be enabled in the device’s system settings.

```alloy
open util/boolean

sig Capability {
  var status: one CapabilityStatus,
  var isUsable: one Bool,
  var availableAction: lone CapabilityAction
}

enum CapabilityStatus {
  Unavailable,
  NotDetermined,
  Denied,
  Authorized
}

enum CapabilityAction {
  AskPermission,
  ModifyInSettings
}

fact CapabilityUsability {
  always all c: Capability |
    c.isUsable = True iff c.status = Authorized
}

fact CapabilityAvailableActions {
  always all c: Capability |
    (
      c.status = Unavailable implies
        no c.availableAction
    ) and
    (
      c.status = NotDetermined implies
        c.availableAction = AskPermission
    ) and
    (
      c.status = Denied implies
        c.availableAction = ModifyInSettings
    ) and
    (
      c.status = Authorized implies
        no c.availableAction
    )
}

```

@capability-management-world is an example of a world showcasing two capabilities that are available on the user's device.
Although both capabilities exist, neither is currently usable by the application. In fact, permission to access the first capability was explicitly denied by the user, while access to the second hasn't yet been requested and will therefore remain unavailable until BBP explicitly asks the user for permission.

#figure(
  image("alloy/capability-management/world.png"),
  caption: [Query execution]
) <capability-management-world>

The following assertion checks that a capability is not usable if permission was authorized by the user.
```alloy
assert AuthorizedIsUsable {
  always all c: Capability |
    c.status = Authorized implies c.isUsable = True
}
```
#figure(
  image("alloy/capability-management/AuthorizedIsUsable.png"),
  caption: [`AuthorizedIsUsable` assertion execution]
)

The following assertion checks that a capability is not usable if permission was denied by the user.
```alloy
assert DeniedNotUsable {
  always all c: Capability |
    c.status = Denied implies c.isUsable = False
}
```
#figure(
  image("alloy/capability-management/DeniedNotUsable.png"),
  caption: [`DeniedNotUsable` assertion execution]
)

Here we check that permission for the capability can be asked if not yet determined.
```alloy
assert NotDeterminedRequiresAsk {
  always all c: Capability |
    c.status = NotDetermined implies c.availableAction = AskPermission
}
```
#figure(
  image("alloy/capability-management/NotDeterminedRequiresAsk.png"),
  caption: [`NotDeterminedRequiresAsk` assertion execution]
)

Here we check that no action can be taken if the capability is unavailable.
```alloy
assert UnavailableImpliesNoAction {
  always all c: Capability |
    c.status = Unavailable implies no c.availableAction
}
```
#figure(
  image("alloy/capability-management/UnavailableImpliesNoAction.png"),
  caption: [`UnavailableImpliesNoAction` assertion execution]
)

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Automatic Recording")

= Effort Spent

#figure(
  table(
    columns: 4,
    table.header([], [*Foad Zahedi Labaf*], [*Lorenzo Fiamingo*], [*Alexander Gabriel Fox*]),
    [*Section 1*], [], [], [],
    [*Section 2*], [], [], [],
    [*Section 3*], [], [], [],
    [*Section 4*], [], [], [],
  ),
  caption: [The number of hours each group member has worked for this document]
)

= References

- *Typst* language and online editor to build this document.
- *PlantUML* to define and create diagrams.
- *Alloy* for formal analysis.
- *GitHub* for project versioning and automate diagram creation.
- *Google Docs* for collaborative writing.
- *Xcode* and *SwiftUI* to create UI mocks.


#show: backmatter.with()


