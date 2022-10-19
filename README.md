# ios-sdk-10-issues

1. Clone repo and pod install. Open xcworkspace in Xcode.
2. Run Storage emulator and allow all read/write operations in Storage rules.
3. Run the app.
4. Press the "downloadUrl emulator failure" button to see the error produced. The response includes a metadata object not stringified which I think is the problem.
Comment out the [emulator initialization](https://github.com/invertase/ios-sdk-10-issues/blob/main/storage-issues/AppDelegate.m#L23) and run app again to see a successful response. It does not contain a 
metadata object.
5. Press the "putFile failure" button to see this error: "Fatal error: Internal error enqueueing a Storage task". It's because path does not exist on
metadata which is a read only property. It can be worked around using [intializeWithDictionary](https://github.com/firebase/firebase-ios-sdk/blob/master/FirebaseStorage/Sources/StorageMetadata.swift#L156) and adding "name" property as it puts "name" on "path" property [here](https://github.com/firebase/firebase-ios-sdk/blob/master/FirebaseStorage/Sources/StorageMetadata.swift#L174)
6. Press the "updateMetadata failure" button to see response does not include updated custom metadata (i.e. "foo":"bar" in example). If you comment out
the way FIRStorageMetadata is initialised [here](https://github.com/invertase/ios-sdk-10-issues/blob/main/storage-issues/ViewController.m#L98-L99) and 
uncomment [here](https://github.com/invertase/ios-sdk-10-issues/blob/main/storage-issues/ViewController.m#L102-L103), you will see custom metadata in response.
