//
//  Asset.h
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol ELCAssetDelegate;

@interface ELCAsset : UIView {
	ALAsset *asset;
	UIImageView *overlayView;
	BOOL selected;
	id<ELCAssetDelegate> parent;
}

@property (nonatomic, retain) ALAsset *asset;
@property (nonatomic, assign) id<ELCAssetDelegate> parent;

-(id)initWithAsset:(ALAsset*)_asset;
-(BOOL)selected;

@end

@protocol ELCAssetDelegate <NSObject>

@optional
- (void)elcAsset:(ELCAsset *)anElcAsset wasSelected:(BOOL)selected;

@end