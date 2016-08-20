//
//  Constants.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 05.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import Foundation
import UIKit

let kColorPrimary = UIColor(hue:0.12, saturation:0.79, brightness:0.98, alpha:1)
let kColorDark = UIColor(hue:0.1, saturation:0.8, brightness:0.96, alpha:1)
let kColorAccent = UIColor(hue:0.72, saturation:0.57, brightness:0.77, alpha:1)
let kColorWhite = UIColor.whiteColor()
let kColorBlack = UIColor.blackColor()
let kColorGreen = UIColor(hue:0.35, saturation:0.51, brightness:0.73, alpha:1)
let kColorRed = UIColor(hue:0.02, saturation:0.72, brightness:0.93, alpha:1)
let kColorInactive = UIColor(hue:0, saturation:0, brightness:0.68, alpha:1)
let kColorGreenClear = UIColor(hue:0.35, saturation:0.51, brightness:0.73, alpha:0.9)
let kColorBackground = UIColor(hue:0, saturation:0, brightness:1.00, alpha:0.9)

struct FeedItemType{
    static let TASK_DONE = "#FeedItemTypeTaskDone"
    static let TASK_UNDONE = "#FeedItemTypeTaskUndone"
    static let TASK_LIKE = "#FeedItemTypeTaskLike"
    static let TASK_DISLIKE = "#FeedItemTypeTaskDislike"
    static let HOME_CONNECT = "#FeedItemTypeHomeConnect"
    static let HOME_CREATE = "#FeedItemTypeHomeCreate"
    static let HOME_DISCONNECT = "#FeedItemTypeHomeDisconnect"
    static let TYPE_ADD = "#FeedItemTypeTaskTypeAdd"
    static let TYPE_DELETE = "#FeedItemTypeTaskTypeDelete"
    static let TYPE_EDIT = "#FeedItemTypeTaskTypeEdit"
}

let kBannerAd = "ca-app-pub-9486440383744688/1285160247"
let kFullScreenAd = "ca-app-pub-9486440383744688/8808427049"

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}