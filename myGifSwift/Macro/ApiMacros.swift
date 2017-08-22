//
//  ApiMacros.swift
//  SwiftCodeFragments
//
//  Created by zhangmingwei on 2017/2/3.
//  Copyright © 2017年 SpeedX. All rights reserved.
//

import Foundation

// -- swift 的api以 kS开头

// 域名
let kSDomain                 =   ".niaoyutong.com"
// 请求的根url
let kSBase_url               =   "http://api.niaoyutong.com:1241/?/"
//let kSBase_url_v2            =   "https://nytp.herokuapp.com"         // 测试环境 v2.0
let kSBase_url_v2            =   "http://api.niaoyutong.com:1241/v2/planner" // 正式环境 v2.0


// 请求的key（暂时需要）
let kSRequest_key            =   "b13defd332c76c3abf2895f7796e2a45"


// 业务逻辑的具体API：
/// 获取首页达人列表
let kSApi_get_translators_list  =    "account/api/get_translators_list/"
/// 登录
let kSApi_login                 =    "/account/api/login/"
/// 微信登录
let kSApi_wechat_login          =    "account/api/get_wx_login_status/"
/// 注销
let kSApi_logout                =    "account/api/logout/"
/// 上传 - 上次登录的时间
let kSApi_update_last_time      =    "account/api/update_user_last_time/"
/// -------------------webView BEGIN-----------------------------
/// 商家推荐的类型
let kSApi_webView_partner_type  =    "partner/api/get_partner_types/"
/// 商家列表 - 中文的
let kSApi_webView_list_zh       =    "http://www.niaoyutong.com/static/partners.html?language=zh&type=%d"
/// 商家列表 - 英文的
let kSApi_webView_list_en       =    "http://www.niaoyutong.com/static/partners.html?language=en&type=%d"
/// -------------------webView END-----------------------------
/// 筛选的标签列表
let kSApi_filter_list           =    "account/api/get_all_lable_language/"
//let kSApi_filter_list           =    "account/api/get_hot_lable_language/"
/// 更新用户信息
let kSApi_update_user_info      =    "/account/api/update_user_info/"
/// 获取用户信息
let kSApi_get_user_info         =    "account/api/get_user_info/"
/// 获取验证码
let kSApi_get_code              =    "account/api/get_sms_verify_code/"
/// 找回密码
let kSApi_find_pwd              =    "/account/api/find_password/"
/// 注册
let kSApi_register              =    "/account/api/register/"
/// 微信注册
let kSApi_wx_register           =    "account/api/wx_register/"
/// 达人详情
let kSApi_master_info           =    "account/api/get_translator_info/"
/// 普通用户和达人相互切换的接口
let kSApi_change_status         =    "account/api/certification_status/"
/// ----------------------- 环信聊天相关 BEGIN ----------------------
/// 聊天获取达人状态
let kSApi_master_status         =    "huanxinorder/api/get_translator_work_status/"

/// ----------------------- 环信聊天相关 END ----------------------
/// 资金管理
let kSApi_money_manager         =    "account/api/money_manage/"
/// 优惠码充值
let kSApi_coupon_charge         =    "account/api/add_coupon_money_time/"
/// 支付宝或者微信充值的方法
let kSApi_money_charge          =    "account/api/add_user_money/"
/// 提现
let kSApi_money_withDraw        =    "account/api/withdraw_user_money/"
/// 获取用户可提现的金额和账号 - 防止上个页面传入的不对  --- 没有账号的话就提示绑定
let kSApi_get_user_withDraw     =    "account/api/get_user_withdraw_cash_account/"
/// 资金明细
let kSApi_money_detail          =    "account/api/get_user_account_info_by_page/"
/// 提现账号绑定
let kSApi_save_withdraw_account =    "account/api/save_user_withdraw_cash_account/"
/// 热门问题的列表
let kSApi_hot_question_list     =    "question/api/get_hot_question_list/"
/// 获取问答详情的接口
let kSApi_get_question_detail   =    "question/api/user_get_question_answer_info/"
/// 支付某个问题
let kSApi_pay_question_detail   =    "order/api/pay_question_answer/"
/// 支付订单
let kSApi_add_order_answer      =    "order/api/add_order_answer_pay_question/"
/// 点赞
let kSApi_click_zan             =    "question/api/focus_question/"
/// 申请成为达人的请求
let kSApi_apply_to_master       =    "/account/api/apply_certification/"
/// 修改达人资料
let kSApi_save_master_info      =    "account/api/save_translator_info/"
/// 提问前获取key的请求
let kSApi_question_get_key      =    "question/api/get_create_attach_accees_key/"
/// 提问的支付请求
let kSApi_question_pay          =    "order/api/question_pay/"
/// 上传问题图片的请求
let kSApi_question_attach_upload  =    "question/api/attach_upload/"
/// 上传问题的总请求
let kSApi_publish_question       =    "question/api/publish_question/"
/// 达人版本的问答列表
let kSApi_master_question_list   =    "question/api/get_user_recipient_question_list/"
/// 达人回答问题
let kSApi_master_save_answer     =    "question/api/save_answer_info/"
/// 我的问答列表 - 用户已经购买的问答列表
let kSApi_get_user_has_buy_question  =    "question/api/get_user_has_buy_question_list/"
/// 服务评价
let kSApi_service_evalution       =    "huanxinorder/api/comment/"

/// 获取自己的行程列表
let kSApi_me_itineraries            =   "me/itineraries"
//let kSApi_me_itineraries            =   "itineraries" // 获取所有的行程列表

/// 添加一个行程
let kSApi_itinerary                 =   "itinerary"
/// 添加一个日程到行程的最后
let kSApi_add_one_schedule          =   "itineraries/%@/schedule"
/// 获取行程详情/更新一个行程/删除一个行程
let kSApi_itineraries_itineraryID   =   "itineraries"
/// 更新一个行程
let kSApi_itineraries_update_id     =   "itineraries/%@"
/// 更新某一个日程：更新是put
let kSApi_put_one_schedule       =   "itineraries/%@/schedules/%@"
/// 获取城市列表
let kSApi_get_cities                =   "cities"
/// 获取地点的详情：景点、餐厅、购物等详情
let kSApi_place_detail              =   "places"
/// 获取景点附近的餐厅或者购物
let KSApi_place_nearby              =   "places/%@/nearbys"
/// 获取城市附近的地点列表
let kSApi_city_place_list           =   "cities/%@/places"
/// 删除一个行程
let kSApi_delete_trip               =   "itineraries/%@"



