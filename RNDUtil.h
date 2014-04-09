//
//  Created by Vladimir Nabokov on 12/12/13.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface RNDUtil : NSObject

+ (BOOL)isFourInch;
+ (NSUInteger)systemBaseVersion;


+ (NSString*)date2Str:(NSDate*)date;
+ (NSDate*)str2Date:(NSString*)str;
+ (NSString*)date2StrLong:(NSDate*)date;

+ (NSString*)weekTextTr:(NSUInteger)index isLong:(BOOL)isLong;
+ (NSString*)monthTextTr:(NSUInteger)index isLong:(BOOL)isLong;

+ (NSString*)currentMonth;
+ (NSString*)currentYear;
+ (BOOL)deviceIsPad;
+ (BOOL)checkTcNo:(NSString*)input;
+ (BOOL)checkTcNo2:(NSString *)tckNo;
+ (NSString*)randomTcNo;
+(NSString*)randomLowercaseString:(NSUInteger)len;
+(NSString*)randomNumericString:(NSUInteger)len;

+ (BOOL)strNilOrEmpty:(id)str;

+ (void)addRightBarButtonWithTitle:(NSString*)title toViewController:(UIViewController*)controller withAction:(SEL)action;
+ (void)removeRightBarButton:(UIViewController*)controller;
+ (void)disableBackBarButton:(UIViewController*)controller;

+ (void)disableSubviews:(UIView*)view;
+ (void)enableSubviews:(UIView*)view;

+ (void)pushViewController:(UIViewController*)vcTop on:(UIViewController*)vcBottom;
+ (void)popViewController:(UIViewController*)controller;

+ (BOOL)validateEmailAddress:(NSString*)emailAddress;
+ (BOOL)validatePhone:(NSString*)phoneNo;
+ (BOOL)dateIsOlder:(NSDate*)aDate;
+ (BOOL)dateIsLater:(NSDate*)aDate;

+ (BOOL)hasNumeric:(NSString*)str;
+ (BOOL)isNumberic:(NSString*)str;
+ (BOOL)isAlpha:(NSString*)str;

+ (BOOL)isTrLocalized;

+ (NSString*)trimString:(NSString*)string wihtFont:(UIFont*)font fromSize:(CGSize)size toWidth:(CGFloat)maxWidth;
+ (void)warnMsg:(NSString*)warnMsg near:(UIView*)onView;

+ (BOOL)isBackSpace:(NSString*)string;

+ (NSString*)seperateCcNumber:(NSString*)string;
+ (NSString*)textHidden:(NSString*)text visibleCharCount:(NSUInteger)charCount seperator:(NSString*)seperator;

+ (int)lineCountForFont:(UIFont *)font withText:(NSString*)text withWidth:(CGFloat)widht;
+ (CGRect)statusBarFrameViewRect:(UIView*)view;

+ (UIColor*)diminishedColor:(UIColor*)color;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+ (NSString*)deviceId;
+ (NSDictionary*)getSSIDInfo;
+ (NSString*)getSSID;
+ (NSDictionary*)getCarrierInfo;
+ (NSString*)getCarrierName;

+ (void)addEvent:(NSString*)title
       withNotes:(NSString*)notes
       startDate:(NSDate*)startDate
         endDate:(NSDate*)endDate
        isAllDay:(BOOL)allDay
      complation:(void(^)(BOOL succeed))complation;

+ (void)addReminder:(NSString*)title
           withDate:(NSDate*)date
         complation:(void(^)(BOOL succeed))complation;

+ (NSArray *)collectAddressBookContacts;
+ (void)callNumber:(NSString*)strNumber;

+ (float)getSystemVolumeLevel;
+ (BOOL)getDiskspace:(uint64_t*)diskSpace freeSpace:(uint64_t*)freeSpace;

+ (BOOL)clearPath:(NSString*)clearPath;
+ (NSString *)splitOnCapital:(NSString*)str;

+ (void)getAddress:(CLLocationCoordinate2D)coordinate withComplation:(void(^)(BOOL success,
                                                                              NSError *error,
                                                                              NSString *title,
                                                                              NSString *subtitle,
                                                                              NSDictionary *addressDictionary))complation;

@end
