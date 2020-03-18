This is a techincal to-do list. For a more user-centric feature roadmap, see [roadmap](roadmap.md).

* [x] Rename the project to something more sensible than "apptest"
* [ ] package the app as a .deb file and make it installable for an end user
* [ ] Figure out how to include framework headers without having to copy them into `$THEOS/lib`
* [x] Move Matrix-specific code into it's own file so it's somewhat isolated from the rest of the project
* [x] Account sign-in (as a basic bot)
  * [x] Bot username / password
    * [x] Infer matrix server from bot username (can this be done consistently? Look into .well-known)
    * [x] Get a token using the username/password and store it
  * [x] User's username 
    * [ ] is it possible to check that a given username exists?
* [ ] Create a status room and invite the user on login

UI Design
---------
* [x] Compile SnapKit with Swift 4.0.3
* [ ] account sign in (as an Appservice)
* [ ] Add keyboard movement logic
* [ ] account sign in (as a basic bot)
  * [x] sign in screen: [mockup 1](./design/mockup1.png) [mockup 2](./design/mockup2.png)
  * [ ] Show a "searching for matrix server" message after a user ID is entered
  * [ ] Hide server URL cell if the user fixes their username
  * [ ] Show a loading indicator when the bot account is logging in
  * [x] Skip login UI if we already have saved credentials
* [ ] Status page
