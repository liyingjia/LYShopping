
#ifndef _NetInterface_h
#define _NetInterface_h


//基本路径
#define kBaseUrl @"http://bq.cms.palmtrends.com"

//主界面
#define kMainUrl @"http://bq.cms.palmtrends.com/api_v2.php?action=%@&sa=%@"

//分类
#define KUrl @"http://bq.cms.palmtrends.com/api_v2.php?action=%@sa=%@&offset=0&count=20& uid=13907332&platform=a&mobile=GT-S7562i&pid=10106&e=90fff795f0a1f0daecf160e0606761b9"

//详情
#define KitemUrl @"http://bq.cms.palmtrends.com/api_v2.php?action=article&id=%@&fontsize=m&mode=day&scrolly=0&uid=13907332&e=90fff795f0a1f0daecf160e0606761b9&platform=a&pid=10106&mobile=GT-S7562i"

//图吧详情
#define kpicUrl @"http://bq.cms.palmtrends.com/api_v2.php?action=commentcount&id=%@&uid=13907332&platform=a&mobile=GT-S7562i&pid=10106&e=90fff795f0a1f0daecf160e0606761b9"

//评论 POST
#define KCommentUrl @"http://bq.cms.palmtrends.com/api_v2.php?action=commentlist"

//提交 评论
#define kCommentSubmit @"http://bq.cms.palmtrends.com/api_v2.php"


/*
 
 首页：POST
 请求头：http://bq.cms.palmtrends.com/api_v2.php?action=top
 请求体：sa=home_top & offset=10 & count=10 & uid=13907332 & platform=a & mobile=GT-S7562i & pid=10106 & e=90fff795f0a1f0daecf160e0606761b9
 
 详情：GET
 http://bq.cms.palmtrends.com/api_v2.php?action=article&id=944&fontsize=m&mode=day&scrolly=0&uid=13907332&e=90fff795f0a1f0daecf160e0606761b9&platform=a&pid=10106&mobile=GT-S7562i
 
 
 1.热点追踪  POST
 环球军闻：
 请求头：http://bq.cms.palmtrends.com/api_v2.php?action=list
 请求体：sa=hqjwlist & offset=0 & count=20 & uid=13907332 & platform=a & mobile=GT-S7562i & pid=10106 & e=90fff795f0a1f0daecf160e0606761b9
 热点追踪：
 请求头：http://bq.cms.palmtrends.com/api_v2.php?action=list
 请求体：sa=rdzzlist & offset=0 & count=20 & uid=13907332 & platform=a & mobile=GT-S7562i & pid=10106 & e=90fff795f0a1f0daecf160e0606761b9
 
 2.中国视点：POST
 我军建设：
 请求头：http://bq.cms.palmtrends.com/api_v2.php?action=list
 请求体：sa=wjjslist & offset=0 & count=20 & uid=13907332 & platform=a & mobile=GT-S7562i & pid=10106 & e=90fff795f0a1f0daecf160e0606761b9
 中国制造：
 请求头：http://bq.cms.palmtrends.com/api_v2.php?action=list
 请求体：sa=zgzclist & offset=0 & count=20 & uid=13907332 & platform=a & mobile=GT-S7562i & pid=10106 & e=90fff795f0a1f0daecf160e0606761b9
 走向世界：
 请求头：http://bq.cms.palmtrends.com/api_v2.php?action=list
 请求体：sa=zxsjlist & offset=0 & count=20 & uid=13907332 & platform=a & mobile=GT-S7562i & pid=10106 & e=90fff795f0a1f0daecf160e0606761b9
 
 3.战争风云POST
 兵林史话：
 请求头：http://bq.cms.palmtrends.com/api_v2.php?action=list
 请求体：sa=binlin & offset=0 & count=20 & uid=13907332 & platform=a & mobile=GT-S7562i & pid=10106 & e=90fff795f0a1f0daecf160e0606761b9
 兵器百科：
 请求头：http://bq.cms.palmtrends.com/api_v2.php?action=list
 请求体：sa=binqi & offset=0 & count=20 & uid=13907332 & platform=a & mobile=GT-S7562i & pid=10106 & e=90fff795f0a1f0daecf160e0606761b9
 战场风云：
 请求头：http://bq.cms.palmtrends.com/api_v2.php?action=list
 请求体：sa=fengyun & offset=0 & count=20 & uid=13907332 & platform=a & mobile=GT-S7562i & pid=10106 & e=90fff795f0a1f0daecf160e0606761b9
 
 4.军迷天地POST———count
 图吧：
 请求头：http://bq.cms.palmtrends.com/api_v2.php?action=piclist
 请求体：sa=tuba & offset=0 & count=10 & uid=13907332 & platform=a & mobile=GT-S7562i & pid=10106 & e=90fff795f0a1f0daecf160e0606761b9
 
 "list": [
 {
 "icon": "/upload/day_130621/201306211011070_listthumb1_iphone4.jpg,/upload/day_130621/201306211011087_listthumb2_iphone4.jpg,/upload/day_130621/201306211114248_listthumb3_iphone4.jpg,/upload/day_130621/201306211011084_listthumb4_iphone4.jpg",
 "gid": "660",
 "title": "准中国苏-35巴黎航展精彩表演",
 "news": "1",
 "timestamp": "2013/06/21 10:00",
 "count": "5"
 },
 
 图吧详情:
 请求头：http://bq.cms.palmtrends.com/api_v2.php?action=commentcount
 请求体：id=660& uid=13907332 & platform=a & mobile=GT-S7562i & pid=10106 & e=90fff795f0a1f0daecf160e0606761b9
 
 军迷游记
 请求头：http://bq.cms.palmtrends.com/api_v2.php?action=piclist
 请求体：sa=youji & offset=0 & count=10 & uid=13907332 & platform=a & mobile=GT-S7562i & pid=10106 & e=90fff795f0a1f0daecf160e0606761b9
 {
 "def": 0,
 "code": 1,
 "list": [
 {
 "icon": "/upload/day_130621/201306211142374_listthumb1_iphone4.jpg,/upload/day_130621/201306211139456_listthumb2_iphone4.jpg,/upload/day_130621/201306211139480_listthumb3_iphone4.jpg,/upload/day_130621/201306211139519_listthumb4_iphone4.jpg",
 "gid": "664",
 "title": "中国海军和平方舟号医院船参加东盟医学联演",
 "news": "1",
 "timestamp": "2013/06/21 11:00",
 "count": "4"
 },
 
 读书：——year  ,icon   ,icon1  ,icon2   ,periods
 请求头：http://bq.cms.palmtrends.com/api_v2.php?action=cover
 请求体：sa=dushu & offset=0 & count=60 & uid=13907332 & platform=a & mobile=GT-S7562i & pid=10106 & e=90fff795f0a1f0daecf160e0606761b9
 
 
 {
 "code": 1,
 "list": [
 {
 "title": "《兵器》2012年",
 "list": [
 {
 "id": "686",
 "periods": "增刊B",
 "year": "2015",
 "icon": "/upload/day_130621/201306211416194_listthumb_iphone4.jpg",
 "title": "增刊B封面故事",
 "url": "",
 "des": "封面故事",
 "icon2": "/upload/day_130621/201306211416194_home_iphone4.jpg",
 "icon1": "/upload/day_130621/201306211416194_header_iphone4.jpg"
 },
 
 读书详情：POST
 请求体：http://bq.cms.palmtrends.com/api_v2.php?action=newspaper_list&id=685
 请求头：sa=685 & offset=0 & count=100 & uid=13907332 & platform=a & mobile=GT-S7562i & pid=10106 & e=90fff795f0a1f0daecf160e0606761b9
 
 {
 "code": 1,
 "msg": "",
 "list": [
 {
 "name": "环球军闻",
 "lists": [
 {
 "id": "721",
 "title": "“俄罗斯低速采购雅克-130”等24则"
 }
 ]
 },
 }
 
 
 5.掌中乾坤POST
 请求头：http://bq.cms.palmtrends.com/api_v2.php?action=list
 请求体：sa=qiankun & offset=0 & count=20 & uid=13907332 & platform=a & mobile=GT-S7562i & pid=10106 & e=90fff795f0a1f0daecf160e0606761b9
 
 6.设置
 
 
 意见反馈：POST
 请求头：http://bq.cms.palmtrends.com/api_v2.php?action=suggest
 请求体：suggest=kankan & os_ver=4.0.4 & email = & client_ver = 1.0.0 &uid = 13907332 & platform=a & mobile=GT-S7562i & pid=10106 & e=90fff795f0a1f0daecf160e0606761b9
 
 评论 POST
 请求头：http://bq.cms.palmtrends.com/api_v2.php?action=commentlist
 请求体：id=940 & offset=0 & count=20 & uid = 13907332 & platform=a & mobile=GT-S7562i & pid=10106 & e=90fff795f0a1f0daecf160e0606761b9
 
 请求头：http://bq.cms.palmtrends.com/api_v2.php
 请求体：action=wzpl&id=948&name=“匿名”&content=%@&avator=nil&uid = 13907332 & platform=a & mobile=GT-S7562i & pid=10106 & e=90fff795f0a1f0daecf160e0606761b9
 
 */




#endif
