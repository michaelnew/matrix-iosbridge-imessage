/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/

//#import <ChatKit/CKConversation.h>
#import <ChatKit/CKConversationList.h>
//#import <IMCore/IMChat.h>
//#import <IMCore/IMHandle.h>
#import <version.h>

@interface NSObject (Private)
- (NSString*)_methodDescription;
@end

@interface IMMessage: NSObject {}
@property (setter=_updateText:,nonatomic,retain) NSAttributedString * text; 
@end

@interface IMChat: NSObject {}
@property (nonatomic,readonly) IMMessage * lastMessage;
@end

@interface CKConversation: NSObject {}
-(void) splitLog:(NSString*)logString;
-(void) setLocalUserIsTyping:(BOOL)isTyping;
@property (retain, nonatomic) IMChat* chat;
@end


%hook CKConversation

%new
-(void) splitLog:(NSString*)logString{
    int stepLog = 800;
    NSInteger strLen = [@([logString length]) integerValue];
    NSInteger countInt = strLen / stepLog;

    if (strLen > stepLog) {
        for (int i=1; i <= countInt; i++) {
            NSString *character = [logString substringWithRange:NSMakeRange((i*stepLog)-stepLog, stepLog)];
            HBLogInfo(@"%@", character);
        }
        NSString *character = [logString substringWithRange:NSMakeRange((countInt*stepLog), strLen-(countInt*stepLog))];
        HBLogInfo(@"%@", character);
    } else {
        HBLogInfo(@"%@", logString);
    }
}

-(void)sendMessage:(id)arg1 newComposition:(BOOL)arg2 {
   %orig;
   NSLog(@"msghk: %@", self.chat.lastMessage.text);
}

- (void)setLocalUserIsTyping:(BOOL)isTyping {
    %orig;
    NSLog(@"msghk: User typing: %d", isTyping);
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:[NSBundle mainBundle].bundleIdentifier forKey:@"id"];
    [userInfo setObject:@"SpringBoard" forKey:@"type"];
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"net.example.tweak/sendToApp" object:nil userInfo:userInfo];
}

%end

%hook IMDaemon
-(BOOL)daemonInterface:(id)arg1 shouldGrantAccessForPID:(int)arg2 auditToken:(id)arg3 portName:(id)arg4 listenerConnection:(id)arg5 setupInfo:(id)arg6 setupResponse:(id*)arg7 {
    NSLog(@"msghk: hooked IMDaemon");
	return TRUE;
}
-(BOOL)daemonInterface:(id)arg1 shouldGrantPlugInAccessForPID:(int)arg2 auditToken:(id)arg3 portName:(id)arg4 listenerConnection:(id)arg5 setupInfo:(id)arg6 setupResponse:(id*)arg7 {
    NSLog(@"msghk: hooked IMDaemon");
	return TRUE;
}
%end

%hook IMDaemonController
- (BOOL)setCapabilities:(id)capabilities forListenerID:(NSString *)listenerID {
    NSLog(@"hooked IMDaemonController");
	NSLog(@"msghk: Capabilities: %@, lsitenerID: %@", capabilities, listenerID);
	%orig;
	//%orig(Chats, listenerID);
	return TRUE;

}
%end


//%hook CKConversationListController
//-(void)setConversationList:(CKConversationList *)arg1 {
//    %orig;
//    //HBLogInfo(@"CKConversationListController list %@", arg1.conversations.description);
//    NSArray *convos = MSHookIvar<NSArray *>(arg1, "conversations");
//    HBLogInfo(@"CKConversationListController list %@", convos.description);
//
//}
//%end
