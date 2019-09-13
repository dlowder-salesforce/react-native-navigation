#import "UIViewController+RNNOptions.h"
#import <React/RCTRootView.h>
#import "UIImage+tint.h"
#import "RNNBottomTabOptions.h"
#import "RNNNavigationOptions.h"
#import "RNNBackButtonOptions.h"

#define kStatusBarAnimationDuration 0.35
const NSInteger BLUR_STATUS_TAG = 78264801;

@implementation UIViewController (RNNOptions)

- (void)setBackgroundImage:(UIImage *)backgroundImage {
	if (backgroundImage) {
		UIImageView* backgroundImageView = (self.view.subviews.count > 0) ? self.view.subviews[0] : nil;
		if (![backgroundImageView isKindOfClass:[UIImageView class]]) {
			backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
			[self.view insertSubview:backgroundImageView atIndex:0];
		}

		backgroundImageView.layer.masksToBounds = YES;
		backgroundImageView.image = backgroundImage;
		[backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	}
}

- (void)setSearchBarWithPlaceholder:(NSString *)placeholder
		 hideNavBarOnFocusSearchBar:(BOOL)hideNavBarOnFocusSearchBar {
#if !TARGET_OS_TV
	if (@available(iOS 11.0, *)) {
		if (!self.navigationItem.searchController) {
			UISearchController *search = [[UISearchController alloc]initWithSearchResultsController:nil];
			search.dimsBackgroundDuringPresentation = NO;
			if ([self conformsToProtocol:@protocol(UISearchResultsUpdating)]) {
				[search setSearchResultsUpdater:((UIViewController <UISearchResultsUpdating> *) self)];
			}
			search.searchBar.delegate = (id<UISearchBarDelegate>)self;
			if (placeholder) {
				search.searchBar.placeholder = placeholder;
			}
			search.hidesNavigationBarDuringPresentation = hideNavBarOnFocusSearchBar;
			self.navigationItem.searchController = search;
			[self.navigationItem setHidesSearchBarWhenScrolling:NO];

			// Fixes #3450, otherwise, UIKit will infer the presentation context to be the root most view controller
			self.definesPresentationContext = YES;
		}
	}
#endif
}

- (void)setSearchBarHiddenWhenScrolling:(BOOL)searchBarHidden {
#if !TARGET_OS_TV
	if (@available(iOS 11.0, *)) {
		self.navigationItem.hidesSearchBarWhenScrolling = searchBarHidden;
	}
#endif
}

- (void)setNavigationItemTitle:(NSString *)title {
	self.navigationItem.title = title;
}

- (void)setDrawBehindTopBar:(BOOL)drawBehind {
	if (drawBehind) {
		[self setExtendedLayoutIncludesOpaqueBars:YES];
		self.edgesForExtendedLayout |= UIRectEdgeTop;
	} else {
		self.edgesForExtendedLayout &= ~UIRectEdgeTop;
	}
}

- (void)setDrawBehindTabBar:(BOOL)drawBehindTabBar {
	if (drawBehindTabBar) {
		[self setExtendedLayoutIncludesOpaqueBars:YES];
		self.edgesForExtendedLayout |= UIRectEdgeBottom;
	} else {
		self.edgesForExtendedLayout &= ~UIRectEdgeBottom;
	}
}

- (void)setTabBarItemBadge:(NSString *)badge {
    UITabBarItem *tabBarItem = self.tabBarItem;

    if ([badge isKindOfClass:[NSNull class]] || [badge isEqualToString:@""]) {
        tabBarItem.badgeValue = nil;
    } else {
        tabBarItem.badgeValue = badge;
        [[self.tabBarController.tabBar viewWithTag:tabBarItem.tag] removeFromSuperview];
        tabBarItem.tag = -1;
    }
}

- (void)setTabBarItemBadgeColor:(UIColor *)badgeColor {
	if (@available(iOS 10.0, *)) {
		self.tabBarItem.badgeColor = badgeColor;
	}
}

- (void)setStatusBarStyle:(NSString *)style animated:(BOOL)animated {
#if !TARGET_OS_TV
	if (animated) {
		[UIView animateWithDuration:[self statusBarAnimationDuration:animated] animations:^{
			[self setNeedsStatusBarAppearanceUpdate];
		}];
	} else {
		[self setNeedsStatusBarAppearanceUpdate];
	}
#endif
}

- (void)setTopBarPrefersLargeTitle:(BOOL)prefersLargeTitle {
#if !TARGET_OS_TV
	if (@available(iOS 11.0, *)) {
		if (prefersLargeTitle) {
			self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
		} else {
			self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
		}
	}
#endif
}


- (void)setStatusBarBlur:(BOOL)blur {
#if !TARGET_OS_TV
	UIView* curBlurView = [self.view viewWithTag:BLUR_STATUS_TAG];
	if (blur) {
		if (!curBlurView) {
			UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
			blur.frame = [[UIApplication sharedApplication] statusBarFrame];
			blur.tag = BLUR_STATUS_TAG;
			[self.view insertSubview:blur atIndex:0];
		}
	} else {
		if (curBlurView) {
			[curBlurView removeFromSuperview];
		}
	}
#endif
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
	self.view.backgroundColor = backgroundColor;
}

- (void)setBackButtonVisible:(BOOL)visible {
#if !TARGET_OS_TV
	self.navigationItem.hidesBackButton = !visible;
#endif
}

- (CGFloat)statusBarAnimationDuration:(BOOL)animated {
	return animated ? kStatusBarAnimationDuration : CGFLOAT_MIN;
}

- (BOOL)isModal {
	if([self presentingViewController])
		return YES;
	if([[[self navigationController] presentingViewController] presentedViewController] == [self navigationController])
		return YES;
	if([[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
		return YES;

	return NO;
}

- (void)setInterceptTouchOutside:(BOOL)interceptTouchOutside {
	if ([self.view isKindOfClass:[RCTRootView class]]) {
		RCTRootView* rootView = (RCTRootView*)self.view;
		rootView.passThroughTouches = !interceptTouchOutside;
	}
}

- (void)setBackButtonIcon:(UIImage *)icon withColor:(UIColor *)color title:(NSString *)title {
	UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
	if (icon) {
		backItem.image = color
		? [[icon withTintColor:color] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
		: icon;
		
#if !TARGET_OS_TV
		[self.navigationController.navigationBar setBackIndicatorImage:[UIImage new]];
		[self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage new]];
#endif
    }
	
	UIViewController *lastViewControllerInStack = self.navigationController.viewControllers.count > 1 ? [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] : self.navigationController.topViewController;
	
	backItem.title = title ? title : lastViewControllerInStack.navigationItem.title;
	backItem.tintColor = color;
	
#if !TARGET_OS_TV
	lastViewControllerInStack.navigationItem.backBarButtonItem = backItem;
#endif
}

- (void)applyBackButton:(RNNBackButtonOptions *)backButton {
	UIBarButtonItem *backItem = [UIBarButtonItem new];
	if (backButton.icon.hasValue) {
		UIColor *color = [backButton.color getWithDefaultValue:nil];
		backItem.image = color ?
				[[backButton.icon.get withTintColor:color] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] :
				backButton.icon.get;
#if !TARGET_OS_TV
		[self.navigationController.navigationBar setBackIndicatorImage:[UIImage new]];
        [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage new]];
#endif
    }

	if ([backButton.showTitle getWithDefaultValue:YES]) backItem.title = [backButton.title getWithDefaultValue:nil];
	if (backButton.color.hasValue) backItem.tintColor = [backButton.color get];
#if !TARGET_OS_TV
	self.navigationItem.backBarButtonItem = backItem;
#endif
}

@end
