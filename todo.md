This is a techincal to-do list. For a more user-centric feature roadmap, see [roadmap](roadmap.md).

* [x] Rename the project to something more sensible than "apptest"
* [ ] package the app as a .deb file and make it installable for an end user
* [ ] Figure out how to include framework headers without having to copy them into `$THEOS/lib`
* [ ] Move Matrix-specific code into it's own file so it's somewhat isolated from the rest of the project
* [ ] Account sign-in (as a basic bot)
  * [ ] Bot username / password
    * [x] Infer matrix server from bot username (can this be done consistently? Look into .well-known)
    * [ ] Get a token using the username/password and store it
  * [ ] User's username (is it possible to check that a given username exists?)

UI Design
---------
* [x] Compile SnapKit with Swift 4.0.3
* [ ] account sign in (as an Appservice)
      Show a "searching for matrix server" message after a user ID is entered
  * sign in screen: [mockup 1](./design/mockup1.png) [mockup 2](./design/mockup2.png)
* [ ] Add keyboard movement logic
