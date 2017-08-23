//
//  AppDelegate.swift
//  myGifSwift
//
//  Created by zhangmingwei on 2017/8/22.
//  Copyright © 2017年 niaoyutong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Bmob设置
        Bmob.register(withAppKey: kBmobApplicationID)
        
        window = UIWindow(frame:UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        // 控制器名字数组
        let  controllerArray = ["HomeVC","FavoriteVC","LocalVC","MeVC"]
        // 标题数组
        let  titleArray = ["首页","收藏","本地","我的"]
        // icon 未选中的数组
        let  imageArray = ["tab_0","tab_1","tab_2","tab_3"]
        // icon 选中的数组
        let  selImageArray = ["tab_0_sel","tab_1_sel","tab_2_sel","tab_3_sel"]
        // tabbar高度最小值49.0, 传nil或<49.0均按49.0处理
        let height = CGFloat(49)
        // tabBarController
        let tabBarController = XHTabBar(controllerArray:controllerArray,titleArray: titleArray,imageArray: imageArray,selImageArray: selImageArray,height:height)
        
        window?.rootViewController = tabBarController
        
        // 设置数字角标(可选)
        // tabBarController.showBadgeMark(badge: 100, index: 1)
        // 设置小红点(可选)
        // tabBarController.showPointMarkIndex(index: 2)
        // 不显示小红点/数字角标(可选)
        //tabBarController.hideMarkIndex(3)
        // 手动切换tabBarController 显示到指定控制器(可选)
        //tabBarController.showControllerIndex(3)
        
        window?.makeKeyAndVisible()
        
        //        GDPerformanceMonitor.sharedInstance.startMonitoring()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


/*
 添加数据：
 //往GameScore表添加一条playerName为小明，分数为78的数据
 BmobObject *gameScore = [BmobObject objectWithClassName:@"GameScore"];
 [gameScore setObject:@"小明" forKey:@"playerName"];
 [gameScore setObject:@78 forKey:@"score"];
 [gameScore setObject:[NSNumber numberWithBool:YES] forKey:@"cheatMode"];
 [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
 //进行操作
 }];
 
 获取数据：
 //查找GameScore表
 BmobQuery   *bquery = [BmobQuery queryWithClassName:@"GameScore"];
 //查找GameScore表里面id为0c6db13c的数据
 [bquery getObjectInBackgroundWithId:@"0c6db13c" block:^(BmobObject *object,NSError *error){
 if (error){
 //进行错误处理
 }else{
 //表里有id为0c6db13c的数据
 if (object) {
 //得到playerName和cheatMode
 NSString *playerName = [object objectForKey:@"playerName"];
 BOOL cheatMode = [[object objectForKey:@"cheatMode"] boolValue];
 NSLog(@"%@----%i",playerName,cheatMode);
 }
 }
 }];
 修改：//查找GameScore表
 BmobQuery   *bquery = [BmobQuery queryWithClassName:@"GameScore"];
 //查找GameScore表里面id为0c6db13c的数据
 [bquery getObjectInBackgroundWithId:@"0c6db13c" block:^(BmobObject *object,NSError *error){
 //没有返回错误
 if (!error) {
 //对象存在
 if (object) {
 BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
 //设置cheatMode为YES
 [obj1 setObject:[NSNumber numberWithBool:YES] forKey:@"cheatMode"];
 //异步更新数据
 [obj1 updateInBackground];
 }
 }else{
 //进行错误处理
 }
 }];
 删除：
 BmobQuery *bquery = [BmobQuery queryWithClassName:@"GameScore"];
 [bquery getObjectInBackgroundWithId:@"0c6db13c" block:^(BmobObject *object, NSError *error){
 if (error) {
 //进行错误处理
 }
 else{
 if (object) {
 //异步删除object
 [object deleteInBackground];
 }
 }
 }];
 */
