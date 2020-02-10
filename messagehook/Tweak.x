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

#import <ChatKit/CKConversationList.h>
#import <Foundation/NSDistributedNotificationCenter.h>
#import <version.h>

@interface NSObject (Private)
- (NSString*)_methodDescription;
@end

@interface IMMessage: NSObject {}
@property (setter=_updateText:,nonatomic,retain) NSAttributedString * text; 
-(NSString *) guid;
@end

@interface IMHandle: NSObject {}
@property (nonatomic,retain) NSString * displayName;
@property (nonatomic,copy) NSString * suggestedName;
@property (nonatomic,retain,readonly) NSString * name;
@property (nonatomic,retain,readonly) NSString * fullName;
@end

@interface IMChat: NSObject {}
@property (nonatomic,readonly) IMMessage * lastMessage;
@property (nonatomic,readonly) NSString * guid;
@property (nonatomic,readonly) NSString * chatIdentifier;
@property (nonatomic,readonly) NSString * persistentID;
@property (nonatomic,readonly) NSString * deviceIndependentID;
@property (nonatomic,retain) NSString * displayName;
@property (nonatomic,readonly) NSString * roomName;
@property (nonatomic,retain) IMHandle * recipient;
@property (nonatomic,readonly) NSArray * participants;
@property (readonly) unsigned long long hash;
@property (nonatomic,readonly) NSString * identifier;
@end

@interface CKConversation: NSObject {}
-(void) splitLog:(NSString*)logString;
-(void) sendNewMessageToBridge:(NSString *)message guid:(NSString *)guid recipientName:(NSString *)name;
-(void) setLocalUserIsTyping:(BOOL)isTyping;
-(void) logProperties:(NSObject*)obj;
@property (retain, nonatomic) IMChat* chat;
@end

%hook CKChatControllerDelegate

%end


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

%new
-(void) sendNewMessageToBridge:(NSString *)message guid:(NSString *)guid recipientName:(NSString *)name {
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:[NSBundle mainBundle].bundleIdentifier forKey:@"id"];
    [userInfo setObject:@"SpringBoard" forKey:@"type"];
    [userInfo setObject:message forKey:@"message"];
    if (guid != nil) { [userInfo setObject:guid forKey:@"guid"]; }
    if (name != nil) { [userInfo setObject:name forKey:@"recipientName"]; }
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"messagehook" object:nil userInfo:userInfo];
}

-(void)sendMessage:(id)arg1 newComposition:(BOOL)arg2 {
   %orig;
   NSLog(@"msghk: message: %@", self.chat.lastMessage.text);
   NSLog(@"msghk: guid: %@", [self.chat.lastMessage guid]);
}

- (void)setLocalUserIsTyping:(BOOL)isTyping {
    %orig;
    NSLog(@"msghk: User typing: %d", isTyping);
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:[NSBundle mainBundle].bundleIdentifier forKey:@"id"];
    [userInfo setObject:@"SpringBoard" forKey:@"type"];
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"messagehook" object:nil userInfo:userInfo];
}

- (void)_chatItemsDidChange:(id)arg1 {
    %orig;
    NSLog(@"msghk: chat items changed");

    // self.chat.lastMessage.guid should give us a GUID for a specific message
    NSString *s = @"";

    s = [s stringByAppendingString: @" guid: "];
    s = [s stringByAppendingString: self.chat.guid];

    if (self.chat.persistentID != nil) {
        s = [s stringByAppendingString: @" persistentID: "];
        s = [s stringByAppendingString: self.chat.persistentID];
    }

    if (self.chat.displayName != nil) {
        s = [s stringByAppendingString: @" displayName: "];
        s = [s stringByAppendingString: self.chat.displayName];
    }

    if (self.chat.roomName != nil) {
        s = [s stringByAppendingString: @" roomName: "];
        s = [s stringByAppendingString: self.chat.roomName];
    }

    //if (self.chat.identifier != nil) {
    //    s = [s stringByAppendingString: @" identifier: "];
    //    s = [s stringByAppendingString: self.chat.identifier];
    //}

    if (self.chat.chatIdentifier != nil) {
        s = [s stringByAppendingString: @" chatIdentifier: "];
        s = [s stringByAppendingString: self.chat.chatIdentifier];
    }

    s = [s stringByAppendingString: @" hash: "];
    s = [s stringByAppendingFormat: @"%lld", self.chat.hash];

    if (self.chat.recipient != nil) {
        if (self.chat.recipient.name != nil) {
            s = [s stringByAppendingString: @" recipient.name: "];
            s = [s stringByAppendingString: self.chat.recipient.name];
        }
    }

    //for (IMHandle *p in self.chat.participants) {
        //s = [s stringByAppendingString: @" participant: "];
        //s = [s stringByAppendingString: p.description];
        //if (p.suggestedName != nil) {
        //    s = [s stringByAppendingString: @" suggestedName: "];
        //    s = [s stringByAppendingString: p.suggestedName];
        //}
        //if (p.name != nil) {
        //    s = [s stringByAppendingString: @" name: "];
        //    s = [s stringByAppendingString: p.name];
        //}
    //}

    //if (self.chat.participants != nil) {
    //    s = [s stringByAppendingString: @" participants: "];
    //    s = [s stringByAppendingString: self.chat.participants.description];
    //}

    [self sendNewMessageToBridge:self.chat.lastMessage.text.string guid: self.chat.guid recipientName: self.chat.recipient.name];
}

- (void)_chatPropertiesChanged:(id)arg1 {
    %orig;
    NSLog(@"msghk: chat properties changed");
    //NSLog(@"msghk: message: %@", self.chat.lastMessage.text);
}


%end

// Currently, hooking IMDaemon isn't working
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
    NSLog(@"msghk: hooked IMDaemonController");
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
