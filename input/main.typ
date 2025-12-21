#import "@local/polimi:1.0.0": *
#import "@preview/pintorita:0.1.4"

#show raw.where(lang: "pintora"): it => pintorita.render(it.text)


#show: polimi-thesis.with(
  title: "Best Bike Paths",
  subtitle: "Requirements Analysis and Specification Document",
  author: "Foad Zahedi Labaf\nLorenzo Fiamingo\nAlexander Gabriel Fox",
  advisor: "",
  coadvisor: "",
  tutor: "",
  academic-year: "2025/2026",
  chair: none,
  language: "en",
  colored-headings: true,
)

#show: mainmatter.with()

= Introduction

== Purpose
Biking is an immensely beneficial activity, providing both physical and mental benefits. To encourage more people to take up this activity, it is crucial to provide them with the necessary tools to enhance their experience. 
Best Bike Paths aims to make biking a more rewarding experience by providing an intuitive software application that automatically records the paths that users take while exploring the world around them. 
This app is able to automatically record these paths by accessing the various sensors and GPS of the user’s device, but also allows its users to manually add these paths.
The application securely stores this information to allow its users to revisit their trips and track their progress as they increase their proficiency in this sport. 
Best Bike Paths also allows users to publicly share these paths, allowing others to choose recommended bike paths based on their overall quality.
BBP’s ultimate goal is to offer its users a valuable tool that streamlines the process of cataloging their bike trips and cultivates a community of bikers by allowing them to share their experiences.

=== Goals
G1: Authenticated users want to automatically record bike path data while they are biking.
\
G2: Authenticated users want to manually insert bike paths by specifying streets and status.
\
G3: Authenticated users want to approve or reject obstacles detected by the system.
\
G4: Authenticated users want to manually record an obstacle while they are biking.
\
G5: Authenticated users want to retrieve all the collected data of their personal bike paths.
\
G6: Authenticated users want to be able to share their recorded bike paths with the community.
\
G7: Authenticated users want to enrich the data of their bike paths with relevant statistics (average speed, total distance, duration) and meteorological information, if available.
\
G8: After specifying the start and destination, all the users want the ability to browse the paths (with the same starting point and destination) published by other authenticated users and ranked based on quality.
\
G9: The users want the paths to be ranked based on compatible speed limits, average path status, and data freshness.

== Scope
The purpose of this application is to provide relevant and accurate information about bike paths. In order to do this, BBP offers a wide array of functionalities, such as the ability to collect information about the followed paths, either by allowing users to manually insert the data or through an automated recording function that interacts with the GPS and sensors of the device on which the app resides. The collected information will be securely stored in a remote database, and can optionally be made publicly available.
Users will be able to access and manage their stored information through the app.
This data can then be used by the BBP app to further develop its recommendation system, which will suggest bike paths based on the evaluations provided by other users or computed by the system.
This application is primarily intended for authenticated users who, once authenticated within the system, will be able to record or manually insert new bike paths to track their cycling experiences. However, the BBP app will also allow unauthenticated users to partially access its functionalities, mainly the ability to browse publicly available bike paths.
To enable automatic recordings of bike paths, the BBP application accesses the device’s GPS interface to determine the user’s exact location while biking, as well as other sensor interfaces to collect more relevant information associated with the travelled path. The app will also access an external API for the collection of meteorological data.
This application is therefore intended to run on a mobile device equipped with GPS, motion sensors, and internet connectivity for the automatic collection and the remote storage of data in the system’s database.



=== World Phenomena
WP1: The user decides to take a bike trip.
\
WP2: Weather conditions change over time.
\
WP3: Accelerometer and gyroscope collects device motion data.GPS collects device location data.
\
WP4: GPS collects device location data.
\
WP5: Street infrastructure changes over time (new streets are built, existing streets are upgraded, downgraded, or decommissioned).
\
WP6: Path conditions change over time due to natural degradation, weather, or maintenance.
\
WP7: The user starts and stops biking.
\
WP8: The user velocity changes.
\
WP9: The user encounters an obstacle.
\
WP10: Stoplight changes color.
\
WP11: The user's device’s internet connection changes over time.






=== Shared Phenomena

*World Controlled* \
SP1: The user creates an account. \
SP2: The user signs in and out of their account. \
SP3: The user deletes their account. \
SP4: The user starts, stops and pauses the recording of the bike path. \
SP5: The user selects or inserts street segments of a bike path. \
SP6: The user sets the status of the path. \
SP7: The user sets the privacy of the path. \
SP8: The user confirms or rejects obstacles by the system. \
SP9: The user manually adds an obstacle. \
SP10: The user deletes one of their bike paths. \
SP11: The user selects a starting point and a destination when browsing community bike paths. \
SP12: The users choose which path in the proposed routes should be followed. \
SP13: GPS provides the location samples. \
SP14: Accelerometer and gyroscope share motion data with the system. \
SP15: External services provide meteorological information.

*Machine Controlled* \
SP16: The system records GPS and sensor data during a user’s trip. \
SP17: The system displays the travelled path. \
SP18: The system displays the selected path to follow.  \
SP19: The system displays a notification to the user after detecting a possible obstacle. \
SP20: The system displays the current travel time and additional statistics about the trip while recording. \
SP21: The system pauses the recording when the user slows down.  \
SP22: The system collects weather data from the weather API when recording stops. \
SP23: The system displays  the user’s personal bike paths in their  history.  \
SP24: The system displays ranked community bike paths between a chosen origin and destination. \
SP25: The system shows detailed information for any selected path. \
SP26: The system alerts the user when a selected path contains incompatible streets for biking. 


#figure(
  caption: [Mapping between goals and phenomena],
  table(
    columns: 3,
    [], [Shared Phenomena], [World Phenomena],
    [*G1*], [W1],  [],
    [*G2*], [],  [],
    [*G3*], [],  [],
    [*G4*], [],  [],
    [*G5*], [],  [],
    [*G6*], [],  [],
    [*G7*], [],  [],
    [*G8*], [],  [],
    [*G9*], [],  [],
  )
)

== Definitions, Acronyms, Abbreviations

=== Definitions
*User*: Term used to indicate both authenticated and unauthenticated individuals who interact with the application. These individuals can be distinguished between authenticated and unauthenticated users.

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

*History Page*: A user’s history page is a section of the user’s profile that displays a list of previously recorded bike trips and allows the user to access detailed information about each trip.


=== Acronyms

*API*: Application Programming Interface \
*BBP*: Best Bike Paths \
*CPU*: Central Processing Unit \
*CTA*: Call To Action \
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
4. *Formal analysis using Alloy*: a formal description of the domain and an analysis of  some of the product’s requirements through Alloy in order to objectively determine the satisfaction of specific goals.
5. *Effort spent*: Includes the amount of time dedicated by each member for the realization of each section of the document.
6. *References*: reference to documents or tools used for writing this document.

= Overall Description

== Product Perspective

=== Scenarios

#heading(level: 4, numbering: none,  outlined: false,  "Account Management")

*Unauthenticated user signs up an account* \
The user, after downloading the Best Bike Paths app, opens it on their device. Since the user is anonymous the app displays a content unavailable view explaining what the user is missing, since they’re not logged in, and a CTA to sign in. The user decides to create an account in order to take full advantage of the app’s capabilities. After tapping the sign-in button, the app presents a modal. The user is prompted to insert an email, which the app uses to discern if the user is new and should create a new account or, if already taken, to log in. The user inserts their email and the app verifies the email is not used by another account.  The app then displays a verify-email page where the user has to insert a one-time code sent to their email. After correctly inserting the code, the app displays a page with a name, password and password-confirmation text fields.  After inserting the new requested data, the modal is dismissed and the user is redirected to the home view.

*Authenticated User deletes their account* \
An authenticated user opens the BBP application and accesses their personal profile settings.
The user selects the option to delete their account. The system informs the user that deleting the account will permanently remove all data associated with the user, including personal profile information, recorded trips, and any bike paths previously published by the user.
After the user confirms this action, the system deletes the account and all related data from the database and terminates the user session.

*Unauthenticated user signs into their account* \
A user, after some time, decides to use the Best Bike Paths app again and opens it. After tapping the sign-in button, the app presents a modal. The authenticated user is prompted to insert an email, which the app uses to discern if the user is new and should create a new account or, if already taken, to log in. After the user inserts an email belonging to an account, the app shows a password box. If the password is wrong, the app reports the error.  After inserting the correct password, the modal is dismissed and the user is redirected to the home view. 

*Authenticated user signs out of their account* \
An authenticated user presses the sign-out button. The app signs the user out of their account, redirecting them to the home page, where he can browse community bike paths. However, the user will now have to perform the log-in to access the full functionalities of the application.

#heading(level: 4, numbering: none,  outlined: false,  "Permission Management")

*System asks permission to use a device capabilities (GPS case)* \
The authenticated user decides to record his first ride and taps the Start Recording button. A modal explaining why the app must access location data is displayed. The modal contains accept and cancel buttons. If the user selects the Cancel option, the modal is dismissed and the user remains on the home screen. If the  user selects the Accept option, the system presents the dialog requesting permission to access the location. If the user grants permission, the view to record the bike path is presented, otherwise the user remains in the home, and the next time this capability would be needed, he will be required to give permission through the device’s system settings app.
The same flow of events will be replicated wherever other capabilities are required by the application.

#heading(level: 4, numbering: none,  outlined: false,  "Automatic Bike Path Recording")

*Authenticated Users press start button before biking* \
While on the home page, the user presses the Start Recording button. The app displays the path recording page, consisting of a map, a timer, and a start button. If the user presses the start button the system begins the time-lapse, and displays a Stop button, a pause button and relevant information regarding the trip, such as the covered distance, current speed, average speed and top speed.

*Authenticated User pauses recording* \
While a trip recording is in progress, the user temporarily stops biking and selects the option to pause the recording.
The system suspends the collection of GPS and sensor data and stops the trip timer. 
When the user decides to resume biking, the user selects the resume option. The system continues the recording, continues collecting GPS and sensor data, and updates the trip statistics accordingly until the trip is stopped or paused again.

*System detects obstacles and asks for the Authenticated User’s confirmation* \
While biking, the user encounters an obstacle and rides over it. The device records vibrations and speed changes via the gyroscope and accelerometer, recognizing the obstacle. The system displays a timed alert to give users the opportunity to confirm the presence of the obstacle. 
The user may either confirm or reject the detected obstacle. If the user ignores the alert, after a certain amount of time the app will silently accept and add the obstacle to the path data.

*Authenticated User adds an obstacle while biking* \
While biking, the user encounters an obstacle and rides near it without the system detecting it. The user therefore decides to notify the presence of this obstacle and opens the BBP application, presses the “Add Obstacle” button, and closes the app.
The system records the obstacle and adds it to the current path information. 

*Authenticated User stops at a red light* \
While biking, the user encounters a red light and stops. The system registers the sudden change in the bike’s velocity and pauses the recording. The user quickly opens the application on their device and sees that the time-lapse has paused. After putting away their device, the stoplight turns green, and the user resumes biking. The system recognizes that the bike has started to move and therefore resumes the time-lapse.

*Authenticated User stops biking and stops recording* \
After having reached their destination, the user opens the BBP application, which is currently recording the path that they have taken up to this point. The user presses a button to stop the recording. The application prompts the user for confirmation to terminate the recording. After the user selects the “Confirm” option, the system ends the recording and adds the bike path to the database.

#heading(level: 4, numbering: none,  outlined: false,  "Manual Bike Path Insertion")

*Manual Path Recording * \
After navigating to the page dedicated to the manual creation of bike paths, the authenticated user specifies a starting point and destination of the path. The system displays the map and allows the user to define the bike path by selecting the streets and segments composing the route.
Before saving the bike path, the user selects a status to associate with the path. The system stores the path in the user’s personal history, making it available for later review and optional publication.

#heading(level: 4, numbering: none,  outlined: false,  "Personal History Management")

*Authenticated User visits their history page* \
After the authenticated user opens the BBP application on their device, they navigate to their history page, where they can view a list of all the paths that they’ve travelled (organized by chronological order). Each path shows a limited amount of information, such as the beginning and destination of the trip, the date when the trip was taken, and the total duration.
There is also an option to select a specific path to view additional information, such as a visual representation of the path traveled, average speed, meteorological information, and the obstacles encountered along the trail, as well as a button that makes the information about that path public.

*Authenticated User deletes a bike path* \
After opening the BBP app on their device and navigating to their history page, the user notices that a bike path was added by mistake. To remove it, the user selects the path to open its dedicated page, where they can find the button that allows them to delete the bike path. The system asks for confirmation before permanently removing it from the database. After confirming the action, the system deletes it and updates the user’s history page.

*Authenticated User toggles bike path privacy state* \
After navigating to their history page, the user selects a bike path that is currently private and presses the button that allows the system to make the information about it public. Following this action, the system updates both the path status within the database and the user’s history view. The user then presses the button again after changing his mind, causing another update of the UI. The system subsequently makes the information associated with the path private.

#heading(level: 4, numbering: none,  outlined: false,  "Community Bike Path Browsing")

*Authenticated User searches for a path* \
The user navigates to the browsing page and enters a starting point and destination. The highest-quality bike paths connecting the two points are displayed to the user, along with their respective rank. The user then chooses to follow one of the paths and selects it. The user is presented with the option to start the automatic recording function or to simply follow the path without recording. Once the user selects one of the options, they will be redirected to a page displaying the map of the path, a timer, and other metrics

*Unauthenticated User searches for a path* \
The user navigates to the browsing page and enters a starting point and destination. The highest-quality bike paths connecting the two points are displayed to the user, along with their respective rank. The user then chooses to follow one of the paths, selects and is redirected to a page displaying the map of the path, a timer, and other metrics

=== Class Diagram

The diagram models the main entities of the Best Bike Path application.
A `User` represent the account of an authenticated user, that can create and own multiple `BikePath` objects.

`BikePath` represents a single bike ride made by a user. It's an abstract class containing common route information, such as date, visibility, and route structure. \
It can be specialized into two class: 
- `AutomaticBikePath`, which is recorded by the device in automatic recording mode and may include `Performance` and `Weather` object that holds corresponding data, road quality status.
- `ManualBikePath`, whose locations and road quality status is directly assigned by the user.

The road path is represented by an ordered array of `Location`s, which are used by map services to reconstruct the path and reverse geocode street names and directions.

The quality of a bike path is expressed through the `BikePathStatus` enumeration, either computed automatically or set manually.

```pintora
classDiagram
  class User {
    email: String
    password: String
    paths: [BikePath]
  }

  class BikePath {
    <<abstract>>
    date: Date
    isPublic: Bool
    locations: [Location]
    hasHighways: Bool
  }

  class AutomaticBikePath {
    obstaclesCount: Int
    performance: Performance?
    weather: Weather?

    computeStatus() -> BikePathStatus
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

  class BikePathStatus {
    <<enumeration>>
    excellent
    good
    fair
    poor
    impassable
  }

  %% Associations / multiplicities
  BikePath "*" <-- "1" User

  BikePath "1" *-- "1..*" Location
  
  BikePath <|-- AutomaticBikePath
  BikePath <|-- ManualBikePath

  AutomaticBikePath "0..1" *-- "1" Performance
  AutomaticBikePath "0..1" *-- "1" Weather
```

== Product Functions

#heading(level: 4, numbering: none,  outlined: false,  "Account Management")

*User Account Sign-up* \
The system allows users to create a personal account by providing their credentials and accepting applicable terms and privacy notices. The system shall validate input data as possible and prevent account duplication.

*User Account Sign-in* \
The system allows unauthenticated users to access their personal account by providing their credentials.

*User Account Sign-in* \
The system allows authenticated users to sign out of their personal account.
 
*User Account Deletion* \
The system allows authenticated users to delete their personal account.

#heading(level: 4, numbering: none,  outlined: false,  "Permission Management")

*Permissions Management* \
The system shall request and manage the permissions required to get the proper access level to the device services necessary for the correct functioning of the application.
Permission requests to comply with the target platform guidelines shall be issued only when the related functionality is required and shall clearly inform the user about the purpose of each requested permission.
The system shall request the following permissions:
- Location Services, including background location access, to enable ride tracking;
- Motion sensors (accelerometer and gyroscope), to support bike activity detection and obstacle identification;
- Notifications, including support for Live Activities where available, to inform the user about ride status and obstacle confirmation events.
The system shall handle cases in which permissions are denied or revoked by disabling dependent functionalities and notifying the user of the resulting limitations.


#heading(level: 4, numbering: none,  outlined: false,  "Automatic Bike Path Recording")

*Manual Control* \
The system shall allow the user to start a recording by pressing a dedicated button before biking. 
Once the ride recording starts or resumes, the system should start tracking the user path and allow the user to pause the recording by pressing a dedicated button.
Once the ride recording pauses, the system should pause to track the user path and allow the user to resume or stop the recording by pressing a dedicated button.
Once the ride recording stops, the system should stop tracking the user path and allow the user to review the collected information and set the path’s privacy status.

*Automatic Activity Detection* \
The system should be capable of recognizing if the user is biking, by using sensor data. The platform provides frameworks capable of providing the current user motion activity (`CNMotionActivityManager` on iOS, and `ActivityRecognitionClient` on Android). 
Based on the detected change in the user current activity (whether is biking or not), the system takes an action. If we are in record mode, the system should resume or pause the recording. If we are not in record mode, the system should suggest the user to start a new recording session.

*Manual Obstacle Reporting* \
The system shall allow the user to report the presence of an obstacle by pressing a dedicated button.

*Automatic Obstacle Detection* \
The system should be able to detect an obstacle by using data collected from the device's sensors, and prompt the user for confirmation.

*End Recording*
The automatic path recording is manually terminated at the user’s discretion. When the user selects “End Recording”, the system stops collecting data from the GPS and the sensors and allows the user to review the collected information, such as obstacles, street names, performance statistics, and to set the privacy status of the path. The system then saves the path information in the database and redirects the user to their personal history page.

*Bike Path search and Ranking*
the system allows users, both authenticated and unauthenticated, to search for bike paths by specifying an origin and a destination.
When multiple paths are available, the system computes a score for each path and presents the results ranked according to their quality and reliability, both as a list and on a map. After selecting a path, the user is redirected to a page displaying the route on a map, along with a timer and performance-related statistics.
If the user is authenticated, they are also given the option to record the selected path.


#heading(level: 4, numbering: none,  outlined: false,  "Personal History Management")

*Publish/Unpublish Paths*
The system allows users to publish their paths. When the user presses the “Publish” button, the system updates the privacy status of the selected path in the database, marking it as “Public”. Once the path is made public, it becomes visible and accessible to other users. 
The system also allows the user to revert previously published paths back to “Private”. The process is analogous to the previous one, triggering an update in the database to reflect the new privacy status.

*View Detailed Path Information*
The system allows users to access a detailed view of their travelled paths. After choosing this option, the system will display relevant information related to the path, such as a map of the route, the total duration, the active biking time, the date of the recording, the average speed, the top speed, the encountered obstacles, the status, and, when available, relevant meteorological information.

*Personal Trip Deletion*
The system allows users to delete their previously recorded paths from their personal history. When a path is deleted, the system removes all the data associated with it from the database, ensuring that it is no longer accessible to any user.

*Manual Trip Recording *
The system allows users to manually insert a path by selecting a starting point, destination, and intermediary stops connecting the two points. Once the user selects a quality and privacy status for the path, the system will store it in the database.



#heading(level: 4, numbering: none,  outlined: false,  "Manual Bike Path Insertion")

#heading(level: 4, numbering: none,  outlined: false,  "Personal History Management")

#heading(level: 4, numbering: none,  outlined: false,  "Community Bike Path Browsing")


== User Characteristics
Here we include anything that is relevant to clarify their needs.

== Assumptions, Dependencies And Constraints
Here we include domain assumptions

= Specific Requirements
Here we include more details on all aspects in Section 2 if they can be useful for the development team.

== External Interface Requirements

=== User Interfaces

=== Hardware Interfaces

=== Software Interfaces

=== Communication Interfaces

== Functional Requirements
Definition of use case diagrams, use cases and associated sequence/activity diagrams, and mapping on requirements

== Performance Requirements

== Design Constraints

=== Standards Compliance

=== Hardware Limitations

=== Any Other Constraint

== Software System Attributes

=== Reliability

=== Availability

=== Security

=== Maintainability

=== Portability

= Formal Analysis Using Alloy
This section should include a brief presentation of the main objectives driving the formal modeling activity, as well as a description of the model itself, what can be proved with it, and why what is proved is important given the problem at hand. To show the soundness and correctness of the model, this section can show some worlds obtained by running it, and/or the results of the checks performed on meaningful assertions.

= Effort Spent
In this section you will include information about the number of hours each
group member has worked for this document.

= References


#show: backmatter.with()
