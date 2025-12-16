#import "@local/polimi:1.0.0": *
#import "@preview/pintorita:0.1.4"

#show raw.where(lang: "pintora"): it => pintorita.render(it.text)

#show: polimi-thesis.with(
  title: "Best Bike Paths",
  subtitle: "Requirements Analysis and Specification Document",
  author: "Foad Zahedi Labaf\nLorenzo Fiamingo\nAlexander Fox",
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

== Purpose

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
#lorem(30)

=== World Phenomena
WP1: The user decides to take a bike trip
\
WP2: Weather conditions change over time
\
WP3: Accelerometer and gyroscope collects device motion data.GPS collects device location data.
\
WP4: GPS collects device location data.
\
WP5: Street infrastructure changes over time (new streets are built, existing streets are upgraded, downgraded, or decommissioned).

\
WP6:Path conditions change over time due to natural degradation, weather, or maintenance.

\
WP7:The user starts and stops biking.

\
WP8:The user velocity changes.

\
WP9:The user encounters an obstacle.

\
WP10:Stoplight changes color.
\
WP11:The user's device’s internet connection changes over time.






=== Shared Phenomena
#lorem(30)
SP1: The user creates an account. (World controlled)
\
SP2:
\
SP3:
\
SP4:
\
SP5:
\
SP6:
\
SP7:
\
SP8:
\
SP9:
\
SP10:
\
SP11:
\
SP12:
\
SP13:
\
SP14:
\
SP15:
\
SP16:
\
SP17:
\
SP18:
SP19:
SP20:
SP21:
\
SP22:
\
SP23:
\
SP24:
\
SP25:
\
SP26:


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
#lorem(30)

== Reference Documents
#lorem(30)

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
