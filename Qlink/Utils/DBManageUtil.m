//
//  DBManageUtil.m
//  Qlink
//
//  Created by 旷自辉 on 2018/6/15.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "DBManageUtil.h"
#import <BGFMDB/BGFMDB.h>
#import <BGFMDB/BGDB.h>
#import "HistoryRecrdInfo.h"
#import "VPNMode.h"
#import "WalletUtil.h"

@implementation DBManageUtil

+ (void) updateDBversion {
    
    NSArray *objArr = nil;
    
    if ([[BGDB shareManager] bg_isExistWithTableName:VPNREGISTER_TABNAME]) {
        
        objArr = [[BGDB shareManager] bg_executeSql:[NSString stringWithFormat:@"select * from sqlite_master where name='%@' and sql like '%%%@%%'",VPNREGISTER_TABNAME,bg_sqlKey(@"isMainNet")] tablename:VPNREGISTER_TABNAME class:[VPNInfo class]];
        if (objArr == nil || objArr.count == 0) {
            NSInteger version = [VPNInfo bg_version:VPNREGISTER_TABNAME];
            version += 1;
            [VPNInfo bg_update:VPNREGISTER_TABNAME version:version];
        }
    }
    
    if ([[BGDB shareManager] bg_isExistWithTableName:HISTORYRECRD_TABNAME]) {
      objArr = [[BGDB shareManager] bg_executeSql:[NSString stringWithFormat:@"select * from sqlite_master where name='%@' and sql like '%%%@%%'",HISTORYRECRD_TABNAME,bg_sqlKey(@"isMainNet")] tablename:HISTORYRECRD_TABNAME class:[HistoryRecrdInfo class]];
        if (objArr == nil || objArr.count == 0) {
            NSInteger version = [HistoryRecrdInfo bg_version:HISTORYRECRD_TABNAME];
            version += 1;
            [HistoryRecrdInfo bg_update:HISTORYRECRD_TABNAME version:version];
        }
    }
}

+ (VPNInfo *)getVpnInfo:(NSString *)vpnName {
    NSArray *finfAlls = [VPNInfo bg_find:VPNREGISTER_TABNAME where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",bg_sqlKey(@"bg_vpnName"),bg_sqlValue(vpnName),bg_sqlKey(@"isMainNet"),bg_sqlValue(@([WalletUtil checkServerIsMian]))]];
    VPNInfo *vpnInfo = nil;
    if (finfAlls && finfAlls.count > 0) {
        vpnInfo = finfAlls.firstObject;
    }
    
    return vpnInfo;
}

@end
