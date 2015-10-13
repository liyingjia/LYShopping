#ifndef PayWayConfig_h
#define PayWayConfig_h

#pragma mark ----- 支付宝 -----

/*
 *商户的唯一的parnter和seller。
 *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
 */
#define PartnerID @"2088911966483025"
#define SellerID  @"zhouaqiang@Foxmail.com"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMdwLPfVbYVU99fK0fh7cBUoXse78lcp0SisYOQyuPeKkNH0wUNApoxG6TDc+lOrFJVoozt7bPovgl/O8AOjF6e792WwuXO2BqI7O52XFyxwyldS9vCe89Unzc6BQ2OW6INRxug2G+5Vku4ws7qbWAmRAfUPel6GbQ3rSOq1KZUXAgMBAAECgYEAoxv0OxD7jINMW9lN1nol1bf5pELrVSwnGqu4ZomxSwqxnHUfJoCWdb188/CWbp1JrVQxw/ES1J7Mcs0M8PyO17bVz6VStVBz5u78qdaIqN3LJQu3ECS/Ml+kddlGp2eKs9VvmDDoHQeDL0S6oJ9DOxdD6bnkwsEybZEsF16PpDECQQDtDpi+JBp07T9TJNPcxs+ncINGiJGVL7kyZmBww0/MUJIpZiYJj1qjJM0yDFd0Wuo/GsoBIyPjbCqCMUtH39bvAkEA12AFoYjCosMVTGuDlVzfy7cOTzYpJPIh1sGBw0ayjTbF5iFBfHo/BEAaAyiHj9Y363jwKCAKqPB+I0BcecXkWQJAWnyP4UR2tNs6qMoN9OAOs6NG+M14hLHKx2o8tc5Xz22R3SuYqV2HA28wxEHhwBBUCfJ32SdIs66+KyQV0EGpEQJAZXBJVqqGGYjOeD7PK8MheN5P9AjrWgZc37wmNOYQZKhejyQspscg9QyH8+Lb7mgT0GkWm59zxdv3XP0MUSJeiQJBAJwXmgu2ryVKr/31gbXl9IwJ9kc99GzNEC64yZ7+lw8aWd6DePoKxFMWh0thfKPlGACCdzUOSkO/1jc8uDnzMBc="


#pragma mark ----- 微信支付 -----

// appID
#define __WXappID @"wx796b27a71317814d"

// appSecret
#define __WXappSecret @"6c2db26fe7c36dfe670ccf3e265a04fc"

//商户号，填写商户对应参数
#define __WXmchID @"1260164101"

//商户API密钥，填写相应参数
#define __WXpaySignKey @"ZHOUqiang0413ZHOUqiang0413ZHOUqi"

#pragma mark ----- 银联支付 -----

#define __UnionPayEnviromental  @"00"  // @"01" 测试   @"00" 正式
#endif
