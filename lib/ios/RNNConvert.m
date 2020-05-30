#import "RNNConvert.h"

@implementation RNNConvert

+ (UIModalPresentationStyle)defaultModalPresentationStyle {
    if (@available(iOS 13.0, tvOS 13.0, *)) {
        return UIModalPresentationAutomatic;
    } else {
        return UIModalPresentationOverFullScreen;
    }
}

RCT_ENUM_CONVERTER(UIModalTransitionStyle,
                   (@{@"coverVertical": @(UIModalTransitionStyleCoverVertical),
#if !TARGET_OS_TV
                      @"flipHorizontal": @(UIModalTransitionStyleFlipHorizontal),
                      @"partialCurl": @(UIModalTransitionStylePartialCurl),
#endif
                      @"crossDissolve": @(UIModalTransitionStyleCrossDissolve)
                   }), UIModalTransitionStyleCoverVertical, integerValue)

RCT_ENUM_CONVERTER(UIModalPresentationStyle,
                   (@{@"fullScreen": @(UIModalPresentationFullScreen),
#if !TARGET_OS_TV
                      @"pageSheet": @(UIModalPresentationPageSheet),
                      @"formSheet": @(UIModalPresentationFormSheet),
                      @"popover": @(UIModalPresentationPopover),
#endif
                      @"currentContext": @(UIModalPresentationCurrentContext),
                      @"custom": @(UIModalPresentationCustom),
                      @"overFullScreen": @(UIModalPresentationOverFullScreen),
                      @"overCurrentContext": @(UIModalPresentationOverCurrentContext),
                      @"none": @(UIModalPresentationNone),
                      @"default": @([RNNConvert defaultModalPresentationStyle])
                   }), UIModalPresentationFullScreen, integerValue)

@end
