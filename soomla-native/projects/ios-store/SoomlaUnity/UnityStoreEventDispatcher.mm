
#import "UnityStoreEventDispatcher.h"
#import "EventHandling.h"
#import "AppStoreItem.h"
#import "VirtualGood.h"
#import "VirtualCurrency.h"
#import "EquippableVG.h"
#import "UpgradeVG.h"
#import "PurchasableVirtualItem.h"

@implementation UnityStoreEventDispatcher

+ (void)initialize {
    static UnityStoreEventDispatcher* instance = nil;
    if (!instance) {
        instance = [[UnityStoreEventDispatcher alloc] init];
    }
}

- (id) init {
    if (self = [super init]) {
        [EventHandling observeAllEventsWithObserver:self withSelector:@selector(handleEvent:)];
    }
    
    return self;
}

- (void)handleEvent:(NSNotification*)notification{
	
	if ([notification.name isEqualToString:EVENT_BILLING_NOT_SUPPORTED]) {
	        UnitySendMessage("StoreEvents", "onBillingNotSupported", "");
	} 
	else if ([notification.name isEqualToString:EVENT_BILLING_SUPPORTED]) {
	    UnitySendMessage("StoreEvents", "onBillingSupported", "");
	}
	else if ([notification.name isEqualToString:EVENT_CURRENCY_BALANCE_CHANGED]) {
	    NSDictionary* userInfo = [notification userInfo];
	    VirtualCurrency* vc = [userInfo objectForKey:DICT_ELEMENT_CURRENCY];
		int balance = [(NSNumber*)[userInfo objectForKey:DICT_ELEMENT_BALANCE] intValue];
		int added = [(NSNumber*)[userInfo objectForKey:DICT_ELEMENT_AMOUNT_ADDED] intValue];
	    UnitySendMessage("StoreEvents", "onCurrencyBalanceChanged", [[NSString stringWithFormat:@"%@#SOOM#%d#SOOM#%d", vc.itemId, balance, added] UTF8String]);
	}
	else if ([notification.name isEqualToString:EVENT_GOOD_BALANCE_CHANGED]) {
	    NSDictionary* userInfo = [notification userInfo];
	    VirtualGood* vg = [userInfo objectForKey:DICT_ELEMENT_GOOD];
		int balance = [(NSNumber*)[userInfo objectForKey:DICT_ELEMENT_BALANCE] intValue];
		int added = [(NSNumber*)[userInfo objectForKey:DICT_ELEMENT_AMOUNT_ADDED] intValue];
        UnitySendMessage("StoreEvents", "onGoodBalanceChanged", [[NSString stringWithFormat:@"%@#SOOM#%d#SOOM#%d", vg.itemId, balance, added] UTF8String]);
    }
	else if ([notification.name isEqualToString:EVENT_GOOD_EQUIPPED]) {
        EquippableVG* vg = [notification.userInfo objectForKey:DICT_ELEMENT_EquippableVG];
        UnitySendMessage("StoreEvents", "onGoodEquipped", [vg.itemId UTF8String]);
    }
	else if ([notification.name isEqualToString:EVENT_GOOD_UNEQUIPPED]) {
        EquippableVG* vg = [notification.userInfo objectForKey:DICT_ELEMENT_EquippableVG];
        UnitySendMessage("StoreEvents", "onGoodUnequipped", [vg.itemId UTF8String]);
    }
	else if ([notification.name isEqualToString:EVENT_GOOD_UPGRADE]) {
		VirtualGood* vg = [notification.userInfo objectForKey:DICT_ELEMENT_GOOD];
        UpgradeVG* vgu = [notification.userInfo objectForKey:DICT_ELEMENT_UpgradeVG];
        UnitySendMessage("StoreEvents", "onGoodUpgrade", [[NSString stringWithFormat:@"%@#SOOM#%@", vg.itemId, vgu.itemId] UTF8String]);
    }
	else if ([notification.name isEqualToString:EVENT_ITEM_PURCHASED]) {
        PurchasableVirtualItem* pvi = [notification.userInfo objectForKey:DICT_ELEMENT_PURCHASABLE];
        UnitySendMessage("StoreEvents", "onItemPurchased", [pvi.itemId UTF8String]);
    }
	else if ([notification.name isEqualToString:EVENT_ITEM_PURCHASE_STARTED]) {
		PurchasableVirtualItem* pvi = [notification.userInfo objectForKey:DICT_ELEMENT_PURCHASABLE];
        UnitySendMessage("StoreEvents", "onItemPurchaseStarted", [pvi.itemId UTF8String]);
    }
	else if ([notification.name isEqualToString:EVENT_APPSTORE_PURCHASE_CANCELLED]) {
        PurchasableVirtualItem* pvi = [notification.userInfo objectForKey:DICT_ELEMENT_PURCHASABLE];
        UnitySendMessage("StoreEvents", "onMarketPurchaseCancelled", [pvi.itemId UTF8String]);
    }
	else if ([notification.name isEqualToString:EVENT_APPSTORE_PURCHASED]) {
        PurchasableVirtualItem* pvi = [notification.userInfo objectForKey:DICT_ELEMENT_PURCHASABLE];
        UnitySendMessage("StoreEvents", "onMarketPurchase", [pvi.itemId UTF8String]);
    }
    else if ([notification.name isEqualToString:EVENT_APPSTORE_PURCHASE_STARTED]) {
	    PurchasableVirtualItem* pvi = [notification.userInfo objectForKey:DICT_ELEMENT_PURCHASABLE];
	    UnitySendMessage("StoreEvents", "onMarketPurchaseStarted", [pvi.itemId UTF8String]);
	}
    else if ([notification.name isEqualToString:EVENT_TRANSACTION_RESTORED]) {
		NSNumber* successNum = [notification.userInfo objectForKey:DICT_ELEMENT_SUCCESS];
        UnitySendMessage("StoreEvents", "onRestoreTransactions", [[NSString stringWithFormat:@"%d", [successNum intValue]] UTF8String]);
    }
    else if ([notification.name isEqualToString:EVENT_TRANSACTION_RESTORE_STARTED]) {
        UnitySendMessage("StoreEvents", "onRestoreTransactionsStarted", "");
    }
    else if ([notification.name isEqualToString:EVENT_UNEXPECTED_ERROR_IN_STORE]) {
        UnitySendMessage("StoreEvents", "onUnexpectedErrorInStore", "");
    }
    else if ([notification.name isEqualToString:EVENT_STORECONTROLLER_INIT]) {
        UnitySendMessage("StoreEvents", "onStoreControllerInitialized", "");
    }
}

@end
