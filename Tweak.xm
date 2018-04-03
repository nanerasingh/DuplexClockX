static NSDictionary *settings = nil;
static bool is24h;

#define PLIST_PATH @"/var/mobile/Library/Preferences/com.gilshahar7.duplexclockx.plist"

@interface _UIStatusBarStringView : UIView
@property (assign, nonatomic) NSString *text;
@property NSInteger numberOfLines;
@property (copy) UIFont *font;
@property NSInteger textAlignment;
@end

@interface _UIStatusBarTimeItem : NSObject
@property (assign, nonatomic) _UIStatusBarStringView *shortTimeView;
@property (assign, nonatomic) _UIStatusBarStringView *pillTimeView;
-(id)applyUpdate:(id)arg1 toDisplayItem:(_UIStatusBarStringView *)arg2;
@end

void duplexclockx_settingsDidUpdate(CFNotificationCenterRef center,
                           void * observer,
                           CFStringRef name,
                           const void * object,
                           CFDictionaryRef userInfo) {

	if (settings) {
		settings = nil;
	}
	settings = [NSDictionary dictionaryWithContentsOfFile:PLIST_PATH];
	//[((SBStatusBarStateAggregator *)CFBridgingRelease(observer)) _updateTimeItems];
	[[NSNotificationCenter defaultCenter] postNotificationName:NSSystemClockDidChangeNotification object:nil userInfo:nil];
}

NSDateFormatter *dateFormatter;

%group DuplexClockX
%hook _UIStatusBarTimeItem

-(id)init {

self = %orig;

if (self) {

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myApplyUpdate) name:NSSystemClockDidChangeNotification object:nil];
CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, duplexclockx_settingsDidUpdate, CFSTR("duplexclockx_settingsupdated_notification"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

}

return self;

}



-(id)applyUpdate:(id)arg1 toDisplayItem:(_UIStatusBarStringView *)arg2 {
	id returnThis = %orig;
	[self.shortTimeView setFont: [self.shortTimeView.font fontWithSize:12]];
	[self.pillTimeView setFont: [self.pillTimeView.font fontWithSize:12]];
	return returnThis;
}


%new
-(void)myApplyUpdate{
	[self.shortTimeView setText:@":"];
	[self.pillTimeView setText:@":"];

	
}

%end

%hook _UIStatusBarStringView
-(void)setText:(NSString *)text {
	if([text containsString:@":"]) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		if(is24h){
			[dateFormatter setDateFormat:@"HH:mm"];
		}else{
			[dateFormatter setDateFormat:@"h:mm a"];
		}
		NSString *defaultDateString = [dateFormatter stringFromDate:[NSDate date]];
		[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:settings[@"kTimeZone"]]];
		NSString *secondDateString = [dateFormatter stringFromDate:[NSDate date]];
		NSString *newString = [NSString stringWithFormat:@"%@\n%@",defaultDateString,secondDateString];
		self.numberOfLines = 2;
		self.textAlignment = 1;
		[self setFont: [self.font fontWithSize:12]];
		%orig(newString);
	}else{
		%orig(text);
	}
}
%end
%end

%ctor {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[NSLocale currentLocale]];
	[formatter setDateStyle:NSDateFormatterNoStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	NSString *dateString = [formatter stringFromDate:[NSDate date]];
	NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
	NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
	is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);

	settings = [NSDictionary dictionaryWithContentsOfFile:PLIST_PATH];
	%init(DuplexClockX);

}

