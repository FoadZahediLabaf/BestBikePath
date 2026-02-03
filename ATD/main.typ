#import "@local/polimi:1.0.1": *
#import "@local/plantuml:0.1.0"

#show raw.where(lang: "plantuml"): it => image(plantuml.path(it.text))


#show: polimi-thesis.with(
  title: "Best Bike Paths",
  subtitle: "Acceptance Testing Document",
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
//#list-of-figures
#list-of-tables

#show: mainmatter.with()

= Introduction

== Purpose
This document describes the... \
The purpose of this document is to...

== Scope
This document focuses exclusively on ... \
The testing activities described here concern the ... \


== Definitions, Acronyms, Abbreviations

=== Definitions
*User*: Term used to indicate both authenticated and unauthenticated individuals who interact with the application.

*Authenticated User*: User who is authenticated in their BBP account. An authenticated user has full access to the functionalities offered by the application.

*Unauthenticated User*: Users who do not have a BBP account, or who have an account but aren't currently authenticated within the system. These users have limited access to the application's functionalities.

*Bike Path*: A bike path is a collection of information associated with a specific route. This information may refer to a single user trip and, in that case, includes performance-related data describing the user’s ride, as well as qualitative information about the route itself.  
The term bike path is also used to indicate the aggregated information derived from multiple user-specific bike paths that follow the same route. This information will therefore exclude individual performance data and primarily consists of aggregated data describing the overall quality of the route.

*Bike Trip*: A bike trip indicates a cycling session that may optionally be recorded by the application at the cyclist’s discretion. During the trip, data is collected from the device’s GPS and motion sensors and may be enriched with meteorological information.

*Motion Sensors*: This term refers to the user’s device’s hardware components that allow for the collection of performance-related and qualitative data about the bike trip. 
Specifically, the gyroscope of the device is responsible for measuring angular velocity and is used to identify obstacles along the path.
The accelerometer is responsible for measuring the acceleration of the user during the trip and contributes both to obstacle detection and to the computation of the user’s velocity.

*SMTP Server*: An SMTP server, or email service provider, is an external system responsible for sending transactional emails on behalf of the application.

*Status*: Term used to indicate the overall assessment of a path's quality, which can be either manually specified by the user or computed by the system based on the frequency of obstacles along the path.


=== Acronyms

*API*: Application Programming Interface \
*BBP*: Best Bike Paths \
*GPS*: Global Positioning System \
*HTTPS*: HyperText Transfer Protocol Secure \
*JSON*: JavaScript Object Notation\
*MVVM*: Model-View-ViewModel \
*NPM*: Node Package Manager \
*REST*: Representational State Transfer \
*SPM*: Swift Package Manager \
*SMTP*: Simple Mail Transfer Protocol \
*Wi-Fi*: Wireless Fidelity \

=== Abbreviations

*R*: Requirement\
*UT*: Unit Test\
*IT*: Integration Test\
*ST*: System Test\

== Version History
 
- Version 1: 08/02/2026

== Reference Documents

The following reference materials were used for the preparation of this document:
- The Requirement Analysis and Specification Document.
- The Design Document
- The specification for the 2025/26 Implementation & Testing for the Software Engineering II course.
- The WeBeep slides of the Software Engineering II course.
- #link("https://developer.apple.com/design/human-interface-guidelines")[Apple Inc., *Apple Human Interface Guidelines*, online documentation].
- #link("https://m3.material.io")[Google LLC, *Material Design Guidelines*, online documentation].
- #link("https://developer.apple.com/documentation/coremotion")[Apple Inc., *Core Motion Framework Documentation*, online documentation].
- #link("https://developer.apple.com/documentation/corelocation")[Apple Inc., *Core Location Framework Documentation*, online documentation].
- #link("https://developer.apple.com/documentation/weatherkit/")[Apple Inc., *WeatherKit Framework Documentation*, online documentation].

== Document Structure

1. *Introduction*: A brief overview of the contents of the document and its purpose.
2. *Project Identification*: This section identifies the software project under analysis.
3. *Installation Setup*: It describes the steps taken to install the prototype.
4. *Acceptance Testing*: The executed test cases derived from the RASD requirements and actual implemented features.
5. *Quality Assessment*: An evaluative section focusing on the overall quality of the project.
6. *Effort spent*: Includes the amount of time dedicated by each member for the realization of each section of the document.
7. *References*: Reference to documents or tools used for writing this document.


= Project Identification
The identification of the project you have analyzed (names of authors, link to the repository,
main reference documents you have considered).
== Authors


= Installation Setup
What you did to install the prototype as well as any problem you have
faced in this phase, any incoherence you may have found when following the documentation
accompanying the software.

= Acceptance Testing
The acceptance test cases you have applied and the corresponding outcome: you can extract
test cases by analyzing the RASD the other team has developed, the list of features that the
team has actually developed, as well as any other case that you, as a user of the application,
think is appropriate (please provide motivation for your choice).
== Acceptance Test Cases


= Quality Assessment
Any additional point you want to raise on the quality of documentation and code.

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
- *GitHub* was used for version control and to automate diagram generation.
- *Google Docs* was used for collaborative writing.
- *Xcode* and *SwiftUI* were used to create UI mockups.
- *ChatGPT* and *Grammarly* were used to refine grammar, assist with code development, and automate error checking.

#show: backmatter.with()
