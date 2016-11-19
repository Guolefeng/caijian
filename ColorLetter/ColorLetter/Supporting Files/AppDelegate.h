//
//  AppDelegate.h
//  ColorLetter
//
//  Created by dllo on 16/10/19.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapView.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    BMKMapManager * _mapManager;
}

@property (strong, nonatomic) UIWindow *window;

@end

