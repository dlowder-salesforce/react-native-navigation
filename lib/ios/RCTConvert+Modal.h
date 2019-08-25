#import <React/RCTConvert.h>

@interface RCTConvert (Modal)

@end

@implementation RCTConvert (Modal)

RCT_ENUM_CONVERTER(UIModalTransitionStyle,
				   (@{@"coverVertical": @(UIModalTransitionStyleCoverVertical),
                      @"crossDissolve": @(UIModalTransitionStyleCrossDissolve),
#if !TARGET_OS_TV
					  @"flipHorizontal": @(UIModalTransitionStyleFlipHorizontal),
					  @"partialCurl": @(UIModalTransitionStylePartialCurl)
#endif
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
					  @"none": @(UIModalPresentationNone)
					  }), UIModalPresentationFullScreen, integerValue)
@end

