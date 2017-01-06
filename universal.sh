FRAMEWORK=XeeSDK
BUILD=build
FRAMEWORK_PATH=$FRAMEWORK.framework
rm -Rf $BUILD
rm $FRAMEWORK_PATH.tar.gz
xcodebuild archive -project $FRAMEWORK.xcodeproj -scheme $FRAMEWORK -sdk iphoneos SYMROOT=$BUILD
xcodebuild build -project $FRAMEWORK.xcodeproj -target $FRAMEWORK -sdk iphonesimulator SYMROOT=$BUILD
cp -RL $BUILD/Release-iphoneos $BUILD/Release-universal
lipo -create $BUILD/Release-iphoneos/$FRAMEWORK_PATH/$FRAMEWORK $BUILD/Release-iphonesimulator/$FRAMEWORK_PATH/$FRAMEWORK -output $BUILD/Release-universal/$FRAMEWORK_PATH/$FRAMEWORK
cp -R $BUILD/Release-universal/XeeSDKResources.bundle $BUILD/Release-universal/$FRAMEWORK_PATH
tar -czv -C $BUILD/Release-universal -f $FRAMEWORK.framework.tar.gz $FRAMEWORK_PATH
rm -rf $BUILD
