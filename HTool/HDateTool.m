//
//  HDateTool.m
//  HToolDemo
//
//  Created by hare27 on 16/8/6.
//  Copyright © 2016年 hare27. All rights reserved.
//

#import "HDateTool.h"


#define kMinute_count 60
#define kHour_count kMinute_count*60
#define kDay_count kHour_count*24
#define kMonth_count kDay_count*30

@interface HDateTool()

@property(nonatomic,strong)NSCalendar *calendar;

@property(nonatomic,strong)NSDateFormatter *fmt;

@property(nonatomic,copy)NSString *dateFormat;

@end

@implementation HDateTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dateFormatType = HDateFormatTypeYMDHms1;
        self.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    }
    return self;
}

/** 判断一个日期是否今年*/
-(BOOL)dateIsThisYearForDate:(NSDate *)date{
    NSCalendarUnit unit = NSCalendarUnitYear;
    NSDateComponents *cmps_date = [self.calendar components:unit fromDate:date];
    NSDateComponents *cmps_now = [self.calendar components:unit fromDate:[NSDate date]];
    return cmps_now.year == cmps_date.year;
}

/** 判断一个日期是否本月*/
-(BOOL)dateIsThisMonthForDate:(NSDate *)date{
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *cmps_date = [self.calendar components:unit fromDate:date];
    NSDateComponents *cmps_now = [self.calendar components:unit fromDate:[NSDate date]];
    return cmps_now.year == cmps_date.year
    &&cmps_now.month == cmps_date.month;
}

/** 判断一个日期是否今天*/
-(BOOL)dateIsThisDayForDate:(NSDate *)date{
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps_date = [self.calendar components:unit fromDate:date];
    NSDateComponents *cmps_now = [self.calendar components:unit fromDate:[NSDate date]];
    return cmps_now.year == cmps_date.year
    &&cmps_now.month == cmps_date.month
    &&cmps_now.day == cmps_date.day;
}

/** 根据你一个HDateFormatType给NSDateFormatter设置dateFormat属性*/
-(void)setDateFormatr:(NSDateFormatter *)fmt andType:(HDateFormatType)type{
    
    if (fmt == nil) {
        return;
    }
    
    switch (type) {
        case HDateFormatTypeYMDHms1:{
            fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        }
            break;
        case HDateFormatTypeYMDHms2:{
            fmt.dateFormat = @"yyyy年MM月dd日 HH时mm分ss秒";
        }
            break;
        case HDateFormatTypeYMD1:{
            fmt.dateFormat = @"yyyy-MM-dd";
        }
            break;
        case HDateFormatTypeYMD2:{
            fmt.dateFormat = @"yyyy年MM月dd日";
        }
            break;
        case HDateFormatTypeMD1:{
            fmt.dateFormat = @"MM-dd";
        }
            break;
        case HDateFormatTypeMD2:{
            fmt.dateFormat = @"MM月dd日";
        }
            break;
        case HDateFormatTypeHms1:{
            fmt.dateFormat = @"HH:mm:ss";
        }
            break;
        case HDateFormatTypeHms2:{
            fmt.dateFormat = @"HH时mm分ss秒";
        }
            break;
    }
}

/** 根据时间样式，获取dateformatter对象*/
-(NSDateFormatter *)dateFormatWithType:(HDateFormatType)fmtType{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [self setDateFormatr:fmt andType:fmtType];
    return fmt;
}

/** 根据时间样式，获取date对应的字符串*/
-(NSString *)getStringWithType:(HDateFormatType)fmtType FromeDate:(NSDate *)date{
    if (date) {
        self.dateFormatType = fmtType;
        return [self.fmt stringFromDate:date];
    }else{
        return nil;
    }
}
/** 根据样式，获取date对应的字符串*/
-(NSString *)getStringWithFormat:(NSString *)format FromeDate:(NSDate *)date{
    if (date) {
        self.dateFormat = format;
        return [self.fmt stringFromDate:date];
    }else{
        return nil;
    }
}

/**
 *  获取一个时间距离现在的时间描述
 *  例如：刚刚/5分钟前/5小时前/昨天/多少天前/11月12/2014年11月
 *  昨天23：59分显示为昨天
 */
-(NSString *)getStringSinceNowForDate:(NSDate *)date{
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps_date = [self.calendar components:unit fromDate:date];
    NSDate *date_temp = [NSDate date];
    NSDateComponents *cmps_now = [self.calendar components:unit fromDate:date_temp];
    
    if (cmps_now.year != cmps_date.year) {
        return [NSString stringWithFormat:@"%d年%d月%d日",(int)cmps_date.year,(int)cmps_date.month,(int)cmps_date.day];
    }else if(cmps_now.month != cmps_date.month) {
        return [NSString stringWithFormat:@"%d月%d日%d点",(int)cmps_date.month,(int)cmps_date.day,(int)cmps_date.hour];
    }else if(cmps_now.day - cmps_date.day > 1) {
        return [NSString stringWithFormat:@"%d月%d日%d点",(int)cmps_date.month,(int)cmps_date.day,(int)cmps_date.hour];
    }else if(cmps_now.day - cmps_date.day == 1) {
        return [NSString stringWithFormat:@"昨天%d点%d分",(int)cmps_date.hour,(int)cmps_date.minute];
    }else if(cmps_now.day - cmps_date.day < 0) {
        return @"系统时间错误";
    }
    
    return [self detailStringSinceNowForDate:date];
    
}

/**
 *  获取一个时间距离现在的时间具体描述
 *  例如：刚刚/5分钟前/5小时前/昨天/多少天前/11月12/2014年11月
 *  昨天23：59分显示为多少小时前或多少分钟前
 */
-(NSString *)detailStringSinceNowForDate:(NSDate *)date{
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [self.calendar components:unit fromDate:date toDate:[NSDate date] options:0];
    
    if (cmps.year) {
        return [NSString stringWithFormat:@"%d年前",(int)cmps.year];
    }else if(cmps.month){
        return [NSString stringWithFormat:@"%d个月前",(int)cmps.month];
    }else if(cmps.day){
        return [NSString stringWithFormat:@"%d天前",(int)cmps.day];
    }else if(cmps.hour){
        return [NSString stringWithFormat:@"%d个小时前",(int)cmps.hour];
    }else if(cmps.minute){
        return [NSString stringWithFormat:@"%d分钟前",(int)cmps.minute];
    }else{
        return @"刚刚";
    }
    
}


-(void)setDateFormatType:(HDateFormatType)dateFormatType{
    _dateFormatType = dateFormatType;
    [self setDateFormatr:self.fmt andType:dateFormatType];
}

-(void)setDateFormat:(NSString *)dateFormat{
    self.fmt.dateFormat = dateFormat;
}

- (NSCalendar *)calendar {
	if(_calendar == nil) {
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            _calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        }else{
            _calendar = [NSCalendar currentCalendar];
        }
	}
	return _calendar;
}

- (NSDateFormatter *)fmt {
	if(_fmt == nil) {
		_fmt = [[NSDateFormatter alloc] init];
        _fmt.dateFormat = self.dateFormat;
	}
	return _fmt;
}
@end
