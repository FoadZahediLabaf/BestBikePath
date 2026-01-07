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

#let FrontendComponentDiagram = ```plantuml
component "Best Bike Paths Frontend" {
component "Trip Statistics Manager" as TSM
component "Permission Manager" as PM
component "Local Storage" as LS
component "Sensor Data Collection Manager" as DCM
component "Obstacle Detection Manager" as ODM
 
interface "SensorData I" as SensorData
interface "ObstacleEvents I" as ObstacleEvents
interface "PermissionState I" as PermissionState
interface "Storage I" as StorageI
interface "RawData I" as RawData

ODM - ObstacleEvents
DCM -left- RawData
PM  -up- PermissionState
LS  -up- StorageI

DCM ..> PermissionState: use
TSM ..> PermissionState: use
ODM ..> PermissionState: use

DCM -down..> SensorData: use
ODM ..> RawData: use
TSM ..> RawData: use

ODM ..> StorageI: use
TSM ..> StorageI: use


}

package "Device Hardware" {

component GPS
component Gyroscope
component Accelerometer

interface SensorData

GPS -- SensorData
Gyroscope - SensorData
Accelerometer - SensorData
}

top to bottom direction
component "BBP Backend" as Backend
interface API
LS ..> API: use
API -down- Backend
```
#figure(
  FrontendComponentDiagram,
  kind: image,
  caption: [Frontend Component Diagram]
)

#pagebreak()

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

#let BackendComponentDiagram = ```plantuml
top to bottom direction

' frontend
component "Mobile App" as app 


' external components and interfaces
component "Weather Service" as ws 
component "SMTP Service" as smtp 
component "Maps Service" as ms  
interface "Weatheri" as wi 
interface "Mail I" as mi 
interface "Map I" as mapi
smtp -right- mi 
ms -up- mapi 
ws -left- wi


component "Best Bike Paths Backend"{
component "User Management Service" as ums 
component "Personal Paths Service" as pps 
component "Path Recommendation Service" as prs component "Path Recording Service" as recs 
component "DBMS" as db 

component "API Gateway" as gate 

interface "auth I" as useri 
interface "DBMS I" as dbi 
interface "Paths I" as pathsi 
interface "Recommend I" as ri
interface "Recording I" as reci 
interface "API I" as apii

' interface providers
ums -up- useri 
db -up- dbi
pps -up- pathsi
recs -up- reci 
prs -up- ri

gate -up- apii


' connections with gateway
gate ..> useri : use
gate ..> pathsi : use
gate ..> reci : use
gate ..> ri : use

'  dbms usage
ums ..> dbi: use 
prs ..> dbi: use
pps ..> dbi: use
recs ..> dbi: use

' connections with external components
app -right..> wi: use
ums -left..> mi: use
pps -down..> mapi: use 
prs -down..> mapi: use  
port p1
p1 -down..> apii
app -down.. p1
app -left..> mi
}
```
#figure(
  BackendComponentDiagram,
  kind: image,
  caption: [Backend Component Diagram]
)

#pagebreak()

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

== Runtime view <section-runtime-view>
This section describes the dynamic behavior of the Best Bike Paths (BBP) system by illustrating the flow of messages exchanged among architectural components for the most relevant use cases defined in the RASD. \
The runtime view focuses on the main success scenarios and highlights how the system components collaborate to realize the required functionalities. \
For clarity and consistency with the Software Architecture lectures, the following aspects are intentionally omitted: \
- authorization and access-control checks;
- error handling and exceptional flows;
- caching and optimization mechanisms;
- firewall-related interactions.
All sequence diagrams represent only the main execution path. \
The system frontend is represented exclusively by a Mobile Application (iOS/Android), as specified in the RASD. \
Each runtime scenario corresponds directly to a use case defined in the RASD. Some use cases are included even when they do not introduce new backend components because they involve critical runtime interactions with device sensors, which are architecturally relevant for the system. \

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Account Management")
*UC1 Account Creation* \
This sequence diagram shows the flow of messages for the Account Creation use case . \
The user initiates authentication through the app by entering an email address. The request is forwarded through the Application Proxy and the API Gateway to the User Management Service, which checks whether the email is already registered in the DBMS. \
Since the email provided is not registered, the User Management Service generates a verification code, stores it temporarily in the KV Storage, and sends it to the user via the SMTP Server. After the user enters the received code and provides the registration data, the service validates the code, creates the user in the DBMS, and returns a JWT the user can use to authenticate their subsequent requests. \

#let accountCreationSequenceDiagram = ```plantuml
autonumber
actor User
box "Frontend" #LightBlue
boundary "BBP App" as Frontend
end box
box "Backend"
control "Application Proxy" as AP
control "API Gateway" as AG
control "User Management Service" as UMS
database "DBMS" as DB
collections "KV Store" as KV
queue "SMTP Server" as SMTP
activate User
activate Frontend
User ->> Frontend: Open account page
Frontend -> User: Show email text field
User ->> Frontend: Insert email
Frontend -> AP: userExists(email)
activate AP
AP -> AG: userExists(email)
activate AG
AG -> UMS: userExists(email)
activate UMS
UMS -> DB: userExists(email)
activate DB
DB --> UMS: 200 OK (false)
deactivate DB
UMS --> AG: 200 OK (false)
deactivate UMS
AG --> AP: 200 OK (false)
deactivate AG
AP --> Frontend: 200 OK (false)
deactivate AP
Frontend -> User: Show email verification textfield
Frontend -> AP: sendVerificationCode(email)
activate AP
AP -> AG: sendVerificationCode(email)
activate AG
AG -> UMS: sendVerificationCode(email)
activate UMS
UMS -> UMS: generateCode()
UMS -> KV: save(code, email)\n[TTL: 1H]
activate KV
KV --> UMS: 201 Created
deactivate KV
UMS ->> SMTP: enqueueVerificationEmail(email, code)
activate SMTP
SMTP ->> User: Deliver verification email
SMTP --> UMS: 200 OK
deactivate SMTP
UMS --> AG: 200 OK
deactivate UMS
AG --> AP: 200 OK
deactivate AG
AP --> Frontend: 200 OK
deactivate AP
Frontend -> User: Show code sent banner
User -> Frontend: Insert verification code
Frontend -> AP: verifyCode(email, code)
activate AP
AP -> AG: verifyCode(email, code)
activate AG
AG -> UMS: verifyCode(email, code)
activate UMS
UMS -> KV: getEmail(code)
activate KV
KV --> UMS: 200 OK (email)
deactivate KV
UMS -> UMS: checkEmail(email1, email2)
UMS --> AG: 200 OK
deactivate UMS
AG --> AP: 200 OK
deactivate AG
AP --> Frontend: 200 OK
deactivate AP
Frontend -> User: Show account signup form
User ->> Frontend: Insert name, password\naccept consents & privacy
Frontend -> AP: signup(name, email, password, code)
activate AP
AP -> AG: signup(name, email, password, code)
activate AG
AG -> UMS: signup(name, email, password, code)
activate UMS
UMS -> KV: getEmail(code)
activate KV
KV --> UMS: 200 OK (email)
deactivate KV
UMS -> UMS: checkEmail(email1, email2)
UMS -> DB: createAccount(name, email, password)
activate DB
DB --> UMS: 201 Created
deactivate DB
UMS -> UMS: generateToken()
UMS --> AG: 201 Created (token)
deactivate UMS
AG --> AP: 201 Created (token)
deactivate AG
AP --> Frontend: 201 Created (token)
deactivate AP
Frontend -> User: Show homepage as logged user
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
autonumber
actor User
box "Frontend" #LightBlue
boundary "BBP App" as Frontend
end box
box "Backend"
control "Application Proxy" as AP
control "API Gateway" as AG
control "User Management Service" as UMS
database "DBMS" as DB
end box
activate User
activate Frontend
User ->> Frontend: Open account page
Frontend -> User: Show email textfield
User ->> Frontend: Insert email
Frontend -> AP: userExists(email)
activate AP
AP -> AG: userExists(email)
activate AG
AG -> UMS: userExists(email)
activate UMS
UMS -> DB: userExists(email)
activate DB
DB --> UMS: 200 OK (true)
deactivate DB
UMS --> AG: 200 OK (true)
deactivate UMS
AG --> AP: 200 OK (true)
deactivate AG
AP --> Frontend: 200 OK (true)
deactivate AP
Frontend -> User: Show password textfield
User ->> Frontend: Insert password
Frontend -> AP: signin(email, password)
activate AP
AP -> AG: signin(email, password)
activate AG
AG -> UMS: signin(email, password)
activate UMS
UMS -> DB: getAccount(email)
activate DB
DB --> UMS: 200 OK (account)
deactivate DB
UMS -> UMS: checkCredentials(password1, password2)
alt Not valid credentials
    UMS --> AG: 401 Unauthorized
    deactivate UMS
    AG --> AP: 401 Unauthorized
    deactivate AG
    AP --> Frontend: 401 Unauthorized
    deactivate AP
    Frontend -> User: Show error
else Valid credentials
    activate AP
    activate AG
    activate UMS
    UMS -> UMS: generateToken()
    UMS --> AG: 200 OK (account, token)
    deactivate UMS
    AG --> AP: 200 OK (account, token)
    deactivate AG
    AP --> Frontend: 200 OK (account, token)
    deactivate AP
    Frontend -> User: Show homepage as logged user
end
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

#let accountDeletionSequenceDiagram = ```plantuml
autonumber
actor User
box "Frontend" #LightBlue
boundary "BBP App" as Frontend
end box
box "Backend"
control "Application Proxy" as AP
control "API Gateway" as AG
control "User Management Service" as UMS
database "DBMS" as DB
end box
activate User
activate Frontend
User ->> Frontend: Open account page
Frontend -> User: Show delete account button
User ->> Frontend: Press delete account button
Frontend -> User: Show confirm button
User ->> Frontend: Press confirm button
Frontend -> AP: deleteAccount(email)
note over Frontend, AP
  Authenticated request
end note
activate AP
AP -> AG: deleteAccount(email)
activate AG
AG -> UMS: deleteAccount(email)
activate UMS
UMS -> DB: deleteAccount(email)
activate DB
DB --> UMS: 200 OK (true)
deactivate DB
UMS --> AG: 200 OK (true)
deactivate UMS
AG --> AP: 200 OK (true)
deactivate AG
AP --> Frontend: 200 OK (true)
deactivate AP
Frontend -> User: Show homepage as unauthenticated user
```
#figure(
  accountDeletionSequenceDiagram,
  kind: image,
  caption: [Account Deletion Sequence Diagram]
)

#pagebreak()
*UC4 User Sign Out* \
This sequence diagram shows the flow of messages for the User Sign Out use case. \
The authenticated user signs out by removing the locally stored authentication token. No interaction with Backend services is required. \

#let userSignOutSequenceDiagram = ```plantuml
autonumber
actor User
box "Frontend" #LightBlue
boundary "BBP App" as Frontend
end box
activate User
activate Frontend
User ->> Frontend: Open account page
Frontend -> User: Show sign out button
User ->> Frontend: Press logout account button
Frontend -> User: Show confirmation dialog
User ->> Frontend: Press confirm button
Frontend -> Frontend: deleteToken()
Frontend -> User: Show homepage as unauthenticated user
```
#figure(
userSignOutSequenceDiagram,
  kind: image,
  caption: [User Sign Out Sequence Diagram]
)

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Permission Management")
*UC5 Request Device Capability Permission*

This sequence diagram shows how the system verifies and obtains the permissions required to access a device capability, for example the user’s location access.
When the user initiates the recording function, the mobile application requests the Permission Manager to check if it has access authorization to the user’s location obtained through the device's GPS.

If the permission is missing, the mobile application shows a modal to the user.
Here, the user can see which capability the app needs to access and why.

_Not Determined Permission_ \
If the capability is available and the user has never denied the authorization (from the system dialog), and the user decides to give their permission, the system dialog is shown and the user can allow the app to use the capability through the system dialog.
Otherwise, the user can close the modal and not use the app feature.

_Denied Permission_ \
If the capability is available and the user has denied the authorization (from the system dialog), and the user decides to give their permission, they must open the settings and change the access authorization status manually.
Otherwise, the user can close the modal and not use the app feature.

_Unavailable Permission_ \
If the capability is unavailable, the user can just close the modal and not use the app feature.

#let requestCapabilitySequenceDiagram = ```plantuml
autonumber
actor User
box "Frontend" #LightBlue
boundary "BBP App" as Frontend
control "Permission Manager" as PM
entity "Capability Provider" as CP
boundary "System Settings" as Settings
end box
activate User
activate Frontend
Frontend -> Frontend: Needs device capability
Frontend -> PM: getAuthorizationStatus
activate PM
PM -> CP: getAuthorizationStatus
activate CP
alt Capability access is unavailable
  CP --> PM: unavailable
  deactivate CP
  PM --> Frontend: unavailable
  deactivate PM
  Frontend -> Frontend: Continue without capability
else Capability access was denied
  activate CP
  activate PM
  CP --> PM: denied
  deactivate CP
  PM --> Frontend: denied
  deactivate PM
  Frontend -> User: Show a modal explaining\nwhy the capability is needed\nand instructionsto give\npermission in system settings
  loop Until user presses 'Cancel' or authorize capability access in settings
    alt Continue
      User ->> Frontend: Press 'Cancel' button
      Frontend -> Frontend: Continue without capability
    else Authorize capability access
      User ->> Settings: Authorize capability access
      activate Settings
      Settings -> CP: notifyCapabilityAuthorizationChange('authorized')
      deactivate Settings
      activate CP
      User ->> Frontend: Open application
      CP -> PM: notifyCapabilityAuthorizationChange('authorized')
      deactivate CP
      activate PM
      PM -> Frontend: notifyCapabilityAuthorizationChange('authorized')
      deactivate PM
      Frontend -> Frontend: Continue with capability
    end
  end
  Frontend -> Frontend: Continue
else Capability access is authorized
  activate PM
  activate CP
  CP --> PM: authorized
  deactivate CP
  PM --> Frontend: authorized
  deactivate PM
  Frontend -> Frontend: Continue with capability
else Capability access is not determined
  activate PM
  activate CP
  CP --> PM: notDetermined
  deactivate CP
  PM --> Frontend: notDetermined
  deactivate PM
  Frontend -> User: Show a modal explaining\nwhy the capability is needed
  alt Cancel
    User ->> Frontend: Press 'Cancel' button
  else Continue
    User ->> Frontend: Press 'Continue' button
    Frontend -> PM: askAuthorization
    activate PM
    PM -> CP: askAuthorization
    deactivate PM
    activate CP
    CP -> Settings: askAuthorization
    deactivate CP
    activate Settings
    Settings -> User: Show system dialog to give permission
    alt Not allow usage
      User ->> Settings: Press 'Don't allow' button
      Settings -> CP: notifyCapabilityAuthorizationChange('denied')
      deactivate Settings
      activate CP
      User ->> Frontend: Open application
      CP -> PM: notifyCapabilityAuthorizationChange('denied')
      deactivate CP
      activate PM
      PM -> Frontend: notifyCapabilityAuthorizationChange('denied')
      deactivate PM
      Frontend -> Frontend: Continue without capability
    else Allow usage
      activate Settings
      User ->> Settings: Press 'Allow' button
      Settings -> CP: notifyCapabilityAuthorizationChange('authorized')
      deactivate Settings
      activate CP
      User ->> Frontend: Open application
      CP -> PM: notifyCapabilityAuthorizationChange('authorized')
      deactivate CP
      activate PM
      PM -> Frontend: notifyCapabilityAuthorizationChange('authorized')
      deactivate PM
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
*UC6 Automatic Recording With Manual Controls* \ 
This sequence diagram shows the flow of messages for the Automatic Recording With Manual Controls use case. \
During an active recording session, the authenticated user may explicitly pause or resume the recording through the UI. When the user pauses, the mobile application requests the Trip Statistics Manager to suspend performance monitoring and updates the UI accordingly. When the user resumes, the application requests performance monitoring to restart and updates the UI timer. \
This use case causes explicit transitions between Recording and Paused states.
#let automaticRecordingManualControlsSequenceDiagram = ```plantuml
autonumber
actor User
box "Frontend" #LightBlue
boundary "BBP App" as Frontend
control "Trip Statistics Manager" as TSM
control "Sensor Data Collection Manager" as SDCM
entity "Accelerometer" as ACC
entity "Gyroscope" as GYR
end box
activate User
activate Frontend
User ->> Frontend: Press "start" button
Frontend -> TSM: StartActivityChangeUpdates
activate TSM
TSM -> SDCM: startActivityChangeUpdates
activate SDCM
SDCM -> GYR: startUpdates
activate GYR
SDCM -> ACC: startUpdates
activate ACC
Frontend -> TSM: startPerformanceMonitoring
TSM -> SDCM: startMotionUpdates
loop Until recording stops
  ...
  alt User presses "resume" button
    User ->> Frontend: Press "resume" button
    Frontend -> TSM: startPerformanceMonitoring
    TSM -> SDCM: startMotionUpdates
    Frontend -> Frontend: Resume timer
    Frontend -> User: Show updated UI
    ...
  else User presses "pause" button
    User ->> Frontend: Press "pause" button
    Frontend -> TSM: stopPerformanceMonitoring
    TSM -> SDCM: stopMotionUpdates
    Frontend -> Frontend: Pause timer
    Frontend -> User: Show updated UI
    ...
  end
end
User ->> Frontend: Press "Stop Recording" button
Frontend -> TSM: stopActivityChangeUpdates
TSM -> SDCM: stopActivityChangeUpdates
deactivate TSM
SDCM -> ACC: stopUpdates 
deactivate ACC
SDCM -> GYR: stopUpdates
deactivate GYR
deactivate SDCM
```
#figure(
  automaticRecordingManualControlsSequenceDiagram,
  kind: image,
  caption: [Automatic Recording With Manual Controls Sequence Diagram]
)
#pagebreak()
*UC7 Automatic Recording With Activity Detection* \
This sequence diagram shows the flow of messages for the Automatic Recording With Activity Detection use case. \
During an active recording session, the mobile application monitors the ongoing trip to determine whether the user is currently biking. This monitoring is performed by the Trip Statistics Manager that reacts to the activity change updates coming from Sendor Data CollectionManager, which evaluates the stream of sensor data provided by the motion sensors. \
When an activity change is detected, the Trip Statistics Manager notify the UI that updates accordingly.
This use case causes repeated transitions between Recording and Paused states until the user explicitly stops the session.
#let automaticRecordingManualActivityDetectionSequenceDiagram = ```plantuml
autonumber
actor User
box "Frontend" #LightBlue
boundary "BBP App" as Frontend
control "Trip Statistics Manager" as TSM
control "Sensor Data Collection Manager" as SDCM
entity "Accelerometer" as ACC
entity "Gyroscope" as GYR
end box
activate User
activate Frontend
User ->> Frontend: Press "start" button
Frontend -> TSM: startActivityChangeUpdates
activate TSM
TSM -> SDCM: startActivityChangeUpdates
activate SDCM
SDCM -> GYR: startUpdates
activate GYR
SDCM -> ACC: startUpdates
activate ACC
Frontend -> TSM: startPerformanceMonitoring
TSM -> SDCM: startMotionUpdates
loop Until recording stops
  ...
  ACC ->> SDCM: accelerometerData
  GYR ->> SDCM: gyroData
  SDCM ->> SDCM: detectActivityChange(accelerometerData, gyrData)
  alt User starts biking
    SDCM ->> TSM: notifyActivityChange('cycling')
    TSM ->> Frontend: notifyActivityChange('cycling')
    Frontend -> TSM: startPerformanceMonitoring
    TSM -> SDCM: startMotionUpdates
    Frontend -> Frontend: Resume timer
    Frontend -> User: Show updated UI
    ...
  else User stops biking
    SDCM ->> TSM: notifyActivityChange\n('stationary' / 'walking' / ...)
    TSM ->> Frontend: notifyActivityChange\n('stationary' / 'walking' / ...)
    Frontend -> TSM: stopPerformanceMonitoring
    TSM -> SDCM: stopMotionUpdates
    Frontend -> Frontend: Pause timer
    Frontend -> User: Show updated UI
    ...
  end
end
User ->> Frontend: Press "Stop Recording" button
Frontend -> TSM: stopActivityChangeUpdates
TSM -> SDCM: stopActivityChangeUpdates
deactivate TSM
SDCM -> ACC: stopUpdates 
deactivate ACC
SDCM -> GYR: stopUpdates
deactivate GYR
deactivate SDCM
```
#figure(
  automaticRecordingManualActivityDetectionSequenceDiagram,
  kind: image,
  caption: [Automatic Recording With Activity Detection Sequence Diagram]
)

#pagebreak()
*UC8 Manual Obstacle Insertion* \
This sequence diagram shows the flow of messages for the Manual Obstacle Insertion use case. \
During an active recording session, the authenticated user manually reports an obstacle through the mobile application. The obstacle is associated with the current trip and stored locally together with the trip data. \
This use case does not interrupt the recording session. \
#let manualObstacleInsertionSequenceDiagram = ```plantuml
autonumber
actor User
box "Frontend" #LightBlue
boundary "BBP App" as Frontend
control "Obstacle Detection Manager" as ODM
entity "Local Storage" as LS
end box
activate User
activate Frontend
User ->> Frontend: Press 'start' button
loop Until recording stops
  ...
  User ->> Frontend: Press 'add obstacle' button
  Frontend -> ODM: incrementObastacleCount
  activate ODM
  ODM -> LS: incrementObastacleCount
  deactivate ODM
  Frontend -> User: Show obstacle confirmation dialog
  alt User confirms or ignores dialog
    User ->> Frontend: Press 'confirm' button
  else User cancels
    User ->> Frontend: Press 'cancel' button
    Frontend -> ODM: decrementObastacleCount
    activate ODM
    ODM -> LS: decrementObastacleCount
    deactivate ODM
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
*UC9 Automatic Obstacle Detection* \
This sequence diagram shows the flow of messages for the Automatic Obstacle Detection use case. \
During an active recording session, the Sensor Data Collection Manager samples motion sensor data and forwards it to the Obstacle Detection Manager. The Obstacle Detection Manager analyzes the received sensor stream to detect potential obstacles. \
When an obstacle is detected, the user is notified through the UI and can confirm or reject it. If the user confirms or does not respond within a timeout, the obstacle is associated with the current trip and stored locally together with the trip data; otherwise it is discarded. The recording continues in any case. \
#let automaticObstacleDetectionSequenceDiagram = ```plantuml
autonumber
actor User
box "Frontend" #LightBlue
boundary "BBP App" as Frontend
control "Obstacle Detection Manager" as ODM
control "Sensor Data Collection Manager" as SDCM
entity "Accelerometer" as ACC
entity "Gyroscope" as GYR
entity "Local Storage" as LS
end box
activate User
activate Frontend
User ->> Frontend: Press "start" button
Frontend -> ODM: startObstacleDetection
activate ODM
ODM -> SDCM: startMotionUpdates
activate SDCM
SDCM -> GYR: startUpdates
activate GYR
SDCM -> ACC: startUpdates
activate ACC
loop Until recording stops
  ...
  ACC ->> SDCM: accelerometerData
  GYR ->> SDCM: gyroData
  SDCM -> ODM: motionData
  ODM -> ODM: detectObstacle(motionData)
  opt Obstacle is detected
    ODM -> LS: incrementObstacleCount
    ODM -> Frontend: notifyDetectedObstacle
    Frontend -> User: Show obstacle confirmation dialog
    alt User confirms or ignores dialog
      User ->> Frontend: Press "confirm" button
    else User cancels
      User ->> Frontend: Press "cancel" button
      Frontend -> ODM: decrementObstacleCount
      ODM -> LS: decrementObstacleCount
    end
  end
end
User ->> Frontend: Press "stop" button
Frontend -> ODM: stopObstacleDetection
ODM -> SDCM: stopMotionUpdates
deactivate ODM
SDCM -> ACC: stopUpdates
deactivate ACC
SDCM -> GYR: stopUpdates
deactivate SDCM
deactivate GYR
```
#figure(
  automaticObstacleDetectionSequenceDiagram,
  kind: image,
  caption: [Automatic Obstacle Detection Sequence Diagram]
)

#pagebreak()
*UC10 Stop Recording * \
This sequence diagram shows the flow of messages for the Stop Recording use case. \
The user stops the recording session and confirms the action. The mobile application requests the services using Sensor Data Collection Manager to terminate sensor acquisition and finalizes the path data. \
If needed, the service may enrich the stored trip with meteorological information obtained through the Weather API. \
The path data is then submitted to the Backend through the Application Proxy and the API Gateway. The Path Recording Service stores the trip in the DBMS. 
The mobile application is notified of success and the path becomes available in the user’s personal history \
This use case causes the recording state to transition from Recording to Stopped. \
#let stopRecordingSequenceDiagram = ```plantuml
autonumber
skinparam SequenceMessageAlign center
actor User
box "Frontend" #LightBlue
boundary "BBP App" as App
control "Trip Statistics Manager" as TSM
control "Obstacle Detection Manager" as ODM
entity "Local Storage" as LS
control "Sensor Data Collection Manager" as SDCM
entity "Accelerometer" as ACC
entity "Gyroscope" as GYR
end box
box "Backend"
boundary "Weather API" as API
control "Application Proxy" as AP
control "API Gateway" as AG
control "Path Recording Service" as PRS
database "DBMS" as DB
end box
activate User
activate App
activate TSM
activate ODM
activate SDCM
activate SDCM
activate ACC
activate GYR
User ->> App: Press "stop" button
App -> User: Request for confirmation
User ->> App: Press "confirm" button
App -> TSM: getPerformanceData
TSM -> LS: getPerformanceData
activate LS
LS --> TSM: performanceData
deactivate LS
TSM --> App: performanceData
App -> TSM: stopActivityUpdates
TSM -> SDCM: stopMotionUpdates
deactivate TSM
deactivate SDCM
App -> ODM: getObstacleCount
ODM -> LS: getObstacleCount
activate LS
LS --> ODM: obstacleCount
deactivate LS
ODM --> App: obstacleCount
App -> ODM: stopObstacleDetection
ODM -> SDCM: stopMotionUpdates
deactivate ODM
SDCM -> ACC: stopUpdates
deactivate ACC
SDCM -> GYR: stopUpdates
deactivate GYR
deactivate SDCM
App -> API: getWeatherData(location, date)
alt Meteorological data available
    activate API
    API --> App: 200 OK (weatherData)
else Meteorological data unavailable
    API --> App: 404 Not Found
    deactivate API
end
App -> App: Compute pathData
App -> AP: savePath(pathData) 
activate AP
AP -> AG: savePath(pathData) 
activate AG
AG -> PRS: savePath(pathData) 
activate PRS
PRS -> DB: savePath(pathData) 
activate DB
DB --> PRS: 200 OK
deactivate DB
PRS --> AG: 200 OK
deactivate PRS
AG --> AP: 200 OK
deactivate AG
AP --> App: 200 OK
deactivate AP
App -> User: Show Homepage
```
#figure(
  stopRecordingSequenceDiagram,
  kind: image,
  caption: [Stop Recording Sequence Diagram]
)

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Manual Bike Path Insertion")
*UC11 Manual Path Insertion* \
This sequence diagram shows the flow of messages for the Manual Path Insertion use case. \
An authenticated user manually creates a bike path by specifying a starting point, a destination, and optional intermediate locations through the mobile application. For each inserted location, the application interacts with the Maps API to translate street addresses into geographic coordinates and to visualize the path on the map. \
Once the path definition is completed, the user selects the path status and privacy level. The mobile application then submits the manually created path to the Backend through the Application Proxy and the API Gateway. The Path Recording Service stores the path data in the DBMS, making it available in the user’s personal history. \
This use case does not involve sensor data acquisition and does not affect the recording state. \
#let manualPathInserionSequenceDiagram = ```plantuml
autonumber
actor "User" as U
box "Frontend" #LightBlue
boundary "BBP App " as UI
end box
box "Backend"
boundary "Maps API" as MAP
control "Application Proxy" as AP
control "API Gateway" as AG
control "Path Recording Service" as PRS
database "DBMS" as DB
end box
activate U
activate UI
U ->> UI : Open "Manual Path Creation"
UI -> U : Show form
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
U ->> UI : Select path status
UI -> UI : Store path status
U ->> UI : Set path privacy
UI -> UI : Store path privacy
U ->> UI : Tap "Save"
UI -> AP : savePath\n(streetLocations, status,\nprivacy, date)
activate AP
AP -> AG : savePath\n(streetLocations, status,\nprivacy, date)
activate AG
AG -> PRS : savePath\n(streetLocations, status,\nprivacy, date)
activate PRS
PRS -> DB : savePath\n(streetLocations, status,\nprivacy, date)
activate DB
DB --> PRS : 200 OK
deactivate DB
PRS --> AG : 200 OK
deactivate PRS
AG --> AP : 200 OK
deactivate AG
AP --> UI : 200 OK
deactivate AP
UI -> U : Show path added to history
```
#figure(
  manualPathInserionSequenceDiagram,
  kind: image,
  caption: [Manual Path Insertion Sequence Diagram]
)

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Personal History Management")
*UC12 Show Detailed View* \
This sequence diagram shows the flow of messages for the Show Detailed View use case. \
An authenticated user accesses the personal history section of the application. The mobile application requests the list of paths associated with the user through the Application Proxy and the API Gateway. \
The Personal Paths Service retrieves the list of stored paths from the DBMS and returns it to the mobile application, which displays the paths to the user. \
After selecting a path from the personal history, the user requests detailed information about the selected path. The mobile application forwards the request to the Personal Paths Service, which retrieves the complete path data from the DBMS, including coordinates, statistics and associated metadata. \
The mobile application then visualizes the retrieved information on the map. \
This use case only involves read operations and does not modify stored data.\
#let showUserPathDetailedViewSequenceDiagram = ```plantuml
autonumber
actor "User" as User
box "Frontend" #LightBlue
boundary "BBP App " as App
end box
box "Backend"
control "Application Proxy" as AP
control "API Gateway" as AG
control "Personal Paths Service" as PPS
database "DBMS" as db
end box
activate User
activate App
User ->> App: Open application
App -> User: Show History Page 
App -> AP: getPaths(userId)
activate AP
AP -> AG: getPaths(userId)
activate AG
AG -> PPS: getPaths(userId)
activate PPS
PPS -> db: getPaths(userId)
activate db
db --> PPS: 200 OK (userPaths)
deactivate db
PPS -> AG: 200 OK (userPaths)
deactivate PPS
AG -> AP: 200 OK (userPaths)
deactivate AG
AP -> App: 200 OK (userPaths)
deactivate AP
App -> User: Show user paths 
User ->> App: Select path
App -> User: Show Detailed view
App -> AP: getUserPathDetails(pathId)
activate AP
AP -> AG: getUserPathDetails(pathId)
activate AG
AG -> PPS: getUserPathDetails(pathId)
activate PPS
PPS -> db: getUserPathDetails(pathId)
activate db
db --> PPS: 200 OK (userPathDetail)
deactivate db
PPS -> AG: 200 OK (userPathDetail)
deactivate PPS
AG -> AP: 200 OK (userPathDetail)
deactivate AG
AP -> App: 200 OK (userPathDetail)
deactivate AP
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
*UC13 Set Bike Path Privacy* \
This sequence diagram shows the flow of messages for the Set Path Privacy use case. \
An authenticated user changes the visibility of one of their stored paths by updating its privacy level. The request is forwarded to the Personal Paths Service, which updates the privacy attribute of the selected path in the DBMS. \
This use case causes a transition of the path visibility state between Public and Private.
#let setPrivacySequenceDiagram = ```plantuml
autonumber
actor "User" as User
box "Frontend" #LightBlue
boundary "BBP App " as App
end box
box "Backend"
control "Application Proxy" as AP
control "API Gateway" as AG
control "Personal Paths Service" as PPS
database "DBMS" as db
end box
activate User
activate App
User ->> App: Open application
App -> User: Show History Page 
App -> AP: getPaths(userId)
activate AP
AP -> AG: getPaths(userId)
activate AG
AG -> PPS: getPaths(userId)
activate PPS
PPS -> db: getPaths(userId)
activate db
db --> PPS: 200 OK (userPaths)
deactivate db
PPS -> AG: 200 OK (userPaths)
deactivate PPS
AG -> AP: 200 OK (userPaths)
deactivate AG
AP -> App: 200 OK (userPaths)
deactivate AP
App -> User: Show user paths 
User ->> App: Select path
App -> User: Show Detailed view
alt Publish bike path
    User ->> App: Set privacy toggle to "On"
    User ->> App: Press save button
    App -> AP: setPrivacyStatus(pathId, "Public")
    activate AP
    AP -> AG: setPrivacyStatus(pathId, "Public")
    activate AG
    AG -> PPS: setPrivacyStatus(pathId, "Public")
    activate PPS
    PPS -> db: setPrivacyStatus(pathId, "Public")
    activate db
    db --> PPS: 200 OK
    deactivate db
    PPS -> AG: 200 OK
    deactivate PPS
    AG -> AP: 200 OK
    deactivate AG
    AP -> App: 200 OK
    deactivate AP
else Unpublish bike path
    User ->> App: Set privacy toggle to "Off"
    User ->> App: Press save button
    App -> AP: setPrivacyStatus(pathId, "Private")
    activate AP
    AP -> AG: setPrivacyStatus(pathId, "Private")
    activate AG
    AG -> PPS: setPrivacyStatus(pathId, "Private")
    activate PPS
    PPS -> db: setPrivacyStatus(pathId, "Private")
    activate db
    db --> PPS: 200 OK
    deactivate db
    PPS -> AG: 200 OK
    deactivate PPS
    AG -> AP: 200 OK
    deactivate AG
    AP -> App: 200 OK
    deactivate AP
end
App -> User: Notify User
```
#figure(
  setPrivacySequenceDiagram,
  kind: image,
  caption: [Set Bike Path Privacy Sequence Diagram]
)

#pagebreak()
*UC14 Delete Bike Path* \
This sequence diagram shows the flow of messages for the Delete Bike Path use case. \
An authenticated user deletes one of their previously stored paths. After user confirmation, the deletion request is forwarded to the Personal Paths Service, which removes the path from the DBMS. \ 
#let deleteBikePathSequenceDiagram = ```plantuml
autonumber
actor "User" as User
box "Frontend" #LightBlue
boundary "BBP App " as App
end box
box "Backend"
control "Application Proxy" as AP
control "API Gateway" as AG
control "Personal Paths Service" as PPS
database "DBMS" as DB
end box
activate User
activate App
User ->> App: Open application
App -> User: Show History Page 
App -> AP: getPaths(userId)
activate AP
AP -> AG: getPaths(userId)
activate AG
AG -> PPS: getPaths(userId)
activate PPS
PPS -> DB: getPaths(userId)
activate DB
DB --> PPS: 200 OK (userPaths)
deactivate DB
PPS -> AG: 200 OK (userPaths)
deactivate PPS
AG -> AP: 200 OK (userPaths)
deactivate AG
AP -> App: 200 OK (userPaths)
deactivate AP
App -> User: Show user paths 
User ->> App: Select path
App -> User: Show Detailed view
User ->> App: Press "delete" button
App -> User: Show "confirm" button
User ->> App: Press "confirm" button
App -> AP: deletePath(pathId)
activate AP
AP -> AG: deletePath(pathId)
activate AG
AG -> PPS: deletePath(pathId)
activate PPS
PPS -> DB: deletePath(pathId)
activate DB
DB --> PPS: 200 OK
deactivate DB
PPS -> AG: 200 OK
deactivate PPS
AG -> AP: 200 OK 
deactivate AG
AP -> App: 200 OK
deactivate AP
App -> User : Show History Page
```
#figure(
  deleteBikePathSequenceDiagram,
  kind: image,
  caption: [Delete Bike Path Sequence Diagram]
)

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Community Bike Path Browsing")
*UC15 Browse Community Paths* \
This sequence diagram shows the flow of messages for the Browse Community Paths use case. \
A user searches for bike paths between a starting point and a destination. The Path Recommendation Service queries public paths from the DBMS using a sorting predicate that ranks paths based on quality and freshness, and returns the ranked paths to the mobile application. \
The application visualizes the recommended paths using the Maps API and highlights any incompatible road segments. \
#let browseCommunityPathSequenceDiagram = ```plantuml
autonumber
actor "User" as U
box "Frontend" #LightBlue
boundary "BBP App " as UI
end box
box "Backend"
boundary "Maps API" as MAP
control "Application Proxy" as AP
control "API Gateway" as AG
control "Path Recommendation Service" as PRS
database "DBMS" as DB
end box
activate UI
activate U
U ->> UI : Open "Community Bike Paths" browser
UI -> U : Show search form
loop Until start and end location are inserted
  U ->> UI : Insert location address
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
UI -> AP : fetchPaths\n(startLocation, endLocation)
activate AP
AP -> AG : fetchPaths\n(startLocation, endLocation)
activate AG
AG -> PRS : fetchPaths\n(startLocation, endLocation)
activate PRS
PRS -> DB : queryPaths\n(startLocation, endLocation,\nsortPredicate)
activate DB
DB --> PRS: 200 OK (sortedPaths)
deactivate DB
PRS --> AG: 200 OK (rankedPaths)
deactivate PRS
AG --> AP: 200 OK (rankedPaths)
deactivate AG
AP --> UI: 200 OK (rankedPaths)
deactivate AP
loop
UI -> MAP : hasHighways(path)
activate MAP
MAP -->> UI : true/false
note over UI, MAP
  If true the path will display a warning alert
end note
deactivate MAP
end
deactivate MAP
UI -> U : Show ranked path list
U ->> UI : Select a Path
UI -> MAP : addPathToMap(path)
activate MAP
MAP -->> UI : updateShownMapArea
deactivate MAP
U ->> UI : Confirm Path selection
UI -> U : Show Path detail
opt User is authenticated
  UI -> U : Show “Start Recording” Button
  U ->> UI : Press “Start Recording” Button
  UI -> U : Show Automatic Recording Page\nwith selected path displayed on the map
end
```
#figure(
  browseCommunityPathSequenceDiagram,
  kind: image,
  caption: [Browse Community Paths Sequence Diagram]
)

#pagebreak()
== Component interfaces
This section describes the interfaces exposed by the main architectural components introduced in the previous sections. The goal is to clarify how components interact with each other and which services they provide, without entering implementation-specific details. \
In line with the Software Architecture lectures, interfaces are described at a logical level, focusing on the operations offered by each component and on the type of information that is exchanged. As a result, this section does not define concrete APIs, protocols, or data formats, but rather provides an abstract view of the responsibilities of each interface. \
All the interfaces presented here are consistent with the runtime interactions illustrated in @section-runtime-view. 
The Mobile App represents the only entry point for user interactions and communicates with the back-end exclusively through the interfaces described below. \

#heading(level: 4, numbering: none,  outlined: false,  "Frontend")

Mobile App
- `notifyCapabilityAuthorizationChange(authorization)`
- `notifyActivityChange(activity)`
- `notifyPerformanceUpdate(performance)`
- `notifyObstacleDetection to update`

Local Storage
- `incrementObstacleCount`
- `decrementObstacleCount`

*Capability Authorization I* \
Permission Manager
- `getAuthorizationStatus`
- `notifyCapabilityAuthorizationChange`
- `askAuthorization`

Capability Providers
- `getAuthorizationStatus`
- `askAuthorization`


*Recording I* \
Trip Statistics Manager
- `startActivityUpdates`
- `stopActivityUpdates`
- `startPerformanceMonitoring`
- `stopPerformanceMonitoring`
- `notifyMotionUpdates(motionData)`
- `notifyActivityChange(activity)`

Obstacle Detection Manager
- `incrementObstacleCount`
- `decrementObstacleCount`
- `startObstacleDetection`
- `stopObstacleDetection`
- `notifyMotionUpdates(motionData)`

Sensor Data Collection Manager
- `startActivityChangeUpdates`
- `stopActivityChangeUpdates`
- `startMotionUpdates`
- `stopMotionUpdates`
- `notifyAccelleromerUpdates`
- `notifyGyroUpdates`

Accellerometer/Gyroscope
- `startUpdates`
- `stopUpdates`

Path Recording Service
- `savePath(pathData)`

#heading(level: 4, numbering: none,  outlined: false,  "Backend")

*API* \
Application Proxy – API Gateway Interface
- `userExists(email)`
- `sendVerificationCode(email)`
- `verifyCode(email, code)`
- `signup(name, email, password, code)`
- `signin(email, password)`
- `deleteAccount(email)`
- `savePath(pathData)`
- `getPaths(userId)`
- `getUserPathDetails(pathId)`
- `setPrivacyStatus(pathId, privacyStatus)`
- `deletePath(pathId)`
- `fetchPaths(startLocation, endLocation)`

*Auth I* \
User Management Service
- `userExists(email)`
- `sendVerificationCode(email)`
- `verifyCode(email, code)`
- `signup(name, email, password, code)`
- `signIn(email, password)`
- `deleteAccount(email) (authenticated)`

*Personal History I* \
Personal Paths Service
- `getPaths(userId)`
- `getUserPathDetails(pathId)`
- `setPrivacyStatus(pathId, status)`
- `deletePath(pathId)`

*Community Browsing I* \
Path Recommendation Service
- `fetchPaths(startLocation, endLocation)`

*Persistence I* \
DBMS
- `userExists(email)`
- `createAccount(name, email, password)`
- `getAccount(email)`
- `deleteAccount(email)`
- `savePath(pathData)`
- `getPaths(userId)`
- `getUserPathDetails(pathId)`
- `setPrivacyStatus(pathId, status)`
- `deletePath(pathId)`
- `queryPaths(startLocaiton, endLocation, sortPredicate)`

KV Storage
- `save(code, email, ttl)`
- `getEmail(code)`

*External Services I* \
SMTP Server
- `enqueueVerificationEmail(email, code)`

Weather API
- `getWeatherData(location, date)`

MAPS API
- `reverseGeocode(streetAddress)`
- `geocode(location)`
- `addLocationToMap(location)`
- `addPathToMap(path)`
- `hasHighways(path)`

#pagebreak()
== Selected architectural styles and patterns
*Three-Tier Architecture* \
BBP is deployed using a three-tier architecture that separates the presentation, application, and data layers into distinct tiers, enabling a clear separation of concerns. \
The presentation tier is handled by the application’s frontend, represented by the mobile BBP application running on the user’s personal device. This tier follows a fat-client model, as it’s responsible not only for rendering the user interface but also for executing supporting operations, such as collecting and preprocessing GPS and sensor data during automatic path recording. \
The application tier is implemented through a set of backend microservices that encapsulate the system’s core business logic and handle computationally intensive operations, such as path processing, recommendation, and user management.\
The data tier is responsible exclusively for data persistence and manages the storage of user accounts and bike path information.

*Microservice Architecture* \
A microservice architecture is adopted for the implementation of the application layer. \
Compared to a monolithic approach, this architectural style promotes a stronger separation of concerns and improves fault isolation, limiting the propagation of failures that could otherwise impact the entire system if deployed on a monolith. \
This architecture also enhances scalability, since each microservice can be scaled independently based on its specific workload, improving both reliability and performance.
A key advantage of this architecture is that the internal implementation of each microservice is hidden during intra-system interactions, since communication occurs exclusively through RESTful APIs, which provide technology-neutral service interfaces.

*Circuit Breakers* \
A microservice architecture allows for the adoption of circuit breakers to mediate interactions between services and to temporarily block communication when failures are detected. This mechanism improves overall system availability by increasing fault tolerance and preventing cascading failures that could render parts of the application unavailable.

*State Pattern* \
The State pattern, which is used to model objects that can change behavior based on their internal state, improving code maintainability and readability, will be applied to the obstacle detection and confirmation process, where the state of a detected obstacle determines the system’s behavior and interactions with the user interface.

*Strategy Pattern* \
The strategy pattern will be used to effectively implement path quality computation, where different strategies are used depending on whether the path is manually inserted, automatically recorded, or aggregated from community data. This allows the system to select the appropriate computation algorithm at runtime without modifying the client code.


*Observer Pattern* \
The observer pattern will be applied on the client side, where components like the Trip Statistics Manager and the Obstacle Detection Manager subscribe to a “Data Recorded” event emitted by the Sensor Data Collection Manager whenever new sensor data is available.

*MVVM* \

The Model–View–ViewModel (MVVM) architectural pattern is adopted on the client side to ensure a clear separation of concerns between the user interface and the application logic. \
Views are responsible for rendering the UI and forwarding user interactions, while ViewModels expose observable states and commands, handling navigation and presentation logic, and coordinating interactions with the underlying models and backend services. \
This architecture improves modularity, testability and maintainability. It integrates naturally with reactive and event-driven mechanisms such as the Observer pattern used for sensor data updates.

#pagebreak()
== Other design decisions

*Cloning* \
Server instances on the back-end side of the application are appropriately replicated to support scalability as network traffic increases. Each microservice is deployed as multiple independent instances, which can be distributed across different servers to improve availability and fault tolerance. \
Requests for a specific microservice are routed through a dedicated load balancer, which distributes the incoming traffic among the different service instances according to appropriate load-balancing policies. \
Infrastructure components such as the API Gateway and the load balancers can also be replicated when required by the system’s load.

*API Gateway* \
The inclusion of an API Gateway provides several advantages in a microservice-based architecture. It centralizes the handling of incoming network requests, acting as a single entry point that routes traffic to the appropriate microservices.
It also handles access token validation, reducing duplication of logic across individual services.

*Proxy and Firewall* \
Backend security is enforced through two components deployed in front of the API Gateway to protect the system from cyberattacks and data leakage. A network firewall mitigates network-level threats, such as Denial-of-Service attacks, while an application proxy provides application-level security by inspecting HTTP/S traffic and blocking malicious requests, including SQL injection attempts and application-layer denial-of-service attacks. This layered security approach can be extended in the future by introducing additional internal security controls, such as firewall between internal components.

*KV Store* \ 
A KV Store was included to handle short-lived, high-frequency data that does not require relational guarantees such as, in our case, email verification codes. Each entry is associated with a Time-To-Live (TTL), preventing stale or sensitive data from persisting beyond its intended lifetime. Using a KV Store avoids unnecessary loads on the primary relational database.

= User Interface Design
=== User Interfaces

As already stated in the RASD, Best Bike Paths will be an app for mobile devices (iOS and Android).  \
The User Interface will be optimized for touch screens and will follow their platform device guidelines (Human Interface Guidelines for iOS and Material Design for Android). Compliance with these standards ensures a consistent user experience and facilitates the implementation of accessibility best practices. \
User interaction occurs through touch input, gestures, and native UI components. \
Since the app relies on motion and location device features, the interface will include UI elements to request permission to interact with these device capabilities, following the platform-specific guidelines. \

#pagebreak()
#heading(level: 4, numbering: none,  outlined: false,  "Account Management")
When an unauthenticated user opens the app, @ui-account-management-home-unauthenticated is shown. From here the user can start browsing community bike paths, or sign into the app.

When an authenticated user opens the app @ui-account-management-home-authenticated is shown. From here the user can start browsing community bike paths, access their bike path history, add or record a new bike path.

The user can access the account page by tapping the account button, located in the trailing section of the navigation bar in both @ui-account-management-home-unauthenticated and @ui-account-management-home-authenticated. The user can also access the account page by tapping the sign in button in @ui-account-management-home-unauthenticated.

*Unauthenticated Account Page* \
If the unauthenticated user navigates to the account page a new modal replace the _Community Bike Paths_ one as shown in @ui-account-management-home-account-unhauthenticated. The user can now fill the email text field as in @ui-account-management-home-account-unhauthenticated-filled and submit. 

_Sign Up Flow_ \
If the email is not registered with an existing user account, the sign up flow starts by showing a text field for verifying the user provided email as in @ui-account-management-account-emailverification. The user fills with the received verification code as in @ui-account-management-account-emailverification-filled and submit. The sign up form in @ui-account-management-account-signup is shown and the user fills it as in @ui-account-management-account-signup-filled. After submitting the form the user is authenticated with their new account and @ui-account-management-home-authenticated is shown.

_Sign In Flow_ \
If the email is registered with an existing user account, the sign in flow starts by showing a password secure text field for verifying the user credential as in @ui-account-management-account-signin. The user fills with the account password as in @ui-account-management-account-signin-filled and submit. If the password is wrong @ui-account-management-account-signin-wrongpassword is shown. Otherwise, the user is authenticated with their account and @ui-account-management-home-authenticated is shown.

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
If the capability is available and the user never denied the authorization (from the system dialog) @ui-capability-management-requestcapability-notdetermined is shown.
Here the user can see what capability the app needs to access and why.
If the user decides to give their permission, the system dialog in @ui-capability-management-requestcapability-notdetermined-systemdialog is shown, and the user can allow the app to use the capability.
Otherwise the user can close the modal and not use the app feature.

*Denied Permission Page* \
If the capability is available and the user denied the authorization (from the system dialog) @ui-capability-management-requestcapability-denied is shown.
Here the user can see what capability the app needs to access and why.
If the user decides to give their permission, they must open settings and change the access authorization status manually. 
Otherwise the user can close the modal and not use the app feature.

*Unavailable Permission Page* \
If the capability is unavailable, @ui-capability-management-requestcapability-unavailable is shown. 
Here the user can see what capability the app needs to access and why.
The user can just close the modal and not use the app feature.

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

When the authenticated user opens the path record page a full-screen map and a modal sheet are shown.

*Idle Recording Page* \
When the recoding is idle, @ui-automatic-path-recording-pathrecording-idle is shown.  \
The map shows the user marker (and a suggested route, if it was selected before).\
The modal displays a stopwatch, the weather data (if available), and the start button. \
The recording can be started manually by the user or automatically by the app when the user starts cycling (if motion capability access is available). \

*Active Recording Page* \
When the recording is active, @ui-automatic-path-recording-pathrecording-active is shown. \
The map shows the user marker, the start marker, and the followed route (and a suggested route, if it was selected before). \
The modal shows the running stopwatch, the weather data (if available), the performance data (all of them if motion capability access is available, otherwise only distance), the pause button, and the add obstacle button. \
The recording can be paused manually by the user or automatically by the app when the user stops cycling (if motion capability access is available). \
An obstacle can be registered manually by the user or automatically by the app when the device shakes (if motion capability access is available). When an obstacle is registered, an alert notification is presented, as in @ui-automatic-path-recording-pathrecording-obstaclealert, to confirm or cancel the obstacle detection. If the notification is ignored, the obstacle detection is confirmed.

*Paused Recording Page* \
When the recording is paused, @ui-automatic-path-recording-pathrecording-paused is shown. \
The map shows the user marker, the start marker, and the followed route (and a suggested route, if it was selected before). \
The modal shows the stopwatch, the weather data (if available), the performance data (all of them if motion capability access is available, otherwise only distance), the resume button, the stop button, and the add obstacle button. \
The recording can be resumed manually by the user or automatically by the app when the user starts cycling (if motion capability access is available). \
An obstacle can be registered manually by the user. When an obstacle is registered, an alert notification is presented to confirm or cancel the obstacle detection. If the notification is ignored, the obstacle detection is confirmed.

*Stopped Recording Page* \
When the recording is paused, @ui-automatic-path-recording-pathrecording-paused is shown. \
The map shows the user marker, the start marker, the followed route and the end marker. 
The modal shows the stopwatch, the weather data (if available), the performance data (all of them if motion capability access is available, otherwise only distance), the calculated path road status, the path privacy status toggle, and the save button.


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

When the authenticated user opens the path insertion page, a full-screen map and a modal sheet are shown.

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

When the authenticated user opens the app and has at least recorded or added one path, the history page is shown as in @ui-personal-path-history-hystory.

When the user selects a path, a full-screen map and a modal sheet are shown as in @ui-personal-path-history-history-detail and @ui-personal-path-history-history-detail-fullscreen. \
The map shows the path route, the start marker, the end marker, and, if the path was added manually, all the markers of the locations provided by the user composing the route. \
The modal shows all the available path information, the path route status stepper (if the path was manually added), the path privacy status toggle, the "Record New Path" button, and the delete button. \
When the user edits the path information (with the toggle or the stepper), the confirm button on the trailing section of the modal navigation bar is enabled, as in @ui-personal-path-history-history-detail-edited. \
When the user starts a new path from here, a bike path recording session begins, with the selected path displayed on the map as a suggested route for the user to follow. \
If the path is not optimal for biking (e.g., it contains a highway), an alert is displayed.

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

When the user is on the home page and presses on the search bar of the _Community Bike Paths_ modal, a full-screen map is shown, as in @ui-community-paths-browsing-browsing-focused.

The user enters a start location, as in @ui-community-paths-browsing-browsing-startentered. The map shows the start marker. \

The user enters an end location, as in @ui-community-paths-browsing-browsing-endentered. The map shows the start and end markers, and the confirm button on the trailing section of the modal navigation bar is enabled.

*Community Path List Page* \
After the user taps the confirm button, the app loads their results in a list, ranked by a path quality score, as in @ui-community-paths-browsing-browsing-list. \
The list rows display the path route in the map, its quality score, and, if the path is not optimal for biking (e.g., it contains a highway), an alert is shown.
When the user selects a path row, the full-screen map shows the path, and the confirm button on the trailing section of the modal navigation bar is enabled.

*Community Path Detail Page* \
When the user taps the confirm button, a modal sheet is shown as in @ui-community-paths-browsing-browsing-detail-authenticated if the user is authenticated, or in @ui-community-paths-browsing-browsing-detail-unauthenticated if the user is unauthenticated. \
The map shows the path route, the start marker, the end marker, and, if the path was added manually, all the markers of the locations provided by the user composing it. \
The modal shows all the publicly available path information, and, if the user is authenticated, the "Record New Path" button. \
When the user starts a new path from here, a bike path recording session begins, with the selected path displayed on the map as a suggested route for the user to follow.
If the path is not optimal for biking (e.g., it contains a highway), an alert is shown.


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
#heading(level: 4, numbering: none,  outlined: false,  "Account Management")

*R1*: The system shall allow an unauthenticated user to create an account. \
This requirement is fulfilled by the _Mobile App_, which provides the user with the necessary interface for account credential submission, the _User Management Service_, which communicates with the _DBMS_ for the creation of an account, the _KV Store_ to temporarily store the email verification code, and the _SMTP Server_, which sends the email verification code to confirm the user’s identity. \


*R2:* The system shall allow an unauthenticated user to sign into the app. \
This requirement is fulfilled by the _Mobile App_, which provides the user with the necessary interface for account credential submission, and the _User Management Service_, which communicates with the _DBMS_ to verify account ownership and to create the necessary access tokens for authentication. \
*R3*: The system shall allow an authenticated user to sign out from the app. \
This requirement is fulfilled by the _Mobile App_, which provides the user with the necessary interface for signing out of their account. \

*R4*: The system shall allow an authenticated user to delete their account. \
This requirement is fulfilled by the _Mobile App_, which provides the user with the necessary interface for account credential submission, and the _User Management Service_, which communicates with the _DBMS_ to eliminate all data associated with the account. \

#heading(level: 4, numbering: none,  outlined: false,  "Permission Management")

*R5*: The system shall request the user’s permission to use a device capability. \
This requirement is fulfilled by the _Mobile App_, which provides the user with the interface for granting the application with  the necessary privileges for accessing device capabilities, and the _Permission Manager_, which checks with the _Capability Providers_ which permissions have already been granted by the user. \

*R6*: The system shall properly handle user permission denial. \
This requirement is fulfilled by the _Mobile App_, which provides the user with the interface for manually granting permissions regarding device capabilities, and the _Permission Manager_, which checks with the _Capability Providers_ which permissions have already been granted by the user. \

#heading(level: 4, numbering: none,  outlined: false,  "Automatic Bike Path Recording")

*Start Recording* \

*R7*: The system shall allow the authenticated user to start the automatic recording mode of a bike path. \
This requirement is fulfilled by the _Mobile App_, which provides the user with the interface for starting an automatic recording session. \

*R8*: The system shall use the GPS to track the user’s real-time position during the trip. \
This requirement is fulfilled by the _Sensor Data Collection Manager_, which interacts with the _GPS API_ for collecting the user’s location data. \

*R9*: The system shall use the device’s sensors to collect information about obstacles along the path and the speed of the user. \
This requirement is fulfilled by the _Sensor Data Collection Manager_, which interacts with the _Gyroscope_ and _Accelerometer_ APIs for collecting the user’s motion data, the _Obstacle Detection Manager_, which analyzes the incoming data to determine whether an obstacle was encountered, and the _Trip Statistics Manager_, which computes real-time statistics about the trip based on the collected data.

*R10*: The system shall display the current trip data (current duration time, map of the path, average speed, top speed, weather conditions, distance covered) while the user is biking. \
This requirement is fulfilled by the _Mobile App_, which displays the information about the current trip, the _Map Service_, which geocodes locations and displays the path map to the user, the _Sensor Data Collection Manager_, which collects motion and location data from the device’s sensors, the _Trip Statistics Manager_, which computes real-time statistics about the trip based on the collected data, and  the _Weather Service_, which provides meteorological data about the trip.

*R11*: The system shall prompt the user for confirmation of a detected obstacle while biking. \
This requirement is fulfilled by the _Mobile App_, which visually notifies the user when an obstacle has been detected, the _Sensor Data Collection Manager_, which collects motion data during the trip, and the _Obstacle Detection Manager_,  which computes real-time statistics about the trip based on the collected data.

*R12*: The system shall allow the authenticated user to insert an obstacle manually.
This requirement is fulfilled by the _Mobile App_, which allows the user to manually insert an obstacle by interacting with the UI during the recording session.

*Stop Recording* \

*R13*: The system shall allow the authenticated user to manually stop the automatic recording of a bike path. \ 
This requirement is fulfilled by the _Mobile App_, which allows the user to stop the recording session  by interacting with the UI.

*R14*: The system shall stop collecting GPS data once the authenticated user selects “Stop Recording”. 
This requirement is fulfilled by the _Mobile App_, which allows the user to stop the recording session  by interacting with the UI, and the _Sensor Data Collection Manager_, which terminates the collection of sensor data once the session ends.

*R15*: The system shall stop collecting sensor data once the authenticated user selects “Stop Recording”. \
This requirement is fulfilled by the _Mobile App_, which allows the user to stop the recording session  by interacting with the UI, and the _Sensor Data Collection Manager_, which terminates the collection of sensor data once the session ends.

*R16*: The system shall compute the status for the recorded path based on the frequency of obstacles. \
This requirement is fulfilled by the _Personal Paths Service_, which retrieves the user’s paths aloong with their quality status which, for automatically recorded paths, is computed according to the obstacle frequency, and the _Obstacle Detection Manager_, which detects obstacles during the recording of a trip, the _Trip Statistics Manager_, which calculates the total travelled distance,, the _Sensor Data Collection Manager_, which collects motion data during the trip, and the _Mobile App_, which allows the user to manually insert obstacles.

*R17*: The system shall store the path and its associated status in the authenticated user’s personal history. \
This requirement is fulfilled by the _Path Recording Service_, which stores the incoming paths in the _DBMS_.

*R18*: The system shall cancel the recording if the accuracy of the GPS data drops under a certain threshold (over 10 meters for more than 15 seconds). \
This requirement is fulfilled by the _Sensor Data Collection Manager_, which collects motion and location data during the trip and verifies its accuracy .

*Pause and Resume* \

*R19*: The system shall automatically pause recording when the authenticated user stops biking. \
This requirement is fulfilled by the _Mobile App_, which displays a paused timer when the user opens the application while the session is paused, the _Trip Statistics Manager_, which calculates the speed of the user to determine whether the user has stopped biking, and the _Sensor Data Collection Manager_, which collects motion data during the trip. 

*R20*: The system shall automatically resume recording when the authenticated user starts biking. \
This requirement is fulfilled by the _Mobile App_, which resumes the paused timer when the user starts biking, and the _Sensor Data Collection Manager_, which collects motion data during the trip and determines whether the user is cycling or not. 

*R21*: The system shall allow the user to manually pause the recording. \
The requirement is fulfilled by the _Mobile App_, which allows the user to manually pause the recording session.

*R22*: The system shall allow the user to manually resume the recording. \
The requirement is fulfilled by the _Mobile App_, which allows the user to manually resume the recording session.

#heading(level: 4, numbering: none,  outlined: false,  "Manual Bike Path Insertion")

*R23:*The system shall allow the authenticated user to manually create a path by inserting a starting point, destination, intermediary stops and defining privacy and a quality status. \
This requirement is fulfilled by the _Mobile App_, which allows the user to manually create a path by interacting with the UI, the _Map Service_, which geocodes locations and displays the path map to the user, and the _Path Recording Service_, which collects the incoming path data and stores it in the _DBMS_.

#heading(level: 4, numbering: none,  outlined: false,  "Personal History Management")

*User Bike Path List* \
*R24*: The system shall display a list of the user’s previously recorded paths in chronological order when accessing their history page. \
This requirement is fulfilled by the _Mobile App_, which displays the user’s paths, the _Personal Paths Service_, which retrieves all the path data associated with the user’s account, and the _Map Service_, which geocodes locations and displays the path map to the user.

*User Bike Path Detail* \
*R25*: The system shall display all the collected data of a personal path when the user visits its dedicated page. \
This requirement is fulfilled by the _Mobile App_, which displays detailed information of a path after the user navigates to the corresponding page, the _Personal Paths Service_, which retrieves detailed information about one of the user’s paths, and the _Map Service_, which geocodes locations and displays the path map to the user.

*R26*: The system shall allow the user to set the privacy status of the path. \
This requirement is fulfilled by the _Mobile App_, which displays the option to change the privacy status of a path, and the _Personal Paths Service_, which updates the path’s privacy status in the _DBMS_..

*R27*: The system shall allow the user to delete their personal bike paths. \
This requirement is fulfilled by the _Mobile App_, which displays the option to delete one of the user’s personal paths, and the _Personal Paths Service_, which removes all data associated with the path from the _DBMS_.

#heading(level: 4, numbering: none,  outlined: false,  "Community Bike Path Browsing")

*R28*: The system shall allow the user to browse publicly available bike paths by specifying a starting point and a destination. \
This requirement is satisfied by the _Mobile App_, which displays the community paths on a map along with relevant data about their overall quality, the _Path Recommendation Service_, which creates a list of paths with the same starting point and destination specified by the user,  and the _Map Service_, which geocodes locations and displays the path map to the user.

*R29*: The system shall show the user the matching paths, sorting them by their system-computed average quality score (calculated based on the public user path instances). \
This requirement is satisfied by the _Mobile App_, which displays the community paths on a map along with relevant data about their overall quality, the _Path Recommendation Service_, which computes the aggregated quality score of a path based on the paths submitted by other users, specifically considering the frequency of obstacles along the paths and the recency of the collected data, and the _Map Service_, which geocodes locations and displays the path map to the user.

*R30*: The system shall display for each path the route map along with the system-computed quality score. \
This requirement is fulfilled by the _Mobile App_, which displays the paths on a map along with their quality score, the _Map Service_, which geocodes locations and displays the path map to the user, and the _Path Recommendation Service_, which computes the overall quality of each path.

*R31*: The system should display an alert badge if a path contains incompatible roads for biking. \
This requirement is fulfilled by the _Mobile App_, which displays a badge next to a path containing roads incompatible with biking, and the _Map Service_  which indicates whether a road segment within a path is classified as a highway. \

*R32*: The system shall allow the user to select a path as the suggested route for a new automatic recording session. \
This requirement is fulfilled by the _Mobile App_, which displays to the authenticated user the option to add a path as the suggested route during an automatic recording session, and the _Map Service_, which geocodes locations and displays the path map to the user. \

= Implementation, Integration And Test Plan

== Overview
This section outlines the implementation and testing strategies that will be adopted to deploy the previously described software architecture and verify the correctness of its main functionalities. \
For the integration of BBP’s core modules, a bottom-up testing strategy will be employed. This strategy involves progressively integrating software components and executing relevant tests to verify the overall stability of the subsystem, allowing for more precise identification of errors.  \

Initially, the components tested in isolation will be those considered less structurally complex and more straightforward in terms of functionality. Their execution and testing will be supported by corresponding drivers that will simulate the necessary dependencies of the tested component. A more detailed description, accompanied by visual diagrams showcasing the testing sequence, will be provided in the following pages. \

The implementation of the BBP software components is assigned to a development team of appropriate size, organized into subgroups of varying sizes and specialties according to the components they are responsible for. Further details regarding workload distribution will be provided in subsequent sections. \

#pagebreak()
== Implementation Plan

The implementation of the BBP system is based on the ISO/IEC/IEEE 24748-8 standard, which establishes the requirements for the application of Agile principles within a formal life cycle management framework.

In accordance with ISO/IEC/IEEE 24748-8, the BBP development follows an iterative and incremental life cycle, where the system is realized through a sequence of short development cycles. Each cycle produces a potentially usable increment of the system. This enables continuous verification of requirements, early stakeholder feedback, and progressive refinement.

The implementation strategy combines a thread-based approach, aligned with Agile feature delivery, and a bottom-up integration strategy, as recommended by the standard for managing technical complexity. Feature threads are defined based on the system’s core capabilities (Account Management, Permission Management, Automatic Bike Path Recording, Manual Bike Path Insertion, Personal Hystory Management, Community Bike Path Browsing), each spanning multiple architectural components such as the mobile frontend, sensor management layer, backend services, and data persistence. This ensures that each increment delivers complete functionality rather than isolated components.

At the same time, a bottom-up approach is employed for the realization and integration of shared and low-level components, for example data models, sensor abstractions, persistence mechanisms, shared UI elements.
These components are implemented and validated early, providing a stable foundation for higher-level feature threads and facilitating integration and testing.

This hybrid strategy is consistent with ISO/IEC/IEEE 24748-8 and supports parallel development activities. Shared components are identified at the beginning of the life cycle to prevent duplication, while iterative integration and continuous testing ensure early detection of defects and controlled system evolution.


#let implementationGanttDiagram = ```plantuml
@startgantt
Project starts 2025-12-3
' printscale weekly
[Requirements Analysis and Specification] as [T1] requires 20 days
[T1] ends 2025-12-23
[Design] as [T2] requires 20 days
[T2] starts 5 days before [T1]'s end
[T2] ends 2026-01-07
[Implementation] as [T3] requires 20 days
[T3] starts 5 days before [T2]'s end
[T3] ends 2026-02-01
[Testing] as [T4] requires 7 days
[T4] starts at [T3]'s end
[T4] ends 2026-02-08
-- Implementation --
[Core Infrastructure] as [I1] requires 9 days and is colored in LightBlue
[I1] starts at [T3]'s start
[Account Management] as [I2] requires 15 days and is colored in LightBlue
[I2] starts at [I1]'s end
[Permission Management] as [I3] requires 15 days and is colored in LightBlue
[I3] starts at [I1]'s end
[Automatic Bike Path Recording] as [I4] requires 15 days and is colored in LightBlue
[I4] starts at [I1]'s end
[Manual Bike Path Insertion] as [I5] requires 15 days and is colored in LightBlue
[I5] starts at [I1]'s end
[Personal Hystory Management] as [I6] requires 15 days and is colored in LightBlue
[I6] starts at [I1]'s end
[Community Bike Path Browsing] as [I7] requires 15 days and is colored in LightBlue
[I7] starts at [I1]'s end
[Unit Testing] as [I8] requires 8 days and is colored in LightBlue
[I8] starts 2 days before [I2]'s end
[I8] starts 2 days before [I3]'s end
[I8] starts 2 days before [I4]'s end
[I8] starts 2 days before [I5]'s end
[I8] starts 2 days before [I6]'s end
[I8] starts 2 days before [I7]'s end
@endgantt
```
#figure(
  implementationGanttDiagram,
  kind: image,
  caption: [Implementation Plan Gantt Diagram]
)

=== Features identification
The following section provides a brief overview of the main features offered by the BBP application, which will be properly implemented and tested. These functionalities are essential for achieving the objectives previously defined and for translating the requirements outlined in the associated Requirements and Specifications Document into a concrete, functional system. \

#heading(level: 4, numbering: none,  outlined: false,  "Account Management")

*Account Registration* \
When users first download the BBP application, they will be greeted with a Sign-up/Sign-in page since they don’t currently have an active authenticated session with the backend.
The Sign-up feature allows users to register a personal account within BBP by inputting a valid username, password, and email. The latter will be used to verify the authenticity of the user by sending a one-time verification code that must be inserted by the user to complete the account creation process. \

*Sign-in* \
If the user already possesses an account but doesn't have a valid session, they may select the Sign-in option, allowing the user to insert their credentials, specifically username and password, and to obtain a new access token, thereby authenticating the users within BBP’s backend servers. \

*Account Deletion* \
The application also allows users to delete their account and all associated data by navigating to their profile page and selecting the corresponding “Delete Account” option. Once the user gives manual confirmation, all personal data, as well as bike path information, both public and private, will be permanently deleted from the BBP database. \

#heading(level: 4, numbering: none,  outlined: false,  "Permission Management")

*Permission Management* \
BBP will prompt the user to obtain the required permissions to access the device’s full capabilities, specifically GPS, motion sensors, and notifications. When confirmation is given, the app will be able to read the necessary information for recording bike paths during an automatic session and also send notifications about paused or cancelled recordings, as well as the detection of obstacles along the followed path. \

#heading(level: 4, numbering: none,  outlined: false,  "Automatic Bike Path Recording")

*Automatic Recording* \
This feature allows users to initiate automatic recording sessions during which the application collects relevant motion and location data related to their bike trips. During a session, the application may transition between different states based on the interpretation of the collected data. For example, a session is automatically cancelled if the GPS data is deemed too inaccurate to reliably reconstruct the route, or it may be temporarily paused when the user’s velocity falls below a predefined threshold or when manually paused by the user. \
Throughout the trip, the device detects obstacles along the path by analyzing data collected from the accelerometer and gyroscope. This information is essential for assessing the quality of the bike path. \
Once the recording session ends, the collected data is processed and stored in the database, and all relevant performance statistics are made available in the corresponding section of the application. \

#heading(level: 4, numbering: none,  outlined: false,  "Manual Bike Path Insertion")

*Manual Insertion* \
This feature allows users to manually add paths after selecting the corresponding option inside their personal history page. Users can specify a start and destination, a series of intermediary points, and a quality status (e.g., Impassable, Bad, Fair, Good, Optimal). Once all the required data is inserted, the path will be saved in the database and can then be viewed by the user in the corresponding section. \

#heading(level: 4, numbering: none,  outlined: false,  "Personal History Management")
*Personal Path Browsing* \
The application allows authenticated users to access a dedicated history page where their recorded bike paths are displayed. This page presents a chronological list of paths that have been either manually inserted or automatically recorded by the device. Each entry is visualized on a map and accompanied by essential information such as the recording date, total distance, and trip duration.
When a path is selected, the application displays a detailed view containing additional metrics (if available), including average speed, maximum speed, total active time, meteorological data, and overall path quality. From this view, users may also choose to set the visibility of the bike path to public or private, as well as delete the path from the database. \

*Bike Path Deletion* \
The app allows its users to delete their own personal bike paths at their discretion. In order to delete a personal bike path, the user must navigate to their history page and select the path they wish to delete. When selected, a detailed view of the path will be displayed, as well as the option to delete it.  Once deleted, the path is permanently eliminated from the database. \

*Privacy State Toggle* \
This feature allows users to control the privacy status of their personal bike paths. This option can be accessed within the detailed view of a specific bike path. When switched to public, the path can be viewed by other users when browsing for paths with the same origin and destination, and the collected data will be used to compute the overall quality of the path itself. \

#heading(level: 4, numbering: none,  outlined: false,  "Community Bike Path Browsing")

*Browsing* \
Both authenticated and unauthenticated users can access the browsing functionality offered by the BBP application by navigating to the browsing page, where they can input a starting point and destination to view the best possible paths that connect the two points, along with their rank and score. \

== Component Integration and Testing 

== System Testing 
System testing is performed to validate that the BBP system, considered as a whole, satisfies the requirements defined in the RASD. \

At this level, the system is treated as a black box, and testing focuses on the externally observable behavior resulting from user interactions with the Mobile App. \
System tests are derived from the use cases described in the RASD and verify the correct execution of complete end-to-end scenarios, from the mobile client to the back-end services and back. The objective is to ensure that the system behaves as expected under normal operating conditions. \
In particular, system testing verifies that: \
- users can correctly register, authenticate, sign out, and delete their accounts; \
- required device permissions are properly requested and enforced; \
- automatic bike path recording can be started, paused, resumed, and stopped, and that recordings are cancelled when sensor reliability constraints are violated; \
- manually inserted paths are correctly submitted and stored; \
- users can retrieve, manage, and delete their personal bike paths; \
- community bike paths can be searched, visualized, and are reported as incompatible when necessary. \
In addition to functional behavior, system testing also verifies constraints implicitly defined by the requirements, such as correct authorization handling, safe management of invalid or incomplete data, and consistent system behavior during common user interactions. \
System testing is considered successful when all behaviors defined in the RASD are correctly supported at system level and no critical failures are observed during end-to-end execution. \



== Additional Specifications on Testing 
This section provides additional remarks related to system testing activities. These considerations do not introduce new requirements, but clarify how testing supports the validation of the behaviors defined in the RASD. \

System testing is conducted using representative test data, including valid and invalid credentials, realistic bike path data, and different device permission configurations. This allows the verification of both normal execution scenarios and boundary conditions that may occur during typical usage. \
Testing also verifies that the system correctly handles incomplete or invalid situations, such as interrupted recording sessions or denied permissions, and that such conditions do not lead to the persistence of inconsistent data. \
Basic security aspects implied by the requirements are considered during testing, in particular to ensure that protected functionalities are accessible only to authenticated users. \

All testing activities are performed at system level, treating the system as a black box and without making assumptions on internal implementation details. \

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


