# Features & roadmap
* Matrix → iMessage
  * [ ] Message content
    * [x] Plain text
    * [ ] Formatted messages
    * [ ] Media/files
    * [ ] Replies
    * [ ] Reactions
  * [ ] Presence
  * [ ] Typing notifications
  * [ ] Read receipts
  * [ ] Membership actions
    * [ ] Invite
    * [ ] Join
    * [ ] Leave
    * [ ] Kick
  * [ ] Room metadata changes
    * [ ] Name
  * [ ] Initial room metadata
* iMessage → Matrix
  * [ ] Message content
    * [ ] Plain text
    * [ ] Formatted messages
    * [ ] Media/files
    * [ ] Location sharing
    * [ ] Replies
    * [ ] Reactions
  * [ ] Chat types
    * [ ] Private chat
    * [ ] Group chat
  * [ ] Message deletions
  * [ ] Presence
  * [ ] Typing notifications
  * [ ] Read receipts
  * [ ] Membership actions
    * [ ] Invite
    * [ ] Join
    * [ ] Leave
  * [ ] Group metadata changes
    * [ ] Title
  * [ ] Initial group metadata
  * [ ] User metadata changes
    * [ ] Display name
  * [ ] Initial user metadata
    * [ ] Display name
* Misc
  * [ ] Automatic portal creation
    * [ ] At startup
    * [ ] When receiving invite
    * [ ] When receiving message
  * [ ] Option to use own Matrix account for messages sent from iMessage mobile/other web clients
  
  
  ## Phase 1 
  - replicate core functionality of https://github.com/matrix-hacks/matrix-puppet-imessage
  - eg register appservice by copying yaml to homeserver
  
  ## Phase 2
  - eliminate homeserver reset when adding new user
