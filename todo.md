This is a techincal to-do list. For a more user-centric feature roadmap, see [roadmap](roadmap).

* [ ] Rename the project to something more sensible than "apptest"
* [ ] package the app as a .deb file and make it installable for an end user
* [ ] Figure out how to include framework headers without having to copy them into `$THEOS/lib`
* [ ] Move Matrix-specific code into it's own file so it's somewhat isolated from the rest of the project
* [ ] Account sign-in (as a basic bot)
  * [ ] Bot username / password
    * [ ] Infer matrix server from bot username (can this be done consistently? Look into .well-known)
    * [ ] Get a token using the username/password and store it
  * [ ] User's username
* [ ] UI for account sign in (as an Appservice)
