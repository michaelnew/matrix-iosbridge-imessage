Status
------
This is more proof-of-concept than a usable project at this point. 
If you're someone with experience developing jailbroken iOS apps your contributions would be very welcome!


Installing
----------
This project hasn't yet been packaged for easy installation. Coming soon!


Development
-----------
**buidling dependencies**  
Dependencies are checked in to git, so you shouldn't *have* to build them. But if you do need to update/build new ones, they can be built with:  
* Xcode 9.2 (swift 4.0.3), which can be downloaded from [here](https://developer.apple.com/download/more/)
* macOS Mojave (Xcode 9.2 doesn't run on Catalina)
* [cocoapods rome](https://github.com/CocoaPods/Rome)

Add any new framweorks to the `Podfile`. For example:  
```
target 'caesar' do
  pod 'NewFramwork', '~> 4.0.0'
end
```

and then `pod install`.  

Once built, move them from the `Rome` directory into `matrix_bridge/layout/Library/Framworks`. 
Code sign them with ldid:  
`brew install ldid`
`ldid -S NewFramework.framework/NewFramwork`

They will also need to be copied into `$THEOS/lib/` on whatever device you're compiling the project with, 
as well as added to the `matrixbridge_EXTRA_FRAMEWORKS` line of the makefile.


Other Stuff
-----------
[feature roadmap](roadmap.md)  

[to do list](todo.md)
