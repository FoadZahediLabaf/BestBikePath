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
G1: Registered users want to automatically record bike path data while they are biking.
\
G2: Registered users want to manually insert bike paths by specifying streets and status.
\
G3: Registered users want to approve or reject obstacles detected by the system.
\
G4: Registered users want to manually record an obstacle while they are biking.
\
G5: Registered users want to retrieve all the collected data of their personal bike paths.
\
G6: Registered users want to be able to share their recorded bike paths with the community.
\
G7: Registered users want to enrich the data of their bike paths with relevant statistics (average speed, total distance, duration) and meteorological information, if available.
\
G8: After specifying the start and destination, all the users want the ability to browse the paths (with the same starting point and destination) published by other registered users and ranked based on quality.
\
G9: The users want the paths to be ranked based on compatible speed limits, average path status, and data freshness.

== Scope
The purpose of this application is to provide relevant and accurate information about bike paths. In order to do this, BBP offers a wide array of functionalities, such as the ability to collect information about the followed paths, either by allowing users to manually insert the data or through an automated recording function that interacts with the GPS and sensors of the device on which the app resides. The collected information will be securely stored in a remote database, and can optionally be made publicly available.
Users will be able to access and manage their stored information through the app.
This data can then be used by the BBP app to further develop its recommendation system, which will suggest bike paths based on the evaluations provided by other users or computed by the system.
This application is primarily intended for registered users who, once authenticated within the system, will be able to record or manually insert new bike paths to track their cycling experiences. However, the BBP app will also allow unregistered users to partially access its functionalities, mainly the ability to browse publicly available bike paths.
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

*World Controlled*
\
SP1: The user creates an account.
\
SP2: The user signs in and out of their account.
\
SP3: The user deletes their account.
\
SP4: The user starts, stops and pauses the recording of the bike path.
\
SP5: The user selects or inserts street segments of a bike path.
\
SP6: The user sets the status of the path.
\
SP7: The user sets the privacy of the path.
\
SP8: The user confirms or rejects obstacles by the system.
\
SP9: The user manually adds an obstacle.
\
SP10: The user deletes one of their bike paths.
\
SP11: The user selects a starting point and a destination when browsing community bike paths.
\
SP12: The users choose which path in the proposed routes should be followed.
\
SP13: GPS provides the location samples.
\
SP14: Accelerometer and gyroscope share motion data with the system.
\
SP15: External services provide meteorological information.

*Machine Controlled*
\
SP16: The system records GPS and sensor data during a user’s trip.
\
SP17: The system displays the travelled path.
\
SP18: The system displays the selected path to follow. 
\
SP19: The system displays a notification to the user after detecting a possible obstacle.
\
SP20: The system displays the current travel time and additional statistics about the trip while recording
\
SP21: The system pauses the recording when the user slows down. 
\
SP22: The system collects weather data from the weather API when recording stops.
\
SP23: The system displays  the user’s personal bike paths in their  history. 
\
SP24: The system displays ranked community bike paths between a chosen origin and destination.
\
SP25: The system shows detailed information for any selected path.
\
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

*Bike Path*: A bike path is a collection of information associated with a specific route. This information may refer to a single user trip and, in that case, includes performance-related data describing the user’s ride, as well as qualitative information about the route itself.  
The term bike path is also used to indicate the aggregated information derived from multiple user-specific bike paths that follow the same route. This information will therefore exclude individual performance data and primarily consists of aggregated data describing the overall quality of the route.

*Bike Trip*: A bike trip indicates a cycling session that may optionally be recorded by the application at the cyclist’s discretion. During the trip, data is collected from the device’s GPS and motion sensors and may be enriched with meteorological information.

*Meteorological Data*: Meteorological data refers to information describing the atmospheric conditions during a bike trip, such as weather conditions, temperature, and wind speed.

*Motion Sensors*: This term refers to the user’s device’s hardware components that allow for the collection of performance-related and qualitative data about the bike trip. 
Specifically, the gyroscope of the device is responsible for measuring angular velocity and is used to identify obstacles along the path.
The accelerometer is responsible for measuring the acceleration of the user during the trip and contributes both to obstacle detection and to the computation of the user’s velocity.

*Obstacle*: An obstacle is a physical irregularity located along a bike path that may negatively affect the safety of cyclists.
Obstacles can be automatically detected through the device’s motion sensors or manually reported by the user, and are used by the system to assess and compute the overall quality of the path.

*History Page*: A user’s history page is a section of the user’s profile that displays a list of previously recorded bike trips and allows the user to access detailed information about each trip.


=== Acronyms

*API*: Application Programming Interface \
*BBP*: Best Bike Paths \
*CPU*: Central Processing Unit \
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
*TLS*: Transport Layer Security \
*Wi-Fi*: Wireless Fidelity \

=== Abbreviations

*G*: Goal \
*WP*: World Phenomenon \
*SP*: Shared Phenomenon \
*D*: Domain Assumption \
*UC*: Use Case

== Version History
 - Version 1.0: 23/12/2025
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
#lorem(100)

= Overall Description
#lorem(30)

== Product Perspective
Here we include scenarios and further details on the shared phenomena and a domain model (class diagrams and state diagrams)

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
    performance: Performance?
    weather: Weather?
    obstaclesCount: Int

    computeStatus() -> BikePathStatus
  }

  class ManualBikePath {
    status: BikePathStatus
  }

  class Performance {
    distance: Double
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
Here we include the most important requirements

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
