//
//  Header.h
//  BuildSite
//
//  Created by huangbin on 14-6-13.
//  Copyright (c) 2014年 58. All rights reserved.
//
#define HexToUIColorRGB(value) [UIColor colorWithRed:((value&0xFF0000)>>16)/255.0 green:((value&0xFF00)>>8)/255.0 blue:(value&0xFF)/255.0 alpha:1.0]
#ifndef BuildSite_Header_h
#define BuildSite_Header_h

#define Cache_Indentifier   (@"cachevers=")
#define Conn_Indentifier    (@"BSFromConn")
#define Conn_Indentifier_Header (@"BSConnHeader")
#define Cache_Process_Indentifier (@"BSProcessHeader")

#define Memory_Cache_Size   (4*1024*1024)
#define Disk_Cache_Size     (4*1024*1024)
#define PLIST_NAME          (@"cacheRecords.plist")

#define NSKeyed_Data        (@"data")
#define NSKeyed_Response    (@"response")
#define Cache_path          (@"cachedFiles")

#define Base_URL            (@"http://webview.5858.com")
#define Old_Version         (@"oldVersion")

#define Phone_Num           (@"phoneNum")
#endif
