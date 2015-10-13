//
//  NetInterface.h
//  LYShopping
//
//  Created by qianfeng on 15/9/23.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#ifndef LYShopping_NetInterface_h
#define LYShopping_NetInterface_h

//首页
#define kHomeUrl @"http://zpi.zhen.com/zpapi/homePage/getOPFAppFirstPage.json"
//无广告详情
#define kHomeDetail @"http://m.zhenpin.com/index.php?c=APP_special&a=special_info"
//广告栏无广告详情
#define kADDetail @"http://m.zhenpin.com/index.php?c=APP_promotion&a=promotion_info"

//搜索
#define kSearch @"http://zpi.zhen.com/zpapi/products/getHotSearchWordsList.json?num=15"

//秒杀
#define kSecondKill @"http://zpi.zhen.com/zpapi/quick/product/productList.json"
//秒杀详情
#define kKillDetail @"http://m.zhenpin.com/?c=APP_quick&a=index"


//分类
#define kCategory @"http://zpi.zhen.com/zpapi/categoryPage/findCategoryChildren.json"
//参数 categoryid=%@&v=2.0

//品牌  热门品牌
#define kBrand @"http://zpi.zhen.com/zpapi/brandPage/initPage.json"
//全部品牌
#define kAllBrand @"http://zpi.zhen.com/zpapi/brandPage/goodsBrandByName.json"
//参数  charactergroup=A%2CB%2CC%2CD%2CE%2CF%2CG%2CH%2CI%2CJ%2CK%2CL%2CM%2CN%2CO%2CP%2CQ%2CR%2CS%2CT%2CU%2CV%2CW%2CX%2CY%2CZ&v=2.0

//品牌详情   参数中的brandid 为品牌中的
#define kDetailCate @"http://zpi.zhen.com/zpapi/products/productSearchForSift.json"
// 人气  pagenumber=1&pagesize=10&noStock=1&brandid=%@&v=2.0
// 最新  pagenumber=1&pagesize=10&noStock=1&brandid=%@&v=2.0order=4
// 价格  上升 pagenumber=1&pagesize=10&noStock=1&brandid=%@&v=2.0order=3
// 价格  下降 pagenumber=1&pagesize=10&noStock=1&brandid=%@&v=2.0order=2

//详情
#define kCategoryDetail1 @"http://zpi.zhen.com/zpapi/products/ProductBaseInfo.json"
#define kCategoryDetail2 @"http://zpi.zhen.com/zpapi/products/getProductSizeTable.json?productid=%@"

#define kCategoryDetail3 @"http://zpi.zhen.com/zpapi/products/getRoundProductByBrand.json"


//登录：
#define kLogin @"http://zpi.zhen.com/zpapi/ucmembers/onLogin.json"
//username=18211673158&password=123456&channel=4&isuname=3&v=2.0

//注册
#define kGetValidateCode @"http://zpi.zhen.com/zpapi/ucmembers/getValidateCode.json"

#define kCheckValidateCode @"http://zpi.zhen.com/zpapi/ucmembers/checkValidateCode.json"

#define kExitsMobileNumber @"http://zpi.zhen.com/zpapi/ucmembers/exitsMobileNumber.json"

#define kOnRegister @"http://zpi.zhen.com/zpapi/ucmembers/onRegister.json"

//增加收藏
#define kAddCollect @"http://zpi.zhen.com/zpapi/myzhenpin/addToCollection.json"

//取消收藏
#define kDeleCollect @"http://zpi.zhen.com/zpapi/myzhenpin/delCollectionById.json"

//获取收藏
#define kGetCollect @"http://zpi.zhen.com/zpapi/myzhenpin/getMyCollection.json"

//添加购物袋
#define kAddProduct @"http://zpi.zhen.com/zpapi/cart/addProduct.json"
//memberid=565137&productspcid=%@&quantity=1&v=2.0

//获取购物袋
#define kGetProduct @"http://zpi.zhen.com/zpapi/cart/initPage.json"
//memberid=565137&v=2.0


/*
 注册：
 获取验证码：
 http://zpi.zhen.com/zpapi/ucmembers/getValidateCode.json
 mobile=18211673158&v=2.0
 注册验证：
 http://zpi.zhen.com/zpapi/ucmembers/checkValidateCode.json
 mobile=18211673158&validateCode=172117&v=2.0
 
 http://zpi.zhen.com/zpapi/ucmembers/exitsMobileNumber.json
 mobile=18211673158&v=2.0
 
 设置密码：
 注册
 http://zpi.zhen.com/zpapi/ucmembers/onRegister.json
 mobile=18211673158&password=123456&model=8d0971ac-05c7-346e-ad73-ea0355a97007&channel=4&v=2.0

 */

/*
 首页:    post
 http://zpi.zhen.com/zpapi/homePage/getOPFAppFirstPage.json
 
 
 首页秒杀展示： post
 http://zpi.zhen.com/zpapi/quick/product/productList.json


品牌 post
http://zpi.zhen.com/zpapi/brandPage/initPage.json

购物袋 post
http://zpi.zhen.com/zpapi/cart/initPage.json
 
 //未实现的功能
 
 加入购物车:
 http://zpi.zhen.com/zpapi/cart/addProduct.json
 memberid=565137&productspcid=%@&quantity=1&v=2.0
 
 购物车:
 http://zpi.zhen.com/zpapi/cart/initPage.json
 memberid=565137&v=2.0
 
 
 购买:
 http://zpi.zhen.com/zpapi/orders/initOrder.json
 memberid=565137&access_token=426a52b6-958e-4d6c-831f-f0f274ba39db&productspcid=%@&isThesea=0/1&source=4&v=2.1

*/
#endif
