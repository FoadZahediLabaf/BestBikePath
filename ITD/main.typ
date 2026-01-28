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

== Scope

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
*KV*: Key-Value \
*ODM*: Obstacle Detection Manager \
*PM*: Permission Manager \
*REST*: Representational State Transfer \
*SDCM/DCM*: Sensor Data Collection Manager \
*SQL*: Structured Query Language \
*SMTP*: Simple Mail Transfer Protocol \
*TLS*: Transport Layer Security \
*TSM*: Trip Statistics Manager \
*Wi-Fi*: Wireless Fidelity \

=== Abbreviations

*G*: Goal \
*WP*: World Phenomenon \
*SP*: Shared Phenomenon \
*D*: Domain Assumption \
*UC*: Use Case

== Version History
 
- Version 1: 01/02/2026

== Reference Documents

The following reference materials were used for the preparation of this document:
- The Requirement Analysis and Specification Document.
- The specification for the 2025/26 Requirement Engineering and Design Project for the Software Engineering II course.
- The WeBeep slides of the Software Engineering II course.
- Design Document sample provided in WeBeep.
- European Union, *General Data Protection Regulation (EU) 2016/679*, 2016.
- #link("https://www.iso.org/standard/75405.html")[ISO/IEC, *ISO/IEC/IEEE 24748-8:2019 Systems and software engineering -- Life cycle management*, 2019].
- #link("https://developer.apple.com/design/human-interface-guidelines")[Apple Inc., *Apple Human Interface Guidelines*, online documentation].
- #link("https://m3.material.io")[Google LLC, *Material Design Guidelines*, online documentation].
- #link("https://developer.apple.com/documentation/coremotion")[Apple Inc., *Core Motion Framework Documentation*, online documentation].
- #link("https://developer.apple.com/documentation/corelocation")[Apple Inc., *Core Location Framework Documentation*, online documentation].
- #link("https://developer.apple.com/documentation/weatherkit/")[Apple Inc., *WeatherKit Framework Documentation*, online documentation].

== Document Structure

1. *Introduction*: A description of the project that highlights its functional description.
2. *Requirement and Functions*: TBD.
3. *Development Frameworks*: TBD.
4. *Source Code*: TBD.
5. *Testing*: TBD.
6. *Installation Instructions*: TBD.
7. *Effort spent*: Includes the amount of time dedicated by each member for the realization of each section of the document.
8. *References*: Reference to documents or tools used for writing this document.

= Requirement and Functions
The requirements/functions that are actually implemented in the software (with
motivations for including them and excluding others if applicable).

= Development Frameworks
Adopted development frameworks (this section could either include simply references
to sections in the DD where we find information about your choices and/or any new
choice that you have made):
a. Adopted programming languages and their advantages and disadvantages.
b. Any middleware you have adopted and its advantages and disadvantages.
c. Any API you did not include in the DD.

= Source Code
The structure of the source code.

= Testing
Information on how you performed your testing: you can refer to what you have in the
DD and extend it as needed. Describe the procedure that you have used if not described
in the DD. At least for system test, describe the main test cases that you have considered
and their outcome.

= Installation Instructions
The installation instructions: anything that is useful for us and for the other groups to
install and run your software, any prerequisite, ...

= Effort Spent

#figure(
  table(
    columns: 4,
    table.header([], [*Foad Zahedi Labaf*], [*Lorenzo Fiamingo*], [*Alexander Gabriel Fox*]),
    [*Section 1*], [2], [2], [6],
    [*Section 2*], [19], [16], [15],
    [*Section 3*], [1], [14], [3],
    [*Section 4*], [1], [2], [3],
    [*Section 5*], [6], [5], [5],
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
