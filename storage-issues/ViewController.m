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
NSString *textFile = @"flutter-tests/file.txt";
NSString *imageFile = @"flutter-tests/image.jpg";

- (FIRStorageReference *)createStorageRef:(NSString *)fileName {
  FIRStorage *storage = [FIRStorage storage];
  FIRStorageReference *storageRef = [storage reference];
  FIRStorageReference *reference = [storageRef child:fileName];

  return reference;
}

- (IBAction)addimage:(id)sender {
  NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://picsum.photos/200"]];

  FIRStorageReference *reference = [self createStorageRef:imageFile];
  [reference putData:data
            metadata:nil
          completion:^(FIRStorageMetadata *metadata, NSError *error) {
            if (error != nil) {
              NSLog(@"ERROR: %@", error);
            } else {
              NSLog(@"SUCCESS");
            }
          }];
}

- (IBAction)downloadurl:(id)sender {
  FIRStorageReference *reference = [self createStorageRef:imageFile];
  // This will fail using the Storage emulator
  [reference downloadURLWithCompletion:^(NSURL *URL, NSError *error) {
    if (error != nil) {
      NSLog(@"ERROR: %@", error);
    } else {
      NSLog(@"SUCCESS: %@", URL);
    }
  }];
}

- (IBAction)createfile:(id)sender {
  NSString *content = @"Put this in a file please.";
  NSData *fileContents = [content dataUsingEncoding:NSUTF8StringEncoding];
  [[NSFileManager defaultManager] createFileAtPath:textFile contents:fileContents attributes:nil];
}

- (IBAction)putfile:(id)sender {
  // Remember to create file first
  FIRStorageReference *reference = [self createStorageRef:textFile];
  // This will fail because "path" is expected on metadata
  // which is read-only. We worked around this by using
  //  initWithDictionary that adds "path" to metadata by using "name" property
  FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];

  NSURL *fileUrl = [NSURL fileURLWithPath:textFile];
  [reference putFile:fileUrl
            metadata:metadata
          completion:^(FIRStorageMetadata *meta, NSError *error) {
            if (error != nil) {
              NSLog(@"ERROR: %@", error);
            } else {
              NSLog(@"SUCCESS");
            }
          }];
}

- (IBAction)updatemetadata:(id)sender {
  NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
  // This custom metadata will be removed when using
  // initWithDictionary
  dictionary[@"metadata"] = @{@"some" : @"metadata"};
  FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] initWithDictionary:dictionary];
  FIRStorageReference *reference = [self createStorageRef:textFile];
  [reference updateMetadata:metadata
                 completion:^(FIRStorageMetadata *updatedMetadata, NSError *error) {
                   if (error != nil) {
                     NSLog(@"ERROR: %@", error);
                   } else {
                     NSLog(@"SUCCESS");
                   }
                 }];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

@end
