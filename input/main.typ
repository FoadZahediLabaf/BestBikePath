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
#lorem(30)

=== Goals
#lorem(30)
```pintora
activityDiagram
  start
  :Action 1;
  -> Hey there;
  :Action 2;
  end
```

== Scope
#lorem(30)

=== World Phenomena
#lorem(30)

=== Shared Phenomena
#lorem(30)

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
