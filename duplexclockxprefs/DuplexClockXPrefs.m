#import <Preferences/PSListController.h>

@interface DuplexClockXPrefsListController: PSListController

@end

@implementation DuplexClockXPrefsListController

-(NSArray *)timeZones {
	return [NSTimeZone knownTimeZoneNames];
}

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"DuplexClockXPrefs" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
