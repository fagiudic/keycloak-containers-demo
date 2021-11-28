+ INTRODUCTION SLIDES 

+ Connect to Keycloak (admin/admin)
+ Top left master / Add Realm.
  + Name: `demo`
  + Create
  + Display name: `Demo SSO`
  + Save
+ Left bar / Clients / Right Create
  + Client ID: `js-console`
  + Client Protocol: `openid-connect`
  + Save
  + Valid Redirect URIs: `http://localhost:8000/*`
  + Web Origins: `http://localhost:8000`
  + Save
+ Top right admin user / Manage account
  + Email: `admin@localhost`
  + First name: `The`
  + Last name: `Admin`
  + Save
+ Top right Back to Security AdminConsole
+ Left bar / Realm Settings / Email
  + Host: `demo-mail`
  + Port: `1025`
  + From: `keycloak@localhost`
  + Save
  + Test connection
+ Mailhog
  + Check email reception
+ Left bar / Realm Settings / Login
  + User registration: `on`
  + Verify email: `on
  + Save
+ Connect to JS Console
  + Register
    + First name: `John`
    + Last name: `Doe`
    + Email: `jdoe@localhost`
    + Username: jdoe
    + Password: jdoe
  + Asks for confirming email address
+ Go to MailHog
  + Find the new email message and click on the link
  + Will be redirected to the home page of the app

+ SLIDE TO EXPLAIN REDIRECTION & TOKENS
  + Show and inspect the three tokens

+ SLIDE TO EXPLAIN CUSTOM CLAIMS

+ Left bar / Users / View all users
  + Click on jdoe
  + Attributes
  + Key: `foo`
  + Value: `bar`
  + Add
  + Save
+ Left bar / Client Scopes / Create
  + Name: `foo`
  + Consent Screen Text: `Foo`
  + Save
  + Mappers / Create
  + Name: `foo`
  + Mapper Type: `User Attribute`
  + User Attribute `foo`
  + Token Claim Name: `foo`
  + Claim JSON Type: `String`
  + Save
+ Left bar / Clients / js-console / Client Scopes
  + Add `foo` into Assigned Default Client Scopes
+ Left bar / Clients / Settings
  + Enable `Consent Required`
  + Save
+ Go to JS Console
  + Logout
  + Login
  + Verify it asks for granting privileges and there's 'Foo'.
  + Verify the ID Token and Access Token contain `"foo": "bar"`.

+ SLIDE TO EXPLAIN ROLES AND GROUPS

+ Left bar / Roles / Top right Add Role
  + Role name: `my_role`
  + Save
+ Left bar / Users / View all users
  + Click on jdoe
  + Role Mappings
  + Add `my_role` to Assigned Roles
+ Go to JS Console
  + Refresh
  + Verify that in the Access Token there is `my_role` in `realm_access`.  
+ Left bar / Groups / Top right New
  + Name: `my_group` 
  + Save
  + Show the Attributes and Role Mappings tabs.
  + Attributes
    + Key: `my_user_type`
    + Value: `premium`
    + Add
    + Save
+ Left bar / Users / jdoe / Groups
  + Select `my_group`
  + Join
+ Left bar / Client Scopes / Top right Create
  + Name: `my_scope 
  + Save
  + Mappers / Create
    + Name: `groups`
    + Mapper Type: `Group Membership`
    + Token Claim Name: `groups`
    + Save
  + Mappers / Create
    + Name: `type`
    + Mapper Type: `User Attribute`
    + User Attribute: `my_user_type`
    + Token Claim Name: `my_user_type`
    + Claim JSON Type: `String`
    + Save
+ Left bar / Clients / js-console / Client Scopes
  + Add my_scope to Assigned Default Client Scopes
+ Go to JS Console
  + Refresh
  + Verify that in Access Token there is the `groups` claim assigned to `my_group`.
  + Verify that in Access Token there is the `my_user_type` claim set to `premium`.

SLIDES TO EXPLAIN FEDERATION

+ Left bar / User Federation
  + LDAP
  + Edit Mode: `WRITABLE`
  + Vendor: `other`
  + Connection URL: `ldap://demo-ldap:389`
  + Users DN: `ou=People,dc=example,dc=org`
  + Bind DN: `cn=admin,dc=example,dc=org`
  + Bind Credential: `admin`
  + Trust Email: `ON`
  + Save
  + Test Connection
  + Test Authentication
  + Synchronize all users
+ Left bar / Users / View all users
+ Try to login with new users `jbrown`, `bwilson` (the password is `password`)

+ Left bar / Identity Providers
  + Add provider: GitHub
  + Copy the value `http://localhost:8080/auth/realms/demo/broker/github/endpoint`
  + Connect to https://github.com/settings/applications/new
    + Application name: Keycloak
    + Homepage URL: `http://localhost:8080/auth/realms/demo/broker/github/endpoint`
    + Authorization callback URL: `http://localhost:8080/auth/realms/demo/broker/github/endpoint`
    + Register Application
    + Generate a new client secret
    + Copy `Client ID` and `Client secret` to Keycloak admin
    + Trust Email: `ON`
    + Save
    + Mappers
    + Create
      + Name: `avatar`
      + Mapper Type: `Attribute Importer`
      + Social Profile JSON Field Path: `avatar_url`
      + User Attribute Name: `avatar_url`
      + Save
+ Left bar / Client Scopes / Create
  + Name: `avatar`
  + Consent Screen Text: `Avatar`
  + Save
  + Mappers / Create
  + Name: `avatar`
  + Mapper Type: `User Attribute`
  + User Attribute `avatar_url`
  + Token Claim Name: `avatar_url`
  + Claim JSON Type: `String`
  + Save
+ Left bar / Clients / js-console / Client Scopes
  + Add `avatar` into Assigned Default Client Scopes
+ Go to JS Console
  + Logout
  + Login with GitHub
  + Authorize Keycloak
  + On redirect it will ask for email verification
  + Go to MailHog and click on the link
  + Confirm access grant
  + Confirm the avatar is there
  

TBD STYLE LOGIN

SLIDES EXPLAINING SIGNING ALGORITHMS

+ Go to JS Console
  + Copy & paste the ID token in JTW.io
  + Show that RS256 is used
+ Left tab / Clients / js-console / Fine Grained OpenID Connect Configuration
  + Set `Access Token Signature Algorithm` and `ID Token Signature Algorithm` to `ES256`
  + Refresh / Login
  + Copy & paste the ID token in JTW.io
  + Show that ES256 is used
  + Take note of the KID (the key signer)
+ Left tab / Realm settings / Keys
  + Providers
  + Top right Add 
    + ecdsa-generated
    + Priority 200
    + Save
+ Go to JS Console
  + Refresh 
  + Copy & paste the ID token in JTW.io
  + Show that the KID has changed

SHOW SLIDES EXPLAINING SESSIONS

+ Go to JS Console
  + Logout
  + Log WITHOUT GitHub
+ Left tab / Sessions / js-console
  + Show sessions
  + Select logged user
  + Show all tabs
  + Go to sessions
  + Logout
+ Go to JS Console
  + Show that the user has been logged out.

SHOW SLIDES DESCRIBING EVENTS

+ Left tab / Events
  + Config
  + Save events: ON
  + Save
  + Back to Events / Login Events
+ Go to JS Console
  + Refresh
+ Left tab / Events
  + Update 
  + Show event log

FLOWS, TWO-FACTORS AUTHENTICATION

+ Left tab / Authentication / Flows
  + Show and explain stuff
  + Set `Browser - Conditional OTP` to `REQUIRED`
  + Authentication / OTP Policy
  + Show options
+ Go to JS Console
  + Logout / Login
  + Show the use of the OTP authentication

+ Left tab / Authentication / Flows
  + Top right Copy
  + Magiclink
  + Ensure it's selected
  + Delete the `Username Password form` and all the other in `Magiclink Forms`
  + On `Magiclink Forms` open the Actions / Add execution
  + Provider: Magic Link
  + Save
  + On `Magiclink Forms` open the Actions / Add execution
  + Provider: OTP Form
  + Save
  + Use up arrow to move `Magic Link` as first item in the subflow
  + Make both executions `REQUIRED`
  + Authentication / Bindings
  + Set the Browser Flow to `Magiclink`
  + Save
+ Go to JS Console
  + Logout / Login
  + Enter jdoe@localhost
  + Show email
  + Click on the magic link
  + Enter the OTP code
  