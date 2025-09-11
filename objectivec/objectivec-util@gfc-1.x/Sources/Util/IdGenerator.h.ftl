<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
#import <Foundation/Foundation.h>

@interface IdGenerator : NSObject

@property (nonatomic, assign, readonly) NSInteger workerID;
@property (nonatomic, assign, readonly) NSInteger datacenterID;
@property (nonatomic, strong, readonly) NSDate *epochDate; // Custom epoch date

+ (instancetype)sharedInstance;

- (instancetype)initWithWorkerID:(NSInteger)workerID datacenterID:(NSInteger)datacenterID epochDate:(NSDate *)epochDate;

- (instancetype)init;

- (NSString *)generateId;

@end
