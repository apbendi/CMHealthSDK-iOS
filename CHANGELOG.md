0.5.0 (August 9, 2016)
====================
A pre-Beta release of CMHealth that adds a convenient way to authenticate participants
using ResearchKit's built in Registration APIs. It is now possible to register a new
user up by simply supplying an `ORKTaskResult` that includes results from an `ORKRegistrationStep`.
Additionally, the SDK now includes a preconfigured view controller which wraps around
ResearchKit's `ORKLoginStepViewController` and handles all aspects of login and password
reset. The result is returned via delegate callback.

The custom CMHealth sign up and login view controllers have been removed, being redundant.
Developers can still opt to build custom registration and login experiences and authenticate
participants by passing username and password to the SDK.

0.4.0 (June 13, 2016)
=====================
A pre-Beta release of CMHealth with preliminary support for saving and fetching
data generated by Apple's newly released CareKit framework. CareKit support is
experimental and subject to change. Feedback is welcomed!

0.3.0 (April 28, 2016)
=====================
A pre-Beta release of CMHealth, with various new features and fixes, including:

* Added ability to query object fields when fetching saved results
* Added the ability to store and fetch user's consent PDF and Signature
* Added full documentation of the public API
* Ensured consistent, useful error message in the local SDK Domain
* Moved participant user data to a protected, profile object
* Fixed bug that caused crashing when saving results from date and time survey questions

0.2.1 (February 25, 2016)
======================
The first pre-Beta release of CMHealth, including functionality to effortlessly persist and fetch ResearchKit results to CloudMine's HIPAA compliant cloud data storage. The SDK also includes seamless user account management.
