//
//  Created by Vladimir Nabokov on 12/12/13.
//  Copyright (c) 2013 Anil Can Baykal. All rights reserved.
//

#import "RNDUtil.h"
#import <objc/runtime.h>
#import <float.h>
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <EventKit/EventKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#ifndef STR_EMPTY
#define STR_EMPTY   @""
#endif

#ifndef STR_SPACE
#define STR_SPACE @" "
#endif

#ifndef MAX_LEN_PHONE
#define MAX_LEN_PHONE (10)
#endif


@implementation RNDUtil

/*! Returns system base (iOS) version
 \return system base (iOS) version
 */
+ (NSUInteger)systemBaseVersion {
    return [[[[UIDevice currentDevice] systemVersion]substringToIndex:1]integerValue];
}

/*! Returns flag is device is 4inch
 \return device is 4inch
 */
+ (BOOL)isFourInch {
    
    return ([UIScreen mainScreen].bounds.size.height == 568);
}

/*! Converts NSDate object to NSString in long format "dd.MM.yyyy ccc"
 \param date NSDate object
 \return date string
 */
+ (NSString*)date2StrLong:(NSDate*)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy ccc"];
    NSString *strDate = [formatter stringFromDate:date];
    
    //TODO - current locale
    
    strDate = [strDate stringByReplacingOccurrencesOfString:@"Mon" withString:@"Ptesi"];
    strDate = [strDate stringByReplacingOccurrencesOfString:@"Tue" withString:@"Salı"];
    strDate = [strDate stringByReplacingOccurrencesOfString:@"Wed" withString:@"Çrş"];
    strDate = [strDate stringByReplacingOccurrencesOfString:@"Thu" withString:@"Perş"];
    strDate = [strDate stringByReplacingOccurrencesOfString:@"Fri" withString:@"Cuma"];
    strDate = [strDate stringByReplacingOccurrencesOfString:@"Sat" withString:@"Ctesi"];
    strDate = [strDate stringByReplacingOccurrencesOfString:@"Sun" withString:@"Pzr"];
    
    return strDate;
    
}

/*! Converts NSDate object to NSString in short format @"dd.MM.yyyy"
 \param date NSDate object
 \return date string
 */
+ (NSString*)date2Str:(NSDate*)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    NSString *strDate = [formatter stringFromDate:date];
    
    return strDate;
}

/*! Converts NSString object in format @"dd.MM.yyyy" to NSDate
 \param str NSString object
 \return NSDate object
 */
+ (NSDate*)str2Date:(NSString*)str {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    
    NSDate *date = [dateFormatter dateFromString:str];
    return date;
}

/*! Returns name of the week day in Turkish
 \param index index of the day, 0-Sunday
 \param isLong (long:Pazar, short:PZR)
 \return name of the the week day
 */
+ (NSString*)weekTextTr:(NSUInteger)index isLong:(BOOL)isLong {
    NSArray *arrayWeekDay = @[@"PZR",@"PTS",@"SALI",@"ÇRŞ",@"PRŞ",@"CUMA",@"CTS"];
    NSArray *arrayWeekDayLong = @[@"Pazar",@"Pazartesi",@"Salı",@"Çarşamba",@"Perşembe",@"Cuma",@"Cumartesi"];
    
    if(index > 0 && index < [arrayWeekDay count]+1 ) {
        return (isLong ? arrayWeekDayLong[index-1] : arrayWeekDay[index-1]);
    }
    else {
        return nil;
    }
}

/*! Returns name of the Month in Turkish
 \param index index of the month
 \param isLong (long:Ocak, short:OCK)
 \return name of the the month
 */
+ (NSString*)monthTextTr:(NSUInteger)index isLong:(BOOL)isLong {
    
    //TODO - short names
    NSArray *arrayMonth = @[@"Ocak",
                            @"Şubat",
                            @"Mart",
                            @"Nisan",
                            @"Mayıs",
                            @"Haziran",
                            @"Temmuz",
                            @"Aǧustos",
                            @"Eylül",
                            @"Ekim",
                            @"Kasım",
                            @"Aralık"];
    
    NSArray *arrayMonthLong = @[@"Ocak",
                                @"Şubat",
                                @"Mart",
                                @"Nisan",
                                @"Mayıs",
                                @"Haziran",
                                @"Temmuz",
                                @"Aǧustos",
                                @"Eylül",
                                @"Ekim",
                                @"Kasım",
                                @"Aralık"];
    
    if(index > 0 && index < [arrayMonth count]+1 ) {
        return (isLong ? arrayMonthLong[index-1] : arrayMonth[index-1]);
    }
    else {
        return nil;
    }
}

/*! Decides if object is nil/not-NSString or empty string
 \param str object to evaluate
 \return object is nil/not-NSString or empty string
 */
+ (BOOL)strNilOrEmpty:(id)str {
    if(str == nil) {
        return YES;
    }
    else if([str isKindOfClass:[NSString class]]) {
        if([(NSString*)str length] == 0) {
            return YES;
        }
    }
    else {
        return YES;
    }
    
    return NO;
}

/*! Returns current month index
 \return current month index
 */
+ (NSString*)currentMonth {
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    NSInteger month = [components month];
    return [NSString stringWithFormat:@"%d",month];
    
    
}

/*! Returns current year index
 \return current year index
 */
+ (NSString*)currentYear {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    NSInteger year = [components year];
    return [NSString stringWithFormat:@"%d",year];
}

/*! Returns YES if device is Pad
 \return YES if device is Pad
 */
+ (BOOL)deviceIsPad {
    UIDevice *device = [UIDevice currentDevice];
    return (![[device model] isEqualToString:@"iPhone"]);
}

#define TC_NO_LEN (11)
/*! Validates T.C. no
 \param input T.C. no in NSString
 \return YES if validation is passed
 */
+ (BOOL)checkTcNo:(NSString*)input {
    
    //check chars
    if (![[input stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] isEqualToString:STR_EMPTY]) {
        return NO;
    }
    
    //check lenght
    if([input length] != TC_NO_LEN) {
        return NO;
    }
    
    
    /*http://forum.ceviz.net/beyin-firtinasi/106546-tc-kimlik-numarasinin-algoritmasi.html*/
    //check algo
    unsigned long long ATCNO, BTCNO, TcNo;
    long C1,C2,C3, C4, C5,C6,C7,C8, C9,Q1,Q2;
    
    TcNo = [input longLongValue];
    
    ATCNO = TcNo / 100;
    BTCNO = TcNo / 100;
    
    C1 = ATCNO % 10;  ATCNO = ATCNO / 10 ;
    C2 = ATCNO % 10;  ATCNO = ATCNO / 10 ;
    C3 = ATCNO % 10;  ATCNO = ATCNO / 10 ;
    C4 = ATCNO % 10;  ATCNO = ATCNO / 10 ;
    C5 = ATCNO % 10;  ATCNO = ATCNO / 10 ;
    C6 = ATCNO % 10;  ATCNO = ATCNO / 10 ;
    C7 = ATCNO % 10;  ATCNO = ATCNO / 10 ;
    C8 = ATCNO % 10;  ATCNO = ATCNO / 10 ;
    C9 = ATCNO % 10;  ATCNO = ATCNO / 10 ;
    Q1 = ((10-((((C1+C3+C5+C7+C9)*3)+(C2+C4+C6+C8))%10))%10);
    Q2 = ((10-(((((C2+C4+C6+C8)+Q1)*3)+(C1+C3+C5+C7+C9))%10))%10);
    
    return ((BTCNO * 100)+(Q1 * 10)+Q2 == TcNo);
    //return YES;
    
}


//inline
int * split(const char * word){
    
    int len = strlen(word);
    long long number = atoll(word);//[word longLongValue];
    
    int * result = (int*)malloc(len * sizeof(int));
    
    
    for( --len ; len >= 0; len--){
        int rem = number % 10;
        result[len] = rem;
        number -= rem;
        number = number/10;
    }
    
    return result;
    
}

+ (BOOL)checkTcNo2:(NSString *)tckNo {
    //http://tr.wikipedia.org/wiki/T%C3%BCrkiye_Cumhuriyeti_Kimlik_Numaras%C4%B1
    
    int * array = split([tckNo cStringUsingEncoding:NSUTF8StringEncoding]);

    // ilk 10 rakamın toplamının birler basamağı, 11. rakamı vermekte.
    int sum = 0;
    for(int i =  0; i <10; i++)
        sum += array[i];
    
    if ( sum % 10 != array[10])
        return NO;
    
    //1, 3, 5, 7 ve 9. rakamın toplamının 7 katı ile
    //2, 4, 6 ve 8. rakamın toplamının 9 katının toplamının birler basamağı
    //10. rakamı
    int sum1 = array[0]+array[2]+array[4]+array[6]+array[8];
    int sum2 = array[1]+array[3]+array[5]+array[7];
    int rest1 = ((sum1 * 7 ) + (sum2 * 9)) % 10;
    if ( rest1 != array[9])
        return NO;
    
    // 1, 3, 5, 7 ve 9. rakamın toplamının 8 katının birler basamağı
    // 11. rakamı vermektedir
    int rest2 = (sum1 * 8) %10;
    if ( rest2 != array[10])
        return NO;
    
    
    free(array);
    return YES;
}

+ (NSString*)randomTcNo {
    
    NSString * tck = [NSString stringWithFormat:@"%d%d%d" ,
                      (arc4random()%9000) + 999,
                      (arc4random()%9000) + 999,
                      (arc4random()%900) + 99];
    
    return tck;
}

/**
 *  randomString
 *
 *  @param len lenth of the string
 *
 *  @return random lowercase string of lenght len
 */
+(NSString*)randomLowercaseString:(NSUInteger)len {
    
    NSMutableString* string = [NSMutableString stringWithCapacity:len];
    for (int i = 0; i < len; i++) {
        [string appendFormat:@"%C", (unichar)('a' + arc4random_uniform(25))];
    }
    return string;
}

+(NSString*)randomNumericString:(NSUInteger)len {
    
    NSMutableString* string = [NSMutableString stringWithCapacity:len];
    for (int i = 0; i < len; i++) {
        [string appendFormat:@"%C", (unichar)('0' + arc4random_uniform(9))];
    }
    return string;
}

/*! Adds right bar button to controller's navigation item
 \param title title of the button
 \param controller ViewController which navigation item the button will be added
 \param action action selector of the button
 */
+ (void)addRightBarButtonWithTitle:(NSString*)title toViewController:(UIViewController*)controller withAction:(SEL)action {
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithTitle:title
                               style:UIBarButtonItemStyleBordered
                               target:controller
                               action:action];
    controller.navigationItem.rightBarButtonItem = button;
    
}

/*! Removes right bar button from controller's navigation item
 \param controller ViewController which navigation item the button will be removed
 */
+ (void)removeRightBarButton:(UIViewController*)controller {
    
    controller.navigationItem.rightBarButtonItem = nil;
    
}

/*! Disables right bar button on controller's navigation item
 \param controller ViewController which navigation item the button will be disabled
 */
+ (void)disableBackBarButton:(UIViewController*)controller {
    
    controller.navigationItem.hidesBackButton = YES;
    
}

/*! Disables subviews of view under view's hiyerarchy
 \param view the view which subviews will be disabled
 */
+ (void)disableSubviews:(UIView*)view {
    for(UIView *subview in view.subviews) {
        
        if([subview isMemberOfClass:[UIView class]]) {
             [self disableSubviews:subview];
        }
        else {
            [subview setUserInteractionEnabled:NO];
        }
        
    }
}

/*! Enables subviews of view under view's hiyerarchy
 \param view the view which subviews will be enabled
 */
+ (void)enableSubviews:(UIView*)view {
    for(UIView *subview in view.subviews) {
        
        if([subview isMemberOfClass:[UIView class]]) {
             [self enableSubviews:subview];
        }
        else if( [subview isKindOfClass:[UIButton class]]     ||
                [subview isKindOfClass:[UITextField class]]       ||
                [subview isKindOfClass:[UITextView class]]        ||
                [subview isKindOfClass:[UITableView class]]       ||
                [subview isKindOfClass:[UIScrollView class]]      ||
                [subview isKindOfClass:[UIPickerView class]])
        {
            
            if([subview isMemberOfClass:[UIPickerView class]]) {
                NSLog(@"UIPickerView");
            }
            if([subview isMemberOfClass:[UIImageView class]]) {
                NSLog(@"UIImageView");
            }
            
            [subview setUserInteractionEnabled:YES];
        }
        
    }
}

/*! Pushes view controller on anohter view controller in a custom fashion
 \param vcTop ViewController which will be pushed
 \param vcButtom ViewController which will be pushed on
 */
+ (void)pushViewController:(UIViewController*)vcTop on:(UIViewController*)vcBottom {
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [vcTop.view setAlpha:0.0f];
        [vcBottom.view addSubview:vcTop.view];
        [UIView animateWithDuration:0.6 animations:^{
            [vcTop.view setAlpha:1.0f];
        }];
    }
    else {
        
        [vcBottom.navigationController pushViewController:vcTop animated:YES];
        return;
        
        [UIView beginAnimations:@"View Flip" context:nil];
        [UIView setAnimationDuration:0.80];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [UIView setAnimationTransition:
         UIViewAnimationTransitionNone
                               forView:vcBottom.navigationController.view cache:NO];
        
        
        [vcBottom.navigationController pushViewController:vcTop animated:YES];
        [UIView commitAnimations];
    }
}

/*! Pops view controller  in a custom fashion
 \param controller ViewController which will be poped
 */
+ (void)popViewController:(UIViewController*)controller {
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        [UIView animateWithDuration:0.6 animations:^{
            [controller.view setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [controller.view removeFromSuperview];
        }];
    }
    else {
        [controller.navigationController popViewControllerAnimated:YES];
    }
}


/*! Validates e-mail address (use validateEmailAddress:)
 \param checkString e-mail address in NSString
 \return YES if validation is passed
 */
//http://stackoverflow.com/a/3638271/644258
+ (BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

/*! Validates e-mail address
 \param checkString e-mail address in NSString
 \return YES if validation is passed
 */
+ (BOOL)validateEmailAddress:(NSString*)emailAddress {
    
    
    if(emailAddress == nil) {
        return NO;
    }
    if([emailAddress length] == 0) {
        return NO;
    }
    if([emailAddress rangeOfString:@"@"].location == NSNotFound) {
        return NO;
    }
    if([emailAddress rangeOfString:@"."].location == NSNotFound) {
        return NO;
    }
    
    return [[self class]isValidEmail:emailAddress];
    
}

/*! Evaluates string object if it has numeric substring
 \param str string to evaluate
 \return YES if string has numberic substring
 */
+ (BOOL)hasNumeric:(NSString*)str {
    
    NSScanner *sc = [NSScanner scannerWithString:str];
    return [sc scanFloat:NULL];
    
}

/*! Evaluates string object if it has numeric value
 \param str string to evaluate
 \return YES if string has numberic value
 */
+ (BOOL)isNumberic:(NSString*)str {
    
    NSCharacterSet *nums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:str];
    BOOL valid = [nums isSupersetOfSet:inStringSet];
    
    return valid;
}


/*! Evaluates string object if it consist of alpha values
 \param str string to evaluate
 \return YES if string is consist of alphabetic values
 */
+ (BOOL)isAlpha:(NSString*)str {
    
    if(str == nil) {return NO;}
    if([str isEqualToString:STR_EMPTY]) {return NO;}
    
    NSCharacterSet *alphas = [NSCharacterSet letterCharacterSet];
    NSCharacterSet *space = [NSCharacterSet whitespaceCharacterSet];
    NSMutableCharacterSet *superSet = [[NSMutableCharacterSet alloc]init];
    
    [superSet formUnionWithCharacterSet:alphas];
    [superSet formUnionWithCharacterSet:space];
    
    
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:str];
    BOOL valid = [superSet isSupersetOfSet:inStringSet];
    
    return valid;
}

/*! Validates phone number string
 \param phoneNo phone number in NSString
 \return YES if validation is passed
 */
+ (BOOL)validatePhone:(NSString*)phoneNo {
    
    phoneNo = [phoneNo stringByReplacingOccurrencesOfString:STR_SPACE withString:@""];
    
    if(phoneNo == nil) {
        return NO;
    }
    if([phoneNo length] != MAX_LEN_PHONE) {
        return NO;
    }
 
    return [[self class]isNumberic:phoneNo];
}

/*! Checks the date passed is older
 \param aDate date to check
 \return YES if the date is older
 */
+ (BOOL)dateIsOlder:(NSDate*)aDate {
    BOOL retVal = NO;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:[NSDate date]
                                                 toDate:aDate
                                                options:0];
    
    
    retVal = (components.year < 0) || (components.month < 0) || (components.day < 0);
    
    return retVal;
}

/*! Checks the date passed is later
 \param aDate date to check
 \return YES if the date is later
 */
+ (BOOL)dateIsLater:(NSDate*)aDate {
    BOOL retVal = NO;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:[NSDate date]
                                                 toDate:aDate
                                                options:0];
    
    
    retVal = (components.year > 0) || (components.month > 0) || (components.day > 0);
    
    return retVal;
}

/*! Checks NSLocale currentLocale if its tr_TR
 \return YES if currentLocale is tr_TR
 */
+ (BOOL)isTrLocalized {
    
    return YES;//MOD - isTrLocalized
    
    BOOL retVal = YES;
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *strLocale = [locale localeIdentifier];
    
    /*
     en_US
     tr_TR
     */
    if([strLocale rangeOfString:@"tr_TR"].location == NSNotFound) {
        retVal = NO;
    }
    
    return retVal;
}

/*! Trims string in word-wrapping fashion with passed font and maxWidht
 \param string string to trim
 \param font font of the text
 \param maxWidth max-widht of the UI object
 \return trimmmed string
 */
+ (NSString*)trimString:(NSString*)string wihtFont:(UIFont*)font fromSize:(CGSize)size toWidth:(CGFloat)maxWidth {
    //...
    float width = [string sizeWithFont:font
                     constrainedToSize:size
                         lineBreakMode:NSLineBreakByWordWrapping].width;
    
    if(width > maxWidth) {
        while(width > maxWidth) {
            string = [string substringToIndex:[string length]-1];
            
            width = [string sizeWithFont:font
                       constrainedToSize:size
                           lineBreakMode:NSLineBreakByWordWrapping].width;
        }
        
        string = [NSString stringWithFormat:@"%@...",[string substringToIndex:[string length]-3]];
        
        
    }
    //...
    
    return string;
}


/*! Shows warn floating+half-transparent view on the view
 \param warnMsg text of the message
 \return onView UI-object to show floating view on.
 */
+ (void)warnMsg:(NSString*)warnMsg near:(UIView*)onView {
    
    static BOOL isVisible = NO;
    
    if(isVisible)   {return;}
    
    static CGFloat padX = 25.0f;
    static CGFloat padY = 18.0f;
    
    CGRect rect = onView.frame;
    rect.origin.x += padX;
    rect.origin.y -= padY;
    rect.size.width -= padX;
    rect.size.height += 2*padY;
    
    UILabel *lblWarn = [[UILabel alloc]initWithFrame:rect];
    
    [lblWarn setBackgroundColor:[UIColor blackColor]];
    [lblWarn setAlpha:0.0f];
    [lblWarn setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [lblWarn setTextColor:[UIColor colorWithWhite:0.962 alpha:1.000]];
    [lblWarn setTextAlignment:NSTextAlignmentCenter];
    [lblWarn setNumberOfLines:3];
    [lblWarn setText:warnMsg];
    
    [lblWarn.layer setCornerRadius:3.0f];
    
    isVisible = YES;
    
    [onView.superview addSubview:lblWarn];
    
    [UIView animateWithDuration:0.3 animations:^{
        [lblWarn setAlpha:0.7];
    }completion:^(BOOL finished) {
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:0.4f animations:^{
                [lblWarn setAlpha:0.0f];
            }completion:^(BOOL finished) {
                [lblWarn removeFromSuperview];
                isVisible = NO;
            }];
        });
    }];
    
    
}


/*! Evaluates the passed string if it's a backspace
 \param string string to evaluate
 \return YES if string is a backspace
 */
+ (BOOL)isBackSpace:(NSString*)string
{
    const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
    return (strcmp(_char, "\b") == -8);
    
    
}

/*! Setups widht of the image DOM-objects in an HTML document
 \param strHtml HTML document string
 \param imgWidht widht of the image
 \return new HTML document string
 */
+ (NSString*)html:(NSString*)strHtml setImageWidth:(CGFloat)imgWidht {
    return strHtml;//TODO
}

/*! Hides mendatory count of prefixed chars. in the passed string
 \param text text to be modified
 \param charCount count of prefixed chars to be visible
 \param seperator separator char.
 \return modified text
 */
+ (NSString*)textHidden:(NSString*)text visibleCharCount:(NSUInteger)charCount seperator:(NSString*)seperator{
    
    if([[self class]strNilOrEmpty:text])    { return nil; }     
    if(charCount > [text length])   { return nil; }     
    
    NSMutableString *finalStr = [[NSMutableString alloc]init];
    NSArray *components = [text componentsSeparatedByString:seperator];
    for(__strong NSString *component in components) {
        NSUInteger i = 0;
        
        for(i=charCount ; i<[component length]; i++) {
            NSRange range = NSMakeRange(i, 1);
            component = [component stringByReplacingCharactersInRange:range withString:@"*"];
            
        }
        [finalStr appendFormat:@"%@%@",component, seperator];
    }
    
    return [finalStr substringToIndex:[finalStr length]-[seperator length]];
    
}
/**
 *  <#Description#>
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+ (NSString*)seperateCcNumber:(NSString*)string {
    const NSUInteger len = 4;
    NSMutableString *newString = [[NSMutableString alloc]init];
    for(int i=0; i < [string length]/len; i++) {
        NSString *digs = [string substringWithRange:NSMakeRange(i*len, MIN(len,[string length]-i*len))];
        [newString appendFormat:@"%@ ",digs];
    }
    [newString deleteCharactersInRange:NSMakeRange([newString length]-1, 1)];
    
    return [NSString stringWithString:newString];
}

/*! Gets UILabel object and a text and returns the count of the lines according to the font.
 \param font Font of the text
 \param text Text of the label
 \param width width of the label
 \return count of the lines
 */
+ (int)lineCountForFont:(UIFont *)font withText:(NSString*)text withWidth:(CGFloat)widht {
    CGSize constrain = CGSizeMake(widht, INT_MAX);
    CGSize size = [text sizeWithFont:font constrainedToSize:constrain lineBreakMode:NSLineBreakByWordWrapping];
    
    return ceil(size.height / font.lineHeight);
}

/**
 *  StatusBar frame value relative to UIView passed
 *
 *  @param view the which coordinates view status bar frame will be converted upon
 *
 *  @return relative status bar frame
 */
+ (CGRect)statusBarFrameViewRect:(UIView*)view
{
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect statusBarWindowRect = [view.window convertRect:statusBarFrame fromWindow: nil];
    CGRect statusBarViewRect = [view convertRect:statusBarWindowRect fromView: nil];
    
    return statusBarViewRect;
}

/**
 *  Unique device Id
 *  https://developer.apple.com/library/prerelease/ios/releasenotes/General/WhatsNewIniOS/Articles/iOS7.html
 *
 *  @return device id
 */
+ (NSString*)deviceId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
/**
 *  Gets the SSID info dict of the wireless (Wi-fi) adaptor
 */
+ (NSDictionary*)getSSIDInfo {
    
    NSDictionary *retVal = nil;
    CFArrayRef arrayInterface = CNCopySupportedInterfaces();
    if(arrayInterface) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(arrayInterface, 0));
        NSDictionary *dict = (__bridge NSDictionary*)dictRef;
        retVal = dict;
        
    }
    return retVal;
}

/**
 *  Returns SSID value of the network adaport
 *
 */
+ (NSString*)getSSID {
    return [self getSSIDInfo][@"BSSID"];
}

/**
 *  Gets phones carrier info
 */
+ (NSDictionary*)getCarrierInfo {
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    if(carrier) {
        id obj = carrier;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        unsigned count;
        objc_property_t *properties = class_copyPropertyList([obj class], &count);
        
        for (int i = 0; i < count; i++) {
            NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
            [dict setObject:[obj valueForKey:key] forKey:key];
        }
        
        free(properties);
        
        return [NSDictionary dictionaryWithDictionary:dict];
    }
    else {
        return nil;
    }
    
}


/**
 *  Returns phones carrier name
 *
 */
+ (NSString*)getCarrierName {
    return [self getCarrierInfo][@"carrierName"];
}

/**
 *  get dimished color
 *
 *  @param color color in interest
 *
 *  @return dimished color
 */
+ (UIColor*)diminishedColor:(UIColor*)color {
    
    float hue;
    float satur;
    float brightness;
    float alpha;
    
    [color getHue:&hue saturation:&satur brightness:&brightness alpha:&alpha];
    
    
    if(brightness > 0.8) {
        if(satur > 0.8) {
            hue *= 1.5;
            if(hue > 1) {
                hue = 1;
            }
            
        }
        if(satur == 0) {
            satur = 0.05f;
            
        }
        else {
            satur *= 1.5;
            if(satur > 1) {
                satur = 1;
            }
        }
    }
    else {
        brightness *= 1.5;
        if(brightness > 1) {
            brightness = 1;
        }
    }
    
    alpha = 0.7f;
    UIColor *newColor = [UIColor colorWithHue:hue saturation:satur brightness:brightness alpha:alpha];
    
    return newColor;
    
}

/**
 *  image scaled to new size
 *
 *  @param image   image to scale
 *  @param newSize size
 *
 *  @return new image
 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  Add event to calender
 *
 *  @param title     title
 *  @param notes     notes for event
 *  @param startDate start date
 *  @param endDate   end date
 *  @param allDay    is all day
 *
 *  @return YES if succeed
 */
+ (void)addEvent:(NSString*)title withNotes:(NSString*)notes startDate:(NSDate*)startDate endDate:(NSDate*)endDate isAllDay:(BOOL)allDay complation:(void(^)(BOOL succeed))complation {

    __block BOOL retVal = NO;
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
         {
             if (granted)
             {
                 EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                 event.title  = title;
                 event.notes = notes;
                 event.allDay = allDay;
                 event.startDate = startDate;
                 event.endDate = endDate;
                 
                 [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                 NSError *err = nil;
                 
                 BOOL flag = [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                 
                 if(flag && err == nil) {
                     retVal = YES;
                 }

             }
             complation(retVal);
         }];
    }
    else
    {
        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
        event.title  = title;
        event.notes = notes;
        event.allDay = allDay;
        event.startDate = startDate;
        event.endDate = endDate;
        
    
        [event setCalendar:[eventStore defaultCalendarForNewEvents]];
        NSError *err;
        
        BOOL flag = [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        
        if(flag && err == nil) {
            retVal = YES;
        }
        complation(retVal);
    }
    

}

/**
 *  Adds remainder
 *
 *  @param title title of remainder
 *  @param date  date of remainder
 */
+ (void)addReminder:(NSString*)title withDate:(NSDate*)date complation:(void(^)(BOOL succeed))complation {
    
    __block BOOL retVal = NO;
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error)
         {
             if (granted)
             {
                 EKReminder *reminder = [EKReminder reminderWithEventStore:eventStore];
                 
                 reminder.title = title;
                 reminder.calendar = [eventStore defaultCalendarForNewReminders];
                 EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:date];
                 [reminder addAlarm:alarm];
                 NSError *error = nil;
                 BOOL flag = [eventStore saveReminder:reminder commit:YES error:&error];
                 
                 if(flag && error == nil) {
                     retVal = YES;
                 }
   
             }
             complation(retVal);
         }];
    }
    else
    {
        EKReminder *reminder = [EKReminder reminderWithEventStore:eventStore];
        
        reminder.title = title;
        reminder.calendar = [eventStore defaultCalendarForNewReminders];
        EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:date];
        [reminder addAlarm:alarm];
        
        NSError *error = nil;
        BOOL flag = [eventStore saveReminder:reminder commit:YES error:&error];
        
        if(flag && error == nil) {
            retVal = YES;
        }
        complation(retVal);
        
    }
    

}
/**
 *  Calls number, eh?
 */
+ (void)callNumber:(NSString*)strNumber {
     [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",strNumber ]]];
}

/**
 *  return system volue level (0.0-1.0)
 */
+ (float)getSystemVolumeLevel {
    
    float retVal = -1;

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    
    retVal = [audioSession outputVolume];
    return retVal;
}

/**
 *  gets system disk space in bytes
 *
 *  @param diskSpace system disk space
 *  @param freeSpace system free disk space
 *
 *  @return YES if succeed
 */
+ (BOOL)getDiskspace:(uint64_t*)diskSpace freeSpace:(uint64_t*)freeSpace {
    
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    BOOL retVal = YES;
    
    __autoreleasing NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
    }
    else {
        retVal = NO;
        NSLog(@"Error Obtaining System Memory Info: %@", [error localizedDescription]);
    }
    
    if(retVal) {
        *diskSpace = totalSpace;
        *freeSpace = totalFreeSpace;
    }
    
    return retVal;
}

/**
 *  <#Description#>
 *
 *  @param clearPath <#clearPath description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)clearPath:(NSString*)clearPath {
    
    BOOL retVal = YES;
    NSString *file;
    
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:clearPath];
    NSError* error;
    while (file = [dirEnum nextObject]) {
        error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:[clearPath stringByAppendingPathComponent:file] error:&error];
        if(error) {
            retVal = NO;//smth went wrong
        }
        
    }
    return retVal;

}

//http://stackoverflow.com/a/13000074/644258
static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}

/**
 *  classPropsFor
 *
 *  @param klass <#klass description#>
 *
 *  @return <#return value description#>
 */
+ (NSDictionary *)classPropsFor:(Class)klass
{
    if (klass == NULL) {
        return nil;
    }
    
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(klass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            NSString *propertyType = [NSString stringWithUTF8String:propType];
            [results setObject:propertyType forKey:propertyName];
        }
    }
    free(properties);
    
    // returning a copy here to make sure the dictionary is immutable
    return [NSDictionary dictionaryWithDictionary:results];
}

@end
