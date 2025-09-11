<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
#import "IdGenerator.h"

@interface IdGenerator ()

@property (nonatomic, assign) long long lastTimestamp;

@property (nonatomic, assign) NSInteger sequence;

@property (nonatomic, strong) NSRecursiveLock* lock;

@end

@implementation IdGenerator

static const int kTimestampBits = 41;
static const int kDatacenterIDBits = 5;
static const int kWorkerIDBits = 5;
static const int kSequenceBits = 12;

static const int kDatacenterIDShift = kSequenceBits + kWorkerIDBits;
static const int kWorkerIDShift = kSequenceBits;
static const long long kTimestampLeftShift = kSequenceBits + kWorkerIDBits + kDatacenterIDBits;
static const long long kSequenceMask = -1LL ^ (-1LL << kSequenceBits); // Mask for sequence number

+ (instancetype)sharedInstance {
  static IdGenerator* sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSInteger defaultWorkerID = 0;
    NSInteger defaultDatacenterID = 0;
    NSDate *defaultEpochDate = [NSDate dateWithTimeIntervalSince1970:1577836800]; // January 1, 2020

    sharedInstance = [[self alloc] initWithWorkerID:defaultWorkerID
                                       datacenterID:defaultDatacenterID
                                          epochDate:defaultEpochDate];
  });
  return sharedInstance;
}

- (instancetype)initWithWorkerID:(NSInteger)workerID datacenterID:(NSInteger)datacenterID epochDate:(NSDate *)epochDate {
  self = [super init];
  if (self) {
    if (workerID < 0 || workerID > ((1 << kWorkerIDBits) - 1)) {
      NSLog(@"Error: Worker ID must be between 0 and %d", ((1 << kWorkerIDBits) - 1));
      return nil;
    }
    if (datacenterID < 0 || datacenterID > ((1 << kDatacenterIDBits) - 1)) {
      NSLog(@"Error: Datacenter ID must be between 0 and %d", ((1 << kDatacenterIDBits) - 1));
      return nil;
    }
    if (!epochDate) {
      NSLog(@"Error: Epoch date cannot be nil.");
      return nil;
    }
    _workerID = workerID;
    _datacenterID = datacenterID;
    _epochDate = epochDate;
    _lastTimestamp = -1LL; 
    _sequence = 0;
    _lock = [[NSRecursiveLock alloc] init]; 
  }
  return self;
}

- (instancetype)init {
  return nil; 
}


- (NSString*)generateId {
  long long timestampMillis = [self timestampMilliseconds];
  [_lock lock];

  if (timestampMillis < _lastTimestamp) {
    // Clock moved backwards! This is a serious issue in distributed systems.
    [_lock unlock]; // Release lock
    NSLog(@"Error: Clock is moving backwards. Rejecting request until clock catches up.");
    return nil; // Or handle this more robustly in a real system
  }

  if (_lastTimestamp == timestampMillis) {
    _sequence = (_sequence + 1) & kSequenceMask; // Increment sequence, wrap around if needed
    if (_sequence == 0) {
      // Sequence overflowed for this millisecond, wait for next millisecond
      timestampMillis = [self tilNextMillis:_lastTimestamp];
    }
  } else {
    _sequence = 0; // Reset sequence for new millisecond
  }

  _lastTimestamp = timestampMillis;

  long long snowflakeID = ((timestampMillis - [self epochMilliseconds]) << kTimestampLeftShift) |
                          (_datacenterID << kDatacenterIDShift) |
                          (_workerID << kWorkerIDShift) |
                          _sequence;

  [_lock unlock];
  return [NSString stringWithFormat:@"%lld", snowflakeID];
}

#pragma mark - Helper Methods

- (long long)timestampMilliseconds {
  return (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
}

- (long long)epochMilliseconds {
  return (long long)([self.epochDate timeIntervalSince1970] * 1000.0);
}

- (long long)tilNextMillis:(long long)lastTimestamp {
  long long timestamp = [self timestampMilliseconds];
  while (timestamp <= lastTimestamp) {
    timestamp = [self timestampMilliseconds];
  }
  return timestamp;
}

@end