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
The purpose of this document is to verify the acceptability of the other group’s implementation of the BBP project through a series of acceptance tests.
In particular, this document describes the acceptance testing activities performed on the project and reports the results of each test, with the aim of identifying potential bugs in the code and any inconsistencies with respect to the project description provided in the Requirements Analysis and Specification Document and the Design Document.

== Scope
The testing activities primarily focus on verifying the interaction between the frontend and backend services of the project (specifically the storage and retrieval of data from the database, authentication mechanisms, internal business logic, and the use of external libraries) in relation to the requirements implemented according to the _ITv1_ document.
The tests are performed on the implemented application functions after following the installation instructions outlined in the _ITDv1_ document available in the corresponding GitHub repository.
These testing activities do not include frontend user interface testing; however, some observations regarding potential interface improvements are included within the relevant test cases.
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
4. *Acceptance Testing*: The executed test cases derived from the RASD requirements and the implemented features.
5. *Quality Assessment*: An evaluative section focusing on the overall quality of the project.
6. *Effort spent*: Includes the amount of time dedicated by each member to the realization of each section of the document.
7. *References*: Reference to documents or tools used for writing this document.


= Project Identification
This section details the acceptance testing and quality assessment performed on the BBP application. The analysis is based on the artifacts and documentation provided by the development team.

== Authors
The project was designed and implemented by:
- *Alice Berta*
- *Francesco Danese*

== Repository
The source code, along with deployment scripts and configuration files, is hosted at the following URL: 
#link("https://github.com/fradane/DaneseBerta")

== Reference Documents
The testing strategy and verification criteria were derived from the following deliverables:
- *Requirements Analysis and Specification Document (RASD)* - Version 2.0
- *Design Document (DD)* - Version 2.0
- *Implementation and Test Document (ITD)* - Version 1.0


= Installation Setup
This section describes the procedure followed to deploy the testing environment. The installation was performed strictly adhering to the instructions provided in *Chapter 6* of the *ITD*.

== Installation Procedure
The system was set up in a hybrid environment to simulate a realistic usage scenario:
- *Server-side*: The backend microservices were deployed using *Docker Compose* on a local machine, ensuring isolation and dependency management as recommended in ITD Section 6.1.
- *Client-side*: The mobile application was compiled and installed on two distinct targets:
  1. *iOS Simulator* for rapid functional testing.
  2. *Physical Device* for real-world evaluation.


= Acceptance Testing
This chapter details the User Acceptance Testing (UAT) activities performed on the BBP application. The test suite was designed based on the Functional Requirements specified in the *RASD (v2.0)*, while strictly adhering to the implementation scope defined in the *ITD (v1.0)*.

Consequently, features explicitly marked as "Not Implemented" in the ITD (such as Password Reset or Automatic Trip Recording) were excluded from this verification phase. The primary goal was to validate the software against the delivered specifications and ensure robustness in the implemented flows.

== Test Environment & Preconditions
Unless otherwise specified in the individual test cases, the following baseline environment is assumed:
- *Client*: Mobile Application running on an iOS device (physical or simulated) via Flutter engine.
- *Server*: Backend Microservices (Account, Trip, Path) deployed and running via Docker containers.
- *Connectivity*: Active internet connection for external API access (OpenStreetMap, OpenMeteo).

== Acceptance Test Cases
=== Test Cases Overview
This section describes the manual testing activities carried out on the BestBikePath mobile application. The goal of this phase was to check whether the system behaves as expected with respect to the requirements defined in the RASD and ITD. Testing also helped highlight functional limitations and partially implemented features in the current version of the app. \
Testing was carried out manually on the iOS simulator running on macOS and physical device (iPhone). Each session began from a fresh app installation, with no stored user data. \
The application was used exclusively through its graphical interface, following realistic user interactions. \
=== Scope of Testing
- Testing covered the following functional areas:
- Application startup and overall stability \
- Authentication and account management (login, signup, logout, account deletion) \
- Session handling and permission management \
- Map visualization and path search \
- Manual trip creation and validation \
- Trip storage and visualization \
- Trip publishing and visibility management \
- Profile-related features and user settings \
- Error handling and crash behavior \
- Whenever applicable, both registered and non-registered user flows were tested. \
=== Test cases 
*Authentication and Account Management* \
Authentication tests focused on access control and credential handling. Password rules are enforced correctly. Email comparison is case-insensitive, while usernames remain case-sensitive. Account creation works as expected, and duplicate identifiers are correctly rejected. \
Login currently works only via email, even though the interface suggests support for usernames. Session persistence across app restarts is not supported. Login after logout is unstable. Account deletion is visible in the UI but does not function in the tested build. These issues were recorded as failed or partially implemented. \

*Permissions and Location Handling* \
Location permissions are requested correctly when needed. The app remains usable even if permission is denied. Manual interaction with the map is still allowed, including setting start and destination points. \
Changes to the simulator’s GPS position are not reflected in real time inside the app. This was not treated as a failure, since simulator GPS behavior is platform-dependent and not explicitly required. \

*Map and Path Search Functionality* \
Map rendering works correctly. Basic navigation and marker placement are responsive. Path search can be triggered, but no valid routes are returned in the tested scenarios, even with manually selected points. This was classified as a failure, as route computation is a core system feature. \
Advanced map features, such as zooming and search, are limited or non-functional and were documented accordingly. \

*Trip Recording and Management* \
Manual trip recording was tested using metadata such as time, speed, status, and path segments. Trip creation and visualization in the My Trips section work under normal conditions. \
Stability issues appear when trips include multiple segments. Adding several points often causes crashes or forces a logout. In some cases, trips fail to save without clear feedback. Automatic trip recording was not observed and is considered not implemented. \

*Trip Visualization, Publishing, and Weather Data* \
Saved trips appear correctly in the trip list, and detail views are accessible. Publishing via long-press interaction works. Published trips cannot be reverted to private status, which was noted as a limitation. \
Weather data is shown for some trips but not consistently. Since this depends on external services, partial availability was considered acceptable. \

*Stability and Error Handling* \
The application starts reliably and handles most interactions without crashing. However, several reproducible crashes were observed, mainly during complex trip recording. Error messages are present but often lack detail. All unstable behaviors were documented in the corresponding test cases. \

*Limitations of Testing* \
Testing was manual and focused on functional behavior. Performance and security were not evaluated. Simulator-specific behaviors were considered only when relevant to application logic. Missing or incomplete features were documented as such. \

*Conclusion* \
Testing validated the main user flows and exposed several functional and stability issues. Core features like registration, manual trip creation, and trip visualization work correctly. Other areas, especially path computation, session persistence, and automated recording, are incomplete or non-functional. All findings were documented to ensure traceability and transparency. \

*AT1: Application startup*
- Precondition: Application is installed on the device or simulator
- Action: Launch the application
- Expected result: The application opens correctly without crashing
- Requirements verified: R1
- Outcome: _Passed_

*AT2: Initial screen availability*
- Precondition: Application is running
- Action: Observe the first screen after startup
- Expected result: Login, Sign up, and Search Path options are visible
- Requirements verified: R1, R2
- Outcome:  _Passed_

*AT3: Navigation between authentication screens*
- Precondition: Application is on the initial screen
- Action: Navigate between Login, Sign up, and Search Path screens
- Expected result: Navigation works correctly in both directions
- Requirements verified: R2
- Outcome:  _Passed_

*AT4: Login with valid email and password*
- Precondition: User account exists
- Action: Enter correct email and password and attempt login
- Expected result: User is authenticated and redirected to home screen
- Requirements verified: R3
- Outcome: _Failed_
- Defect Description:
Valid Credential Rejection: The authentication mechanism rejects valid email–password combinations and displays the same error notification used for invalid credentials.
- Observation:
The failure is consistently reproducible across multiple accounts and sessions. The issue does not depend on input format or credential correctness, suggesting a defect in authentication request handling or backend response processing.

*AT5: Login with invalid credentials*
- Precondition: User account exists
- Action: Enter wrong email or password
- Expected result: Error notification is shown
- Requirements verified: R3
- Outcome:  _Passed_

*AT6: Login using username instead of email*
- Precondition: User account exists
- Action: Enter username instead of email during login
- Expected result: User can authenticate successfully
- Requirements verified: R3
- Outcome: _Failed_
- Defect Description:
Unsupported Username-Based Authentication: The login interface accepts a username as input; however, authentication requests using a username are not processed successfully.
- Observation:
Authentication succeeds only when an email is provided. This indicates a mismatch between the user interface design and the supported backend authentication mechanism.

*AT7: Email case insensitivity*
- Precondition: User account exists
- Action: Login using the same email with different letter casing
- Expected result: Authentication succeeds
- Requirements verified: R3
- Outcome:  _Passed_

*AT8: Username case sensitivity*
- Precondition: User account exists
- Action: Attempt login using username with different casing
- Expected result: Authentication fails
- Requirements verified: R3
- Outcome:  _Passed_

*AT9: Password length validation*
- Precondition: User is on Sign up screen
- Action: Enter a password shorter than 8 characters
- Expected result: Signup is rejected with validation error
- Requirements verified: R4
- Outcome:  _Passed_

*AT10: Signup with new credentials*
- Precondition: No existing account with given credentials
- Action: Sign up with new email and username
- Expected result: Account is created and user is logged in
- Requirements verified: R4
- Outcome:  _Passed_

*AT11: Signup with existing email or username*
- Precondition: Account already exists
- Action: Attempt signup using existing email or username
- Expected result: Signup is rejected
- Requirements verified: R4
- Outcome:  _Passed_ 

*AT12: Session persistence after app restart*
- Precondition: User is logged in
- Action: Close and reopen the application
- Expected result: User remains logged in
- Requirements verified: R5
- Outcome: _Failed_
- Defect Description:
Missing Authentication State Persistence: The application does not preserve the authenticated session after being closed and reopened.
- Observation:
The user is always redirected to the login screen after restarting the application. This behavior suggests that authentication tokens or session data are not persisted locally.

*AT13: Logout functionality*
- Precondition: User is logged in
- Action: Perform logout
- Expected result: User is redirected to login screen
- Requirements verified: R5
- Outcome:  _Passed_

*AT14: Login after logout*
- Precondition: User has logged out
- Action: Attempt login again with valid credentials
- Expected result: User is authenticated successfully
- Requirements verified: R5
- Outcome: _Failed_
- Defect Description:
Broken Re-authentication Flow: After a successful logout, the system fails to authenticate the same user again using valid credentials.
-  Observation:
The issue is reproducible immediately after logout and persists until the application is restarted, indicating improper cleanup or invalidation of authentication state.

*AT15: Delete account*
- Precondition: User is logged in
- Action: Select delete account option
- Expected result: Account is removed and cannot be used again
- Requirements verified: R6
- Outcome: _Failed_
- Defect Description:
Non-operational Account Deletion: The delete account option is available in the user interface but does not result in the removal of the user account.
- Observation:
After invoking account deletion, the account remains usable and accessible. This suggests that the feature is either not implemented or not connected to backend account management logic.

*AT16: Location permission request*
- Precondition: User accesses map or search path
- Action: Deny and allow location permission
- Expected result: Permission request is shown correctly
- Requirements verified: R7
- Outcome:  _Passed_

*AT17: Map visualization*
- Precondition: Map screen is opened
- Action: Observe map rendering
- Expected result: Map loads correctly and is responsive
- Requirements verified: R7
- Outcome:  _Passed_

*AT18: Path search computation* 
- Precondition: Start and destination points are selected
- Action: Perform path search
- Expected result: A valid path is returned
- Requirements verified: R8
- Outcome: _Failed_
- Defect Description:
Route Generation Failure: The path search functionality fails to compute and return any valid route between selected start and destination points.
- Observation:
The failure occurs consistently regardless of the selected locations. This indicates an issue in the path computation component or its dependency on backend routing services.

*AT19: Manual trip creation*
- Precondition: User is logged in
- Action: Create a trip manually with valid data
- Expected result: Trip is saved successfully
- Requirements verified: R9
- Outcome:  _Passed_

*AT20: Manual trip validation*
- Precondition: User is creating a trip
- Action: Insert invalid values (negative speed, missing fields)
- Expected result: Trip is not saved and error is shown
- Requirements verified: R9
- Outcome: _Partially Passed_
- Defect Description:
Incomplete Input Validation for Manual Trips: Some invalid or inconsistent trip data is accepted during manual trip creation.
- Observation:
While basic validation exists, edge cases (such as inconsistent segment data) are not reliably detected, leading to unstable behavior rather than explicit validation errors.

*AT21: Stability with multiple trip segments*
- Precondition: User is recording a manual trip
- Action: Add more than five path segments
- Expected result: Application remains stable
- Requirements verified: R9
- Outcome: _Failed_
- Defect Description:
Application Instability Under Complex Trip Input: Creating a manual trip with multiple path segments leads to application crashes or forced navigation to the login screen.
- Observation:
The crash occurs after exceeding a limited number of segments and is reproducible. This suggests inadequate handling of complex trip data or memory/state management issues.

*AT22: View saved trips*
- Precondition: User has saved trips
- Action: Open My Trips screen
- Expected result: All saved trips are displayed
- Requirements verified: R10
- Outcome:  _Passed_

*AT23: View trip details*
- Precondition: Saved trip exists
- Action: Select a trip from My Trips
- Expected result: Trip details are shown correctly
- Requirements verified: R10
- Outcome:  _Passed_

*AT24: Publish trip*
- Precondition: User owns a saved trip
- Action: Publish the trip via long press
- Expected result: Trip becomes public
- Requirements verified: R11
- Outcome:  _Passed_

*AT25: Unpublish trip*
- Precondition: Trip is published
- Action: Attempt to make trip private again
- Expected result: Trip visibility can be reverted
- Requirements verified: R11
- Outcome: _Failed_
- Defect Description:
Irreversible Trip Publication: Once a trip is published, there is no available mechanism to revert its visibility to private.
- Observation:
The limitation is consistent across all tested trips and appears to be a missing feature rather than an intermittent malfunction.

*AT26: Automatic trip recording*
- Precondition: Automated mode is enabled
- Action: Move with application running
- Expected result: Trip is recorded automatically
- Requirements verified: R12
- Outcome: _Failed_
- Defect Description:
Missing Automatic Trip Recording Functionality: Automatic trip recording does not start when the automated mode is enabled.
- Observation:
No automatic recording behavior is observed under any tested condition, indicating that the functionality is not implemented in the current build.

*AT27: Automated mode toggle persistence*
- Precondition: User toggles automated mode
- Action: Restart application
- Expected result: Toggle state is preserved
- Requirements verified: R12
- Outcome: _Failed_
-  Defect Description:
Non-persistent Automated Mode State: The automated mode toggle does not retain its state across user sessions or application restarts.
- Observation:
The toggle always resets to its default state, suggesting that its value is not stored or restored during application initialization.

*AT28: Background execution*
- Precondition: Application is running
- Action: Send app to background and return
- Expected result: Application continues functioning correctly
- Requirements verified: R13
- Outcome: _Partially Passed_
- Defect Description:
Limited Background Operation Support: The application does not provide reliable behavior when running in the background for extended periods.
- Observation:
Short background execution appears functional, but longer background operation was not consistently verifiable, indicating partial support rather than full compliance.

*AT29: Error handling and crash recovery*
- Precondition: Known crash scenario occurs
- Action: Relaunch application after crash
- Expected result: Application starts normally
- Requirements verified: R14
- Outcome:  _Passed_

*AT30: Login with empty email field*
- Precondition: Application is on the Login screen
- Action: Leave the email field empty and enter a password, then press Login
- Expected result: Login is rejected and an error notification is shown
- Requirements verified: R3
- Outcome:  _Passed_

*AT31: Login with empty password field*
- Precondition: Application is on the Login screen
- Action: Enter a valid email and leave the password field empty, then press Login
- Expected result: Login is rejected and an error notification is shown
- Requirements verified: R3
- Outcome:  _Passed_

*AT32: Signup with empty mandatory fields*
- Precondition: Application is on the Sign up screen
- Action: Attempt signup leaving one or more mandatory fields empty
- Expected result: Signup is rejected and validation feedback is shown
- Requirements verified: R4
- Outcome:  _Passed_

*AT33: Consistency of login error notifications*
- Precondition: User account exists
- Action: Perform multiple failed login attempts using different invalid credentials
- Expected result: The same error notification is consistently shown
- Requirements verified: R3
- Outcome:  _Passed_

*AT34: Path search with identical start and destination*
- Precondition: Map screen is open
- Action: Select the same point as both start and destination and perform search
- Expected result: No valid path is returned and the operation is rejected
- Requirements verified: R8
- Outcome: _Failed_
- Defect Description:
Invalid Handling of Degenerate Routes: The system does not correctly handle cases where the start and destination points are identical.
- Observation:
No explicit validation feedback or alternative behavior is provided, and the path search fails silently.

*AT35: Retry path search after failure*
- Precondition: A previous path search returned no valid results
- Action: Press the retry option and repeat the path search
- Expected result: Path search is reattempted and a valid path is returned
- Requirements verified: R8
- Outcome: _Failed_
- Defect Description:
Ineffective Path Search Retry: Re-attempting a failed path search does not change the outcome or trigger alternative computation logic.
- Observation:
The retry action consistently produces the same failure result, indicating missing retry or fallback handling.
#heading(level: 4, numbering: none,  outlined: false,  "Authentication Module")
*Sign Up Process & Validation* \
*AT1*: Should register a new user with valid data \
- *Precondition*: App is installed and user is on the Sign Up screen. \
- *Action*: Enter Name, Surname, unique Username, valid and unique Email, and valid Password. Click Confirm. \
- *Expected result*: The account is created successfully. The system initiates the verification process (if applicable) or logs the user in. \
- *Requirements verified*: R1, R2, R3 \
- *Outcome*: _Passed_ \

*AT2*: Should enforce valid email format \
- *Precondition*: User is on the Sign Up screen. \
- *Action*: Fill all fields correctly but enter an invalid email format (e.g., "user.name" without domain or "@"). Click Confirm. \
- *Expected result*: The system displays an error message indicating the email format is invalid and blocks registration. \
- *Requirements verified*: R2 \
- *Outcome*: _Passed_ \

*AT3*: Should reject duplicate usernames \
- *Precondition*: A user is already registered with a certain username. \
- *Action*: Attempt to sign up a new user using the same username. \
- *Expected result*: The system displays an error and prevents account creation. \
- *Requirements verified*: NOT TRACED \
- *Outcome*: _Passed_ \
- *Note*: This requirement is not traced but needed for R4. \

*AT4*: Should reject duplicate email addresses \
- *Precondition*: A user is already registered with a certain email. \
- *Action*: Attempt to sign up a new user using the same email. \
- *Expected result*: The system displays an error "Email already registered" and prevents account creation. \
- *Requirements verified*: R2 \
- *Outcome*: _Passed_ \

*AT5*: Should validate password complexity \
- *Precondition*: User is on the Sign Up screen. \
- *Action*: Enter valid details but a password shorter than 8 characters. Click Confirm. \
- *Expected result*: An error message "Password must be at least 8 characters" is displayed and registration is blocked. \
- *Requirements verified*: R3 \
- *Outcome*: _Passed_ \

*AT6*: Should require email verification via code \
- *Precondition*: User has just submitted valid sign-up details. \
- *Action*: Wait for the verification prompt and attempt to enter a code. \
- *Expected result*: The system requests a verification code before allowing login. \
- *Requirements verified*: R2 \
- *Outcome*: _N/A (Descoped)_ \
- *Observation*: This functional flow is intentionally bypassed in the current release. The ITD states: "the email is auto-verified since it is a prototype". \
- *Defect Note*: Despite the "auto-verified" claim in the ITD, the backend/database implementation does not actually set the user's status to verified. This inconsistency causes the login failure described in *AT7*, as the system still enforces a check for a verification that never happened.

*Login & Session Management* \
*AT7*: Should allow login with username \
- *Precondition*: A registered and verified user exists with a known username. \
- *Action*: Enter username and correct password. Click Login. \
- *Expected result*: Login is successful and the user lands on the Home screen. \
- *Requirements verified*: R4 \
- *Outcome*: _Failed_ \
- *Defect Description*:
  1. *Blocking Issue*: The login is rejected by the server. Although the ITD states that the prototype auto-verifies emails, the database entry defaults email verification to `false` upon creation, and the Backend enforces verification check on sign-in.
  2. *Design Flaw*: There is an ambiguity in credential resolution. If a user registers with a username formatted as an email address (distinct from their actual email), the login query incorrectly targets the email field instead of the username field, causing authentication failure.
- *Recommendation*: Ensure the sign-up handler sets email verification to `true` by default for the prototype, and implement a regex check during sign-up to prevent usernames from having email-like formats.

*AT8*: Should allow login with email address \
- *Precondition*: A registered user exists with a known email. \
- *Action*: Enter email address and correct password. Click Login. \
- *Expected result*: Login is successful, recognizing the email as a valid identifier. \
- *Requirements verified*: R4 \
- *Outcome*: _Failed_ \
- *Defect Description*: The login is rejected by the server. Although the ITD states that the prototype auto-verifies emails, the database entry defaults email verification to `false` upon creation, and the Backend enforces verification check on sign in.
- *Recommendation*: Ensure the sign-up handler sets email verification to `true` by default for the prototype.

*AT9*: Should invalidate session on logout \
- *Precondition*: User is currently logged in. \
- *Action*: Click the Log Out button.\
- *Expected result*: User is redirected to the Login screen and the previous session token is no longer valid. \
- *Requirements verified*: R6 \
- *Outcome*: _Passed_ \

#heading(level: 4, numbering: none,  outlined: false,  "User Profile Management")
*AT10*: Should display correct profile information \
- *Precondition*: User is logged in. \
- *Action*: Navigate to the Profile tab. \
- *Expected result*: The displayed Username and Email match the registered account details. \
- *Requirements verified*: R7 \
- *Outcome*: _Passed_ \

#heading(level: 4, numbering: none,  outlined: false,  "Path Finding Service")
*AT11*: Should allow guest users to search for paths \
- *Precondition*: User is not logged in (Guest). \
- *Action*: Specify a Start Point and a Destination. Click Search. \
- *Expected result*: A list of compatible bike paths is displayed. \
- *Requirements verified*: R10 \
- *Outcome*: _Passed_ \

*AT12*: Should rank paths by calculated score \
- *Precondition*: A search is performed in an area with multiple possible routes. \
- *Action*: Observe the results list. \
- *Expected result*: Paths are ordered based on "Score" (combining distance and road status), not solely by shortest distance. \
- *Requirements verified*: R11, R12, R27 \
- *Outcome*: _Failed_ \
- *Note*: The score calculation described in ITD differs from RDD Assignment specifications. \
- *Defect Description*:
  1. *Inconsistent Score Aggregation*: The scoring update mechanism exhibits non-deterministic behavior. In some test runs, the score updates correctly after a new trip is published; in other identical scenarios, the score remains static, failing to incorporate the new feedback.
  2. *Random Data Unavailability*: The appearance of published paths in search results is erratic. Successfully published paths randomly fail to appear in subsequent searches.
- *Observation*: The flakiness of these bugs makes reliable reproduction difficult, as the system behaves correctly in approximately 50% of the attempts. The failure should not be caused by the geographical precision of the search query. As demonstrated by the attached screenshots from our test sessions, using the exact same coordinates yields empty results in some attempts. This rules out geospatial matching tolerance (100m) as the root cause.

#align(center)[
  #stack(dir: ltr, spacing: 3%)[
    #block(width: 20%)[
      #figure(
        image("ui/at12/trip-origin.png"),
          caption: [\ Trip Origin]
      )
    ]
  ][
    #block(width: 20%)[
      #figure(
        image("ui/at12/trip-destination.png"),
          caption: [\ Trip Destination]
      ) 
    ]
  ][
    #block(width: 20%)[
      #figure(
        image("ui/at12/search-origin.png"),
          caption: [Search Origin]
      )
    ]
  ][
    #block(width: 20%)[
      #figure(
        image("ui/at12/search-destination.png"),
          caption: [Search \ Destination]
      )
    ]
  ][
    #block(width: 20%)[
      #figure(
        image("ui/at12/search-result.png"),
          caption: [Search Result]
      )
    ]
  ]
]

*AT13*: Should display distance and score \
- *Precondition*: A search is performed in an area with at least one possible route. \
- *Action*: Observe the results list. \
- *Expected result*: The UI shows the total distance and the calculated quality score. \
- *Requirements verified*: R13 \
- *Outcome*: _Passed_ \
- *Note*: The score calculation described in ITD differs from RDD Assignment specifications. \

#heading(level: 4, numbering: none,  outlined: false,  "Trip Recording & Weather")
*AT14*: Should manually create a trip \
- *Precondition*: User is authenticated. \
- *Action*: Create a new manual trip specifying travel points and start/end dates, average speed, and road status. \
- *Expected result*: The trip is saved. The system shows the trip in the "My Trips" section. \
- *Requirements verified*: R16, R20 \
- *Outcome*: _Passed_ \
- *Note*: The location coordinates are not specified by the user using street names, but by tapping the location on the map. \

*AT15*: Should fetch historical weather data for trips \
- *Precondition*: A manual trip is created. \
- *Action*: Open the details view of the saved trip from "My Trips". \
- *Expected result*: Temperature, wind speed, and weather condition are displayed alongside the trip statistics. \
- *Requirements verified*: R21, R33, R34, R35 \
- *Outcome*: _Passed_ \

#heading(level: 4, numbering: none,  outlined: false,  "Trip Publishing")
*AT16*: Should publish multiple trips simultaneously \
- *Precondition*: User has one or more "Unpublished" trips in their history. \
- *Action*: Select multiple trips (by long-pressing them) and click the "Publish" button. \
- *Expected result*: The selected trips' status changes to "Published". \
- *Requirements verified*: R26, R27 \
- *Outcome*: _Passed_ \


= Quality Assessment

This section outlines observations regarding the code quality, documentation consistency, and user experience (UX) derived from the testing session.

== 1. Documentation vs. Implementation Mismatch
The most critical issue found is a direct contradiction between the architectural decisions described in the ITD and the actual backend logic.
- *The Issue*: The ITD states that email verification is skipped ("auto-verified") for this prototype. However, the database initialization logic sets the `emailVerification` flag to `false` by default, and the login handler enforces a check on this flag.
- *Impact*: This creates an immediate *showstopper* for any new user, blocking access right after registration. The code should explicitly mirror the "prototype assumptions" documented in the deliverables.

== 2. UX Friction Points
While the visual interface is clean, two specific interaction patterns degrade usability:

* Hidden Functionality (The "Long Press" Issue)* \
  In the "My Trips" section, publishing a trip requires a long-press gesture on the list item. There is no visual cue (affordance), icon, or instruction indicating this possibility. Users rely on standard tap interactions; hiding core functionality behind an invisible gesture makes the feature undiscoverable without external help.

*Manual Entry Inefficiency* \
  The "Manual Trip" creation flow assumes the user is near the start point. Lacking a text-based search (Geocoding), the user is forced to manually drag and zoom the map to find a remote location. If a user wants to log a trip taken in a different city, the manual panning process becomes very slow.

== 3. Overall Stability
The application demonstrates a solid Proof of Concept (PoC) architecture. However, the *non-deterministic nature* of the Path Finding service (where paths randomly fail to appear in search results) suggests some error in the Backend that needs addressing.

*Conclusion*: The app has good potential. Fixing the discussed problems would significantly elevate the prototype from "technically functional" to "actually usable."

= Effort Spent

#figure(
  table(
    columns: 4,
    table.header([], [*Foad Zahedi Labaf*], [*Lorenzo Fiamingo*], [*Alexander Gabriel Fox*]),
    [*Section 1*], [], [1], [],
    [*Section 2*], [], [1], [],
    [*Section 3*], [], [2], [],
    [*Section 4*], [], [10], [],
    [*Section 5*], [], [4], [],
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
