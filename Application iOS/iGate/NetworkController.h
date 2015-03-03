#import <Foundation/Foundation.h>


// Block typedefs
@class NetworkController;
typedef void (^ConnectionBlock)(NetworkController*);
typedef void (^MessageBlock)(NetworkController*,NSString*);


@interface NetworkController : NSObject<NSStreamDelegate> {
  // Connection info
  NSString* host;
  int port;
  
  // Input
  NSInputStream* inputStream;
  NSMutableData* inputBuffer;
  BOOL isInputStreamOpen;
  
  // Output
  NSOutputStream* outputStream;
  NSMutableData* outputBuffer;
  BOOL isOutputStreamOpen;
  
  // Event handlers
  MessageBlock messageReceivedBlock;
  ConnectionBlock connectionOpenedBlock;
  ConnectionBlock connectionFailedBlock;
  ConnectionBlock connectionClosedBlock;
}

// Singleton instance
+ (NetworkController*)sharedInstance;

// Methods
- (void)connect;
- (BOOL)isConnected;
- (void)disconnect;
- (void)updateIP;
- (void)sendMessage:(NSString*)message;

// Properties
@property (copy) MessageBlock messageReceivedBlock;
@property (copy) ConnectionBlock connectionOpenedBlock;
@property (copy) ConnectionBlock connectionFailedBlock;
@property (copy) ConnectionBlock connectionClosedBlock;

@end
