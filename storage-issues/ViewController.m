//
//  ViewController.m
//  storage-issues
//
//  Created by Russell Wheatley on 18/10/2022.
//

#import "ViewController.h"
@import FirebaseStorage;

@interface ViewController ()

@end

@implementation ViewController
NSString *textFile = @"file.txt";
NSString *downloadUrlFile = @"flutter-tests/downloadUrl.txt";

- (FIRStorageReference *)createStorageRef:(NSString *)fileName {
  FIRStorage *storage = [FIRStorage storage];
  FIRStorageReference *storageRef = [storage reference];
  FIRStorageReference *reference = [storageRef child:fileName];

  return reference;
}

- (IBAction)downloadurl:(id)sender {
  NSString *content = @"Put this in a file please.";
  NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];

  FIRStorageReference *reference = [self createStorageRef:downloadUrlFile];
  [reference putData:data
            metadata:nil
          completion:^(FIRStorageMetadata *metadata, NSError *error) {
            if (error != nil) {
              NSLog(@"ERROR putData: %@", error);
            } else {
              NSLog(@"SUCCESSFULLY putData");
              
              FIRStorageReference *reference = [self createStorageRef:downloadUrlFile];
              // This will fail using the Storage emulator. To see it work, do not use the emulator
              [reference downloadURLWithCompletion:^(NSURL *URL, NSError *error) {
                if (error != nil) {
                  // See metadata property is not a String in the console and I think that is why it fails
                  NSLog(@"ERROR: %@", error);
                } else {
                  NSLog(@"SUCCESS: %@", URL);
                }
              }];
            }
          }];
}


- (IBAction)putfile:(id)sender {
  // Write file
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory , textFile];
  // if file does not exist, create it.
  if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
      NSString *helloStr = @"hello world";
      NSError *error;
      [helloStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if(error) {
      NSLog(@"Error writing file: %@", error);
      return;
    }
  }

  
  FIRStorageReference *reference = [self createStorageRef:[NSString stringWithFormat:@"%@/%@", @"flutter-tests", textFile]];
  
  // This will fail because "path" is expected on metadata
  // which is read-only. We worked around this by using
  // initWithDictionary method that adds "path" to metadata by using "name" property under the hood.
  // but it should be possible with: [[FIRStorageMetadata alloc] init];
  FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
  
  NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
  [reference putFile:fileUrl
            metadata:metadata
          completion:^(FIRStorageMetadata *meta, NSError *error) {
            if (error != nil) {
              // Should see "Fatal error: Internal error enqueueing a Storage task"
              NSLog(@"ERROR: %@", error);
            } else {
              NSLog(@"SUCCESS");
            }
          }];
}

- (IBAction)updatemetadata:(id)sender {
  NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
  // This custom metadata will be removed when using
  // initWithDictionary method
  dictionary[@"metadata"] = @{@"foo" : @"bar"};
  FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] initWithDictionary:dictionary];
  
  // PLEASE UNCOMMENT THIS AND COMMENT OUT THE TWO ABOVE LINES TO SEE METADATA CORRECTLY UPDATED
  //  FIRStorageMetadata *metadata =[[FIRStorageMetadata alloc] init];
  //  metadata.customMetadata = @{@"foo" : @"bar"};
  
  FIRStorageReference *reference = [self createStorageRef:downloadUrlFile];
  [reference updateMetadata:metadata
                 completion:^(FIRStorageMetadata *updatedMetadata, NSError *error) {
                   if (error != nil) {
                     NSLog(@"ERROR: %@", error);
                   } else {
                     NSLog(@"SUCCESS: %@", updatedMetadata);
                   }
                 }];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

@end
