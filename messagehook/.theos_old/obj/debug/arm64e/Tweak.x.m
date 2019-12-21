#line 1 "Tweak.x"




































#import <ChatKit/CKConversationList.h>


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



#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class IMDaemon; @class CKConversation; @class IMDaemonController; 
static void _logos_method$_ungrouped$CKConversation$splitLog$(_LOGOS_SELF_TYPE_NORMAL CKConversation* _LOGOS_SELF_CONST, SEL, NSString*); static void (*_logos_orig$_ungrouped$CKConversation$sendMessage$newComposition$)(_LOGOS_SELF_TYPE_NORMAL CKConversation* _LOGOS_SELF_CONST, SEL, id, BOOL); static void _logos_method$_ungrouped$CKConversation$sendMessage$newComposition$(_LOGOS_SELF_TYPE_NORMAL CKConversation* _LOGOS_SELF_CONST, SEL, id, BOOL); static void (*_logos_orig$_ungrouped$CKConversation$setLocalUserIsTyping$)(_LOGOS_SELF_TYPE_NORMAL CKConversation* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$CKConversation$setLocalUserIsTyping$(_LOGOS_SELF_TYPE_NORMAL CKConversation* _LOGOS_SELF_CONST, SEL, BOOL); static BOOL (*_logos_orig$_ungrouped$IMDaemon$daemonInterface$shouldGrantAccessForPID$auditToken$portName$listenerConnection$setupInfo$setupResponse$)(_LOGOS_SELF_TYPE_NORMAL IMDaemon* _LOGOS_SELF_CONST, SEL, id, int, id, id, id, id, id*); static BOOL _logos_method$_ungrouped$IMDaemon$daemonInterface$shouldGrantAccessForPID$auditToken$portName$listenerConnection$setupInfo$setupResponse$(_LOGOS_SELF_TYPE_NORMAL IMDaemon* _LOGOS_SELF_CONST, SEL, id, int, id, id, id, id, id*); static BOOL (*_logos_orig$_ungrouped$IMDaemon$daemonInterface$shouldGrantPlugInAccessForPID$auditToken$portName$listenerConnection$setupInfo$setupResponse$)(_LOGOS_SELF_TYPE_NORMAL IMDaemon* _LOGOS_SELF_CONST, SEL, id, int, id, id, id, id, id*); static BOOL _logos_method$_ungrouped$IMDaemon$daemonInterface$shouldGrantPlugInAccessForPID$auditToken$portName$listenerConnection$setupInfo$setupResponse$(_LOGOS_SELF_TYPE_NORMAL IMDaemon* _LOGOS_SELF_CONST, SEL, id, int, id, id, id, id, id*); static BOOL (*_logos_orig$_ungrouped$IMDaemonController$setCapabilities$forListenerID$)(_LOGOS_SELF_TYPE_NORMAL IMDaemonController* _LOGOS_SELF_CONST, SEL, id, NSString *); static BOOL _logos_method$_ungrouped$IMDaemonController$setCapabilities$forListenerID$(_LOGOS_SELF_TYPE_NORMAL IMDaemonController* _LOGOS_SELF_CONST, SEL, id, NSString *); 

#line 61 "Tweak.x"



static void _logos_method$_ungrouped$CKConversation$splitLog$(_LOGOS_SELF_TYPE_NORMAL CKConversation* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* logString){
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

static void _logos_method$_ungrouped$CKConversation$sendMessage$newComposition$(_LOGOS_SELF_TYPE_NORMAL CKConversation* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, BOOL arg2) {
   _logos_orig$_ungrouped$CKConversation$sendMessage$newComposition$(self, _cmd, arg1, arg2);
   NSLog(@"%@", self.chat.lastMessage.text);
}

static void _logos_method$_ungrouped$CKConversation$setLocalUserIsTyping$(_LOGOS_SELF_TYPE_NORMAL CKConversation* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL isTyping) {
    _logos_orig$_ungrouped$CKConversation$setLocalUserIsTyping$(self, _cmd, isTyping);
    NSLog(@"User typing: %d", isTyping);

    
    
    
    _logos_orig$_ungrouped$CKConversation$setLocalUserIsTyping$(self, _cmd, isTyping);
}




static BOOL _logos_method$_ungrouped$IMDaemon$daemonInterface$shouldGrantAccessForPID$auditToken$portName$listenerConnection$setupInfo$setupResponse$(_LOGOS_SELF_TYPE_NORMAL IMDaemon* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, int arg2, id arg3, id arg4, id arg5, id arg6, id* arg7) {
    NSLog(@"hooked IMDaemon");
	return TRUE;
}
static BOOL _logos_method$_ungrouped$IMDaemon$daemonInterface$shouldGrantPlugInAccessForPID$auditToken$portName$listenerConnection$setupInfo$setupResponse$(_LOGOS_SELF_TYPE_NORMAL IMDaemon* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, int arg2, id arg3, id arg4, id arg5, id arg6, id* arg7) {
    NSLog(@"hooked IMDaemon");
	return TRUE;
}



static BOOL _logos_method$_ungrouped$IMDaemonController$setCapabilities$forListenerID$(_LOGOS_SELF_TYPE_NORMAL IMDaemonController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id capabilities, NSString * listenerID) {
    NSLog(@"hooked IMDaemonController");
	NSLog(@"Capabilities: %@, lsitenerID: %@", capabilities, listenerID);
	_logos_orig$_ungrouped$IMDaemonController$setCapabilities$forListenerID$(self, _cmd, capabilities, listenerID);
	
	return TRUE;

}













static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$CKConversation = objc_getClass("CKConversation"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$CKConversation, @selector(splitLog:), (IMP)&_logos_method$_ungrouped$CKConversation$splitLog$, _typeEncoding); }MSHookMessageEx(_logos_class$_ungrouped$CKConversation, @selector(sendMessage:newComposition:), (IMP)&_logos_method$_ungrouped$CKConversation$sendMessage$newComposition$, (IMP*)&_logos_orig$_ungrouped$CKConversation$sendMessage$newComposition$);MSHookMessageEx(_logos_class$_ungrouped$CKConversation, @selector(setLocalUserIsTyping:), (IMP)&_logos_method$_ungrouped$CKConversation$setLocalUserIsTyping$, (IMP*)&_logos_orig$_ungrouped$CKConversation$setLocalUserIsTyping$);Class _logos_class$_ungrouped$IMDaemon = objc_getClass("IMDaemon"); MSHookMessageEx(_logos_class$_ungrouped$IMDaemon, @selector(daemonInterface:shouldGrantAccessForPID:auditToken:portName:listenerConnection:setupInfo:setupResponse:), (IMP)&_logos_method$_ungrouped$IMDaemon$daemonInterface$shouldGrantAccessForPID$auditToken$portName$listenerConnection$setupInfo$setupResponse$, (IMP*)&_logos_orig$_ungrouped$IMDaemon$daemonInterface$shouldGrantAccessForPID$auditToken$portName$listenerConnection$setupInfo$setupResponse$);MSHookMessageEx(_logos_class$_ungrouped$IMDaemon, @selector(daemonInterface:shouldGrantPlugInAccessForPID:auditToken:portName:listenerConnection:setupInfo:setupResponse:), (IMP)&_logos_method$_ungrouped$IMDaemon$daemonInterface$shouldGrantPlugInAccessForPID$auditToken$portName$listenerConnection$setupInfo$setupResponse$, (IMP*)&_logos_orig$_ungrouped$IMDaemon$daemonInterface$shouldGrantPlugInAccessForPID$auditToken$portName$listenerConnection$setupInfo$setupResponse$);Class _logos_class$_ungrouped$IMDaemonController = objc_getClass("IMDaemonController"); MSHookMessageEx(_logos_class$_ungrouped$IMDaemonController, @selector(setCapabilities:forListenerID:), (IMP)&_logos_method$_ungrouped$IMDaemonController$setCapabilities$forListenerID$, (IMP*)&_logos_orig$_ungrouped$IMDaemonController$setCapabilities$forListenerID$);} }
#line 131 "Tweak.x"
