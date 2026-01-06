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
When engaging in any sport or physical activity, people quickly realize how important it is to log their performance, which helps maintain motivation and enables steady progress over time. \
It is also important to share this knowledge with the community, allowing less knowledgeable users to make safer and more informed decisions. \

The primary goal of the Best Bike Paths application is to provide its users with an intuitive software application that addresses both these needs. Specifically, it helps cyclists track their own routes while also discovering the safest and most reliable paths previously traveled by fellow users. \

== Scope
The BBP application allows its users to interact with its constantly evolving database of bike paths recorded by others. After specifying a starting point and destination, the system will provide the user with a visual representation of the highest-quality bike paths connecting the two points. The quality of a bike path depends on a variety of parameters, including the frequency of encountered obstacles and the freshness of the collected data. \  

Authenticated users will be able to access the additional features, such as the automatic recording function, which collects data from the GPS, gyroscope, and accelerometer of the device while the user is travelling along the path and stores the data once the recording ends. The collected information will be processed by the system, allowing the user to view performance-related data and additional qualitative information about the travelled path after navigating to the corresponding section of the application. \
Additionally, the users will also be allowed to manually insert bike paths by specifying the necessary information, such as street names, obstacles, and status. 

To maximize the performance of this application, a three-tiered architecture will be adopted, assigning to each tier the implementation of the presentation, application, and data layers, respectively. To optimize server load and response time, a microservice approach will be used for the back-end of the application. \
Additional details regarding the application functions and architectural decisions will be provided in the following section. \

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
== Overview: High-Level Components
As stated in the previous section, the system will follow a three-tiered architecture, with each tier implementing a specific layer of the application: presentation, application, and data.
The first tier implements the user interface and collects data from the device’s sensors.  \

The second tier is represented by the back-end of the application, and will implement the core functions that are necessary to meet the goals that were previously outlined in the Requirements and Specifications Document (RASD).  \
The application tier will adopt a microservice architecture, dividing responsibilities across separate services, each providing a specific function to the client. Compared to a monolithic approach, this architecture improves scalability while also reducing deployment complexity. This choice will also help minimize tight coupling between modules, build a fault-tolerant system, and allow its components to degrade gracefully. \
The microservice approach helps mitigate bottlenecks, particularly for computationally intensive operations such as the Path Recommendation service. \

The third tier implements the data layer, primarily responsible for storing bike path information as well as user profiles and account data. To ensure scalability and fault tolerance, both the second and third tiers will be replicated. \
Communication with external services occurs via REST APIs, while client-server interactions are managed through an API gateway, which routes requests to the appropriate microservices. To prevent bottlenecks, load balancers distribute HTTP/S requests across the replicated servers.
Security is enforced through an application proxy and a firewall to enforce both application-level and network-level security, respectively. \

#figure(
  image("diagrams/architecture.drawio.png"),
  caption: [Architecture Diagram]
)

#pagebreak()
== Component view

#heading(level: 4, numbering: none,  outlined: false,  "Frontend Components")
*Mobile App* \
The mobile application provides functionalities such as the ability to follow bike paths on a map and to automatically record said path by interacting with the device’s GPS, gyroscope, and accelerometer. The application must maintain a certain amount of free storage to allow the collection of path data while the recording is ongoing.
The app interacts with the system’s back-end through HTTP/S requests, which are routed directly to the API Gateway and then forwarded to the corresponding microservices.

*Sensor Data Collection Manager* \
The Sensor Data Collection Manager is a client-side component of the mobile BBP application and is responsible for the retrieval of raw sensor data from the GPS, gyroscope, and accelerometer of the user’s device. Data collection begins when the user starts an automatic recording session and terminates when the user ends the recording. During the trip, data is periodically sampled from the device’s modules and forwarded to the Obstacle Detection Manager. During the recording, data collection is occasionally paused and resumed when the system detects that the user has temporarily stopped or resumed cycling.

*Obstacle Detection Manager* \
The Obstacle Detection Manager is a client-side component of the mobile application and is responsible for detecting obstacles during the recorded trip. Detection is performed by analyzing the preprocessed data supplied by the Sensor Data Collection Manager.
When an obstacle is detected, the Obstacle Detection Manager generates a corresponding event to notify the user through the UI to prompt them for confirmation or rejection. 

*Trip Statistics Manager* \
The Trip Statistics Manager is a component residing on the mobile app and is responsible for computing real-time statistics about the current trip.
This module retrieves data from the Sensor Data Collection Manager and calculates relevant performance statistics, including average speed, top speed, current speed, and total distance traveled.
When the application is opened during the trip recording, the app should display the statistics computed by this module.

*Permission Manager* \
The Permission Manager is a client-side component responsible for managing access to device sensors, including GPS, gyroscope, and accelerometer. It verifies whether the necessary permissions have been granted and prompts the user if any permissions are missing.
This component notifies dependent modules, such as the Sensor Data Collection Manager, Obstacle Detection Manager, and Trip Statistics Manager, about the current permission state.

*Local Storage* \
The user’s device must provide a sufficient amount of available storage to temporarily retain path data during the automatic recording of a bike trip. Upon completion of the recording and successful persistence of the data in the database, the locally stored data is permanently deleted.

*GPS* \
The GPS is a hardware component of the user's device responsible for collecting data regarding the positioning of the user. 
The application will obtain this data by communicating with the corresponding Location API according to the OS (iOS or Android). The Sensor Data Collection Manager will be responsible for retrieving this data from the GPS.

*Gyroscope* \
The gyroscope is a built-in component of the mobile device on which the app resides, and its purpose is to periodically measure its angular velocity. This data is provided to the Sensor Data Collection Manager and will then be used to detect obstacles based on the sudden fluctuations that will be caused by the obstacle.

*Accelerometer* \
The accelerometer is another hardware component of the user's device and is responsible for providing measurements of the user's acceleration along the three axes in order to determine the speed at which the user is moving and to detect obstacles. The raw acceleration data is sent to the Sensor Data Collection Manager.

#heading(level: 4, numbering: none,  outlined: false,  "Backend Components")

*User Management Service* \
The User Management Service is a microservice primarily responsible for handling user account registration and authentication.
During registration, users are required to provide an account name, an email address, and a password. Email verification is performed through an external email service to confirm the validity of the provided address. 
Once authenticated,  the service issues a JSON Web Token, which will be used by the client to authenticate requests.

*Personal Paths Service* \
The Personal Paths Service is a back-end microservice responsible for managing access to user-specific bike path data stored in the system’s database. It enforces authorization policies to ensure that users can only retrieve their own path information and provides endpoints for querying personal paths data and statistics, and supports operations such as sorting and pagination.

*Path Recommendation Service* \
This microservice is responsible for computing aggregated quality scores for community bike paths and for providing a ranked list of the highest-quality paths connecting the two points specified by a user.
The overall quality of a community path depends on the quality scores and recency of the single path instances that are recorded in the database. The visual representation of the recommended paths, including their ranking, is handled entirely by the UI.

*Path Recording Service* \
The Path Recording Service receives new paths from the users, whether automatically recorded or manually inserted, and is responsible for saving them in the database.
When automatically recorded, the path data will contain relevant performance statistics and weather data, computed by the client-side if available, which will also be stored in the database. 
If the path was manually inserted, the path data will contain the quality status and the coordinates of the path, geocoded from the street names specified by the user using the Maps API.

*Weather API* \
The weather API is an external service that will provide additional meteorological data to enrich the trip information before saving it to the database

*Maps API* \
The Maps API will be used by the front-end of the application to give a visual representation of the bike paths and to geocode and reverse geocode location data, enabling the mapping between geographic coordinates and the street segments that constitute a given path.

*SMTP Server* \
The SMTP Server is an external service that will be used by the system to assist the authentication process via e-mail during the creation of a new user account.

*DBMS* \
The DBMS will manage all the user-associated data, including account information as well as path-related data, such as coordinates, obstacles, performance metrics, and other relevant data.

*KV Store* \
The KV store is used to temporarily persist key–value pairs required for short-lived operations, like generating OTP code for the email verification.

== Deployment view
The goal of the deployment view is to describe the physical realization of the system’s logical components and the execution environments in which they operate. This view also highlights the physical nodes of the system, the communication links between them, and the protocols used for interaction.
Furthermore, it defines the system’s physical boundaries with respect to external services and illustrates the use of replication mechanisms, explaining how they contribute to scalability, availability, and fault tolerance.

*User Device* \
The user’s device is a mobile device on which the front-end application is installed. The application represents the primary interface between the user and the system’s back-end services and is responsible for managing user interactions with the functionalities offered by the BBP platform. The communication between the mobile application and the back-end services occurs exclusively over HTTPS, ensuring data protection through transport-layer encryption. The user’s device will therefore require a stable internet connection for browsing, storing path data, and performing account-related operations.

*Firewall* \
All HTTPS requests attempting to access the BBP infrastructure are first processed by a network firewall. The firewall inspects packet headers, including IP addresses, ports, and communication protocols, to block suspicious connections and mitigate attacks such as IP spoofing and certain types of DoS.

*Application Proxy* \
An application proxy, situated immediately after the firewall, is primarily responsible for applying application-level filtering techniques to incoming HTTPS traffic. By performing deep inspection of requests and responses (after decryption), it can detect and block malicious content, such as SQL injections or malware, and mitigate application-layer DoS attacks through rate-limiting strategies.

*API Gateway* \
The API Gateway is another back-end component that is responsible for receiving HTTP requests and routing them to the corresponding microservices.
The API Gateway can also perform request composition, enabling the construction of HTTP requests that require interaction with multiple microservices. 
To maximize performance and maintain separation of concerns, authentication logic is handled by the User Management Service, while the gateway will deal with token validation.

*Load Balancer* \
Load balancers are software components that specialize in distributing network traffic to the back-end servers, thereby avoiding the formation of bottlenecks and improving scalability of the architecture. Each load balancer receives HTTPS requests from the API Gateway and manages the traffic directed towards a certain cluster of servers by implementing a least-connections approach.

*Application Server* \
The application servers host the BBP back-end microservices and are replicated to ensure high availability, scalability, and performance. Each microservice runs on multiple servers, which connect to load balancers distributing traffic between them. Among all the microservices, the Path Recommendation Manager requires particularly high replication and scaling capacity, as it is the most computationally intensive service and serves both authenticated and unauthenticated users. Communication between servers occurs over HTTPS.

*DBMS Server* \
The DBMS server will interact exclusively with the system’s backend application servers and will not communicate with external entities. Replication will be implemented to enhance scalability and fault tolerance, though it introduces additional complexity in database management and may slightly reduce performance due to the mechanisms required to maintain consistency across database replicas.

*KV Server* \
The KV Server is responsible for managing the KV store and will also be replicated to ensure scalability and fault tolerance using the same techniques employed for the other database servers.

*External Servers* \
The application will also interact with various services hosted externally by third-party providers, such as the Maps Service, the SMTP Server, and the Weather Service.

== Runtime view
This section describes the dynamic behavior of the Best Bike Paths (BBP) system by illustrating the flow of messages exchanged among architectural components for the most relevant use cases defined in the RASD. \
The runtime view focuses on the main success scenarios and highlights how the system components collaborate to realize the required functionalities. \
For clarity and consistency with the Software Architecture lectures, the following aspects are intentionally omitted: \
- authorization and access-control checks;
- error handling and exceptional flows;
- caching and optimization mechanisms.
All sequence diagrams represent only the main execution path. \
The system frontend is represented exclusively by a Mobile Application (iOS/Android), as specified in the RASD. \
Each runtime scenario corresponds directly to a use case defined in the RASD. Some use cases are included even when they do not introduce new backend components because they involve critical runtime interactions with device sensors, which are architecturally relevant for the system. \

#pagebreak() 
*UC1 Account Creation* \
This sequence diagram shows the flow of messages for the Account Creation use case . \
The user initiates authentication through the mobile application by entering an email address. The request is forwarded through the Application Proxy and the API Gateway to the User Management Service, which checks whether the email is already registered in the DBMS. \
Since the email provided is not registered, the User Management Service generates a verification code, stores it temporarily in the KV Storage, and sends it to the user via the SMTP Server. After the user enters the received code and provides the registration data, the service validates the code, creates the user in the DBMS, and returns a JWT the user can use to authenticate their subsequent requests. \

#let accountCreationSequenceDiagram = ```plantuml
actor User
boundary "Mobile App" as App
control "Application Proxy" as Proxy
control "API Gateway" as GW
control "User Management Service" as UMS
entity "DBMS" as DBMS
entity "KV Storage" as KV
entity "SMTP Server" as SMTP
User -> App : Tap "Sign In"
User -> App : Enter email
App -> Proxy : checkEmail(email)
Proxy -> GW
GW -> UMS : checkEmail(email)
UMS -> DBMS : userExists(email)?
DBMS --> UMS : exists
UMS --> App : emailStatus
App -> Proxy : requestVerificationCode(email)
Proxy -> GW
GW -> UMS : requestVerificationCode(email)
UMS -> KV : storeOTP(email, code)
UMS -> SMTP : sendVerificationCode(email, code)
SMTP --> UMS : sent
User -> App : Insert verification code
User -> App : Enter registration data
App -> Proxy : createAccount(name,email,password,code)
Proxy -> GW
GW -> UMS : createAccount(...)
UMS -> KV : validateOTP(email, code)
UMS -> DBMS : createUser(...)
DBMS --> UMS : OK
UMS --> App : JWT token
```

#figure(
  accountCreationSequenceDiagram,
  kind: image,
  caption: [Account Creation Sequence Diagram]
)


#pagebreak() 
*UC2 User Sign In* \
This sequence diagram shows the flow of messages for the User Sign In use case. \
The user initiates authentication through the mobile application by entering an email address. The request is forwarded through the Application Proxy and the API Gateway to the User Management Service, which checks whether the email is already registered in the DBMS. \
Since the email provided is registered, the user provides credentials and the service verifies them. If valid, the service issues a JSON Web Token (JWT), which is returned to the mobile application and used to authenticate subsequent requests. \

#let userSignInSequenceDiagram = ```plantuml
actor User
boundary "Mobile App" as App
control "Application Proxy" as Proxy
control "API Gateway" as GW
control "User Management Service" as UMS
entity "DBMS" as DBMS
User -> App : Tap "Sign In"
User -> App : Enter email
App -> Proxy : checkEmail(email)
Proxy -> GW
GW -> UMS : checkEmail(email)
UMS -> DBMS : userExists(email)?
DBMS --> UMS : exists
UMS --> App : emailStatus
User -> App : Enter password
App -> Proxy : signIn(email,password)
Proxy -> GW
GW -> UMS : signIn(email,password)
UMS -> DBMS : verifyCredentials(email,password)
DBMS --> UMS : valid
UMS --> App : JWT token
```

#figure(
  userSignInSequenceDiagram,
  kind: image,
  caption: [Account Creation Sequence Diagram]
)

#pagebreak()
*UC3 Account Deletion* \
This sequence diagram shows the flow of messages for the Account Deletion use case. \
The authenticated user permanently deletes their account. After confirmation, the request is forwarded to the User Management Service, which removes the user account and all related data from the DBMS. The user is then returned to an unauthenticated state. \

#let AccountDeletionSequenceDiagram = ```plantuml
actor "Authenticated User" as User
boundary "Mobile App" as App
control "Application Proxy" as Proxy
control "API Gateway" as GW
control "User Management Service" as UMS
entity "DBMS" as DBMS
User -> App : Request account deletion
App -> User : Show confirmation
User -> App : Confirm
App -> Proxy : deleteAccount(userId)
Proxy -> GW
GW -> UMS : deleteAccount(userId)
UMS -> DBMS : removeUserData(userId)
DBMS --> UMS : OK
UMS --> App : deletion confirmed
```

#figure(
AccountDeletionSequenceDiagram,
  kind: image,
  caption: [Account Deletion Sequence Diagram]
)

#pagebreak()
*UC4 User Sign Out* \
This sequence diagram shows the flow of messages for the Sign Out use case. \
The authenticated user signs out by removing the locally stored authentication token. No interaction with Backend services is required. \

#let userSignOutSequenceDiagram = ```plantuml
actor "Authenticated User" as User
boundary "Mobile App" as App
User -> App : Tap logout
App -> App : clearLocalToken()
App -> User : Show unauthenticated state
```

#figure(
userSignOutSequenceDiagram,
  kind: image,
  caption: [Sign Out Sequence Diagram]
)

#pagebreak()
*[UC2] Start Automatic Recording* \ 
This sequence diagram shows the flow of messages for the Start Automatic Recording use case. \
An authenticated user starts a new recording session through the mobile application. The Permission Manager verifies that access to GPS, gyroscope, and accelerometer has been granted. Once permissions are available, the Sensor Data Collection Manager starts the acquisition of raw sensor data. \
During the recording, the Sensor Data Collection Manager samples data periodically and provides it to the Trip Statistics Manager, which computes real-time statistics (e.g., speed and distance) shown in the user interface. The same collected stream is also provided to the Obstacle Detection Manager to support obstacle detection during the trip. Collected trip data is stored locally until the session ends. \
This use case causes the recording state to transition from Stopped to Recording. \

#let StartAutomaticRecordingSequenceDiagram = ```plantuml
title UC2 - Start Automatic Recording
actor "Authenticated User" as User
boundary "Mobile App" as App
control "Permission Manager" as PM
control "Sensor Data Collection Manager" as SDCM
control "Trip Statistics Manager" as TSM
control "Obstacle Detection Manager" as ODM
entity "Local Storage" as LS
entity "GPS" as GPS
entity "Gyroscope" as GYR
entity "Accelerometer" as ACC
User -> App : Tap "Start Recording"
App -> PM : checkPermissions()
PM --> App : granted
App -> SDCM : startCollection()
SDCM -> GPS : startUpdates()
SDCM -> GYR : startUpdates()
SDCM -> ACC : startUpdates()
loop While recording
  GPS --> SDCM : location sample
  GYR --> SDCM : angular velocity sample
  ACC --> SDCM : acceleration sample
  SDCM -> LS : appendTripData(sample)
  SDCM -> TSM : provideData(sample)
  SDCM -> ODM : provideData(sample)
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
During an active recording session, the mobile application monitors the ongoing trip to determine whether the user is currently biking. This monitoring is performed by the Trip Statistics Manager, which evaluates the stream of sensor data provided by the Sensor Data Collection Manager. \
When a stop is detected, the Trip Statistics Manager triggers the automatic pause of the session by requesting the Sensor Data Collection Manager to suspend acquisition and by pausing the timer shown in the UI. \ When activity is detected again, the Trip Statistics Manager triggers the resumption of acquisition and the UI timer. \
This use case causes repeated transitions between Recording and Paused states until the user explicitly stops the session.\

#let AutomaticPauseResumeSequenceDiagram = ```plantuml
title UC3 - Automatic Pause and Resume
boundary "Mobile App" as App
control "Trip Statistics Manager" as TSM
control "Sensor Data Collection Manager" as SDCM
loop While recording session is active
  SDCM -> TSM : provideData(stream)
  TSM -> TSM : evaluateActivity()
  alt stop detected
    TSM -> SDCM : pauseCollection()
    TSM -> App : pauseTimerAndUI()
  else resume detected
    TSM -> SDCM : resumeCollection()
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
During an active recording session, the authenticated user may explicitly pause or resume the recording through the UI. When the user pauses, the mobile application requests the Sensor Data Collection Manager to suspend acquisition and updates the UI accordingly. When the user resumes, the application requests acquisition to restart and updates the UI timer. \
This use case causes explicit transitions between Recording and Paused states. \

#let ManualPauseResumeSequenceDiagram = ```plantuml
title UC4 - Manual Pause and Resume
actor "Authenticated User" as User
boundary "Mobile App" as App
control "Sensor Data Collection Manager" as SDCM
alt User pauses recording
  User -> App : Tap "Pause"
  App -> SDCM : pauseCollection()
  App -> User : show paused state
else User resumes recording
  User -> App : Tap "Resume"
  App -> SDCM : resumeCollection()
  App -> User : show recording state
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
The user stops the recording session and confirms the action. The mobile application requests the Sensor Data Collection Manager to terminate sensor acquisition and finalizes the trip package stored in local storage. \
The trip package is then submitted to the backend through the Application Proxy and the API Gateway. The Path Recording Service stores the trip in the DBMS. If needed, the service may enrich the stored trip with meteorological information obtained through the Weather API. The mobile application is notified of success and the path becomes available in the user’s personal history \
This use case causes the recording state to transition from Recording to Stopped. \

#let StopRecordingSaveTripSequenceDiagram = ```plantuml
title UC5 - Stop Recording and Save Trip
actor "Authenticated User" as User
boundary "Mobile App" as App
control "Sensor Data Collection Manager" as SDCM
entity "Local Storage" as LS
control "Application Proxy" as Proxy
control "API Gateway" as GW
control "Path Recording Service" as PRS
entity "DBMS" as DBMS
entity "Weather API" as WAPI
User -> App : Tap "Stop Recording"
App -> User : show confirmation dialog
User -> App : confirm
App -> SDCM : stopCollection()
SDCM --> App : stopped
App -> LS : finalizeTripPackage()
App -> Proxy : submitRecordedTrip(tripPackage)
Proxy -> GW
GW -> PRS : submitRecordedTrip(tripPackage)
opt meteorological enrichment if needed
  PRS -> WAPI : getWeather(tripContext)
  WAPI --> PRS : weather data
end
PRS -> DBMS : storeTrip(userId, tripData)
DBMS --> PRS : OK
PRS --> App : confirmation
```

#figure(
  StopRecordingSaveTripSequenceDiagram,
  kind: image,
  caption: [ Stop Recording and Save Trip Sequence Diagram]
)
#pagebreak()
*[UC6] Automatic Obstacle Detection* \
This sequence diagram shows the flow of messages for the Automatic Obstacle Detection use case. \
During an active recording session, the Sensor Data Collection Manager samples motion sensor data and forwards it to the Obstacle Detection Manager. The Obstacle Detection Manager analyzes the received sensor stream to detect potential obstacles. \
When an obstacle is detected, the user is notified through the UI and can confirm or reject it. If the user confirms or does not respond within a timeout, the obstacle is associated with the current trip and stored locally together with the trip data; otherwise it is discarded. The recording continues in any case. \

#let AutomaticObstacleDetectionSequenceDiagram = ```plantuml
title UC6 - Automatic Obstacle Detection
actor "Authenticated User" as User
boundary "Mobile App" as App
control "Sensor Data Collection Manager" as SDCM
control "Obstacle Detection Manager" as ODM
entity "Local Storage" as LS
loop While recording session is active
  SDCM -> ODM : provideData(stream)
  ODM -> ODM : detectObstacle()
  alt obstacle detected
    ODM -> App : showConfirmationAlert()
    alt confirmed or timeout
      ODM -> LS : storeObstacle(currentTrip, obstacle)
      ODM -> App : updateObstacleCountUI()
    else rejected
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
During an active recording session, the authenticated user manually reports an obstacle through the mobile application. The obstacle is associated with the current trip and stored locally together with the trip data. \
This use case does not interrupt the recording session. \

#let ManualObstacleInsertionSequenceDiagram = ```plantuml
title UC7 - Manual Obstacle Insertion
actor "Authenticated User" as User
boundary "Mobile App" as App
control "Obstacle Detection Manager" as ODM
entity "Local Storage" as LS
User -> App : Add obstacle
App -> ODM : registerManualObstacle()
ODM -> LS : storeObstacle(currentTrip, obstacle)
ODM --> App : update UI
```

#figure(
ManualObstacleInsertionSequenceDiagram,
  kind: image,
  caption: [Manual Obstacle Insertion Sequence Diagram]
)
#pagebreak()
*[UC8] Manual Path Insertion* \
This sequence diagram shows the flow of messages for the Manual Path Insertion use case. \
An authenticated user manually creates a bike path by specifying a starting point, a destination, and optional intermediate locations through the mobile application. For each inserted location, the application interacts with the Maps API to translate street names into geographic coordinates and to visualize the path on the map. \
Once the path definition is completed, the user selects the path status and privacy level. The mobile application then submits the manually created path to the backend through the Application Proxy and the API Gateway. The Path Recording Service stores the path data in the DBMS, making it available in the user’s personal history. \
This use case does not involve sensor data acquisition and does not affect the recording state. \

#let ManualPathInsertionSequenceDiagram = ```plantuml
title UC8 - Manual Path Insertion
actor "Authenticated User" as User
boundary "Mobile App" as App
entity "Maps API" as MAPI
control "Application Proxy" as Proxy
control "API Gateway" as GW
control "Path Recording Service" as PRS
entity "DBMS" as DBMS
User -> App : Open manual path creation
loop For each location
  User -> App : Insert street/location
  App -> MAPI : geocode(address)
  MAPI --> App : coordinates
  App -> App : update map
end
User -> App : Select status and privacy
User -> App : Save path
App -> Proxy : submitManualPath(pathData)
Proxy -> GW
GW -> PRS : submitManualPath(pathData)
PRS -> DBMS : storePath(pathData)
DBMS --> PRS : OK
PRS --> App : confirmation
```

#figure(
ManualPathInsertionSequenceDiagram,
  kind: image,
  caption: [Manual Path Insertion Sequence Diagram]
)
#pagebreak()
*[UC9] Show Personal History* \
This sequence diagram shows the flow of messages for the Show Personal History use case. \
An authenticated user accesses the personal history section of the application. The mobile application requests the list of paths associated with the user through the Application Proxy and the API Gateway. \
The Personal Paths Service retrieves the list of stored paths from the DBMS and returns it to the mobile application, which displays the paths to the user. \
This use case only involves read operations and does not modify stored data.\

#let ShowDetailedViewSequenceDiagram = ```plantuml
title UC9 - Show Personal History
actor "Authenticated User" as User
boundary "Mobile App" as App
control "Application Proxy" as Proxy
control "API Gateway" as GW
control "Personal Paths Service" as PPS
entity "DBMS" as DBMS
User -> App : Open history
App -> Proxy : getUserPaths(userId)
Proxy -> GW
GW -> PPS : getUserPaths(userId)
PPS -> DBMS : fetchPathsByUser(userId)
DBMS --> PPS : pathsList
PPS --> App : pathsList
```

#figure(
ShowDetailedViewSequenceDiagram,
  kind: image,
  caption: [Show Detailed View Sequence Diagram]
)
#pagebreak()
*[UC10] Show Path Detailed View* \
This sequence diagram shows the flow of messages for the Show Path Detailed View use case. \
After selecting a path from the personal history, the user requests detailed information about the selected path. The mobile application forwards the request to the Personal Paths Service, which retrieves the complete path data from the DBMS, including coordinates, statistics, obstacles, and associated metadata. \
The mobile application then visualizes the retrieved information on the map. \
#let ShowPathDetailedViewSequenceDiagram = ```plantuml
title UC10 - Show Path Detailed View
actor "Authenticated User" as User
boundary "Mobile App" as App
control "Application Proxy" as Proxy
control "API Gateway" as GW
control "Personal Paths Service" as PPS
entity "DBMS" as DBMS
entity "Maps API" as MAPI
User -> App : Select path
App -> Proxy : getPathDetails(pathId)
Proxy -> GW
GW -> PPS : getPathDetails(pathId)
PPS -> DBMS : fetchPathDetails(pathId)
DBMS --> PPS : pathDetails
PPS --> App : pathDetails
App -> MAPI : renderPath(pathDetails)
```

#figure(
ShowPathDetailedViewSequenceDiagram,
  kind: image,
  caption: [Show Path Detailed View Sequence Diagram]
)
#pagebreak()

*[UC11] Set Bike Path Privacy* \
This sequence diagram shows the flow of messages for the Set Path Privacy use case. \
An authenticated user changes the visibility of one of their stored paths by updating its privacy level. The request is forwarded to the Personal Paths Service, which updates the privacy attribute of the selected path in the DBMS. \
This use case causes a transition of the path visibility state between Public and Private. \

#let SetBikePathPrivacySequenceDiagram = ```plantuml
title UC11 - Set Bike Path Privacy
actor "Authenticated User" as User
boundary "Mobile App" as App
control "Application Proxy" as Proxy
control "API Gateway" as GW
control "Personal Paths Service" as PPS
entity "DBMS" as DBMS
User -> App : Change privacy setting
App -> Proxy : updatePrivacy(pathId, visibility)
Proxy -> GW
GW -> PPS : updatePrivacy(pathId, visibility)
PPS -> DBMS : updatePrivacy(pathId, visibility)
DBMS --> PPS : OK
PPS --> App : confirmation
```

#figure(
SetBikePathPrivacySequenceDiagram,
  kind: image,
  caption: [Set Bike Path Privacy Sequence Diagram]
)
#pagebreak()
*[UC12] Delete Bike Path* \
This sequence diagram shows the flow of messages for the Delete Path use case. \
An authenticated user deletes one of their previously stored paths. After user confirmation, the deletion request is forwarded to the Personal Paths Service, which removes the path from the DBMS. \ 

#let DeleteBikePathSequenceDiagram = ```plantuml
title UC12 - Delete Bike Path
actor "Authenticated User" as User
boundary "Mobile App" as App
control "Application Proxy" as Proxy
control "API Gateway" as GW
control "Personal Paths Service" as PPS
entity "DBMS" as DBMS
User -> App : Request path deletion
App -> User : Show confirmation
User -> App : Confirm
App -> Proxy : deletePath(pathId)
Proxy -> GW
GW -> PPS : deletePath(pathId)
PPS -> DBMS : deletePath(pathId)
DBMS --> PPS : OK
PPS --> App : deletion confirmed
```

#figure(
DeleteBikePathSequenceDiagram,
  kind: image,
  caption: [Delete Bike Path Sequence Diagram]
)
#pagebreak()
*[UC13] Browse Community Paths* \
This sequence diagram shows the flow of messages for the Browse Community Paths use case. \
A user searches for bike paths between a starting point and a destination. The Path Recommendation Service retrieves public paths from the DBMS, computes a ranking based on quality and freshness, and returns the ranked paths to the mobile application. \
The application visualizes the recommended paths using the Maps API and highlights any incompatible road segments. \

#let BrowseCommunityPathsSequenceDiagram = ```plantuml
title UC13 - Browse Community Paths
actor User
boundary "Mobile App" as App
control "Application Proxy" as Proxy
control "API Gateway" as GW
control "Path Recommendation Service" as PRS
entity "DBMS" as DBMS
entity "Maps API" as MAPI
User -> App : Search paths
App -> Proxy : searchPaths(origin, destination)
Proxy -> GW
GW -> PRS : searchPaths(origin, destination)
PRS -> DBMS : fetchPublicPaths(origin, destination)
DBMS --> PRS : candidatePaths
PRS -> PRS : rankPaths()
PRS --> App : rankedPaths
App -> MAPI : renderPaths(rankedPaths)
```

#figure(
BrowseCommunityPathsSequenceDiagram,
  kind: image,
  caption: [Browse Community Paths Sequence Diagram]
)
#pagebreak()



== Component interfaces
== Selected architectural styles and patterns
Please explain which styles/patterns you used, why, and how
== Other design decisions

= User Interface Design
=== User Interfaces

As already stated in the RASD, Best Bike Paths will be an app for mobile devices (iOS and Android).  \
The User Interface will be optimized for touch screens and will follow their platform device guidelines (Human Interface Guidelines for iOS and Material Design for Android). Compliance with these standards ensures a consistent user experience and facilitates the implementation of accessibility best practices. \
User interaction occurs through touch input, gestures, and native UI components. \
Since the app relies on motion and location device features, the interface will include UI elements to request permission to interact with these device capabilities, following the platform-specific guidelines. \

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
If the path is not optimal for biking (for example, it contains an highway) an alert is shown.

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
The list rows display the path route in the map, its quality score and, if the path is not optimal for biking (for example, it contains an highway), an alert is shown.
When the user select a path row, the full-screen map shows the path and the confirm button on the trailing section of the modal navigation bar is enabled.

*Community Path Detail Page* \
When the user tap the confirm button, a modal sheet is shown as in @ui-community-paths-browsing-browsing-detail-authenticated if the user is authenticated, or in @ui-community-paths-browsing-browsing-detail-authenticated if the user is unauthenticated. \
The map shows the path route, start marker, end marker and, if the path was added manually, all the locations provided by the user to compose it. \
The modal shows all the publicly available path information and if the user is authenticated the record new path button. \
When the user starts a new path from here, a bike path recording session begins, with the selected path displayed on the map as a suggested route for the user to follow.
If the path is not optimal for biking (for example, it contains an highway) an alert is shown.


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


