//
//  DataAccessLayer.h
//  YoBu
//
//  Created by Harsh on 23/12/14.
//  Copyright (c) 2014 Harshdeep  Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataAccessLayer : NSObject

+ (void)saveDialedNumber:(NSString*)phoneNumber forContactName:(NSString*)contactName;
+ (void)saveFavoriteContactsWithName:(NSString*)name andWithPhoneNumber:(NSString*)phoneNumber andWithImageData:(NSData *) imageData;
+ (void)saveContactWithName:(NSString*)name andPhoneNumber:(NSString*)phoneNumber havingRecordIdAs:(NSString *)recordId;

+ (NSMutableArray *)fetchFrequentContacts;

+ (void)saveCustomSearchForDigit:(NSString*)digit withAlphabets:(NSString*)alphabets;

+ (NSString *)fetchCustomAlphabetsForDigit:(NSString*)digit;

+ (void)checkAndUpdateTabelWithDefaultAlphabets;

//Fetch recently dialed Contacts
+ (NSArray *)fetchRecentlyDialedContacts;
+ (NSArray *)fetchAllFrequentContacts;
+ (NSArray *)fetchAllFavoriteContacts;
+ (NSMutableArray *)fetchAllContacts;



+ (void)deleteModel:(id)modelToBeDeleted;








///*
// *********************************************************************************************************************
// DOCUMENT SAVE - This method stores the list of Documents,returned by the backend
// *********************************************************************************************************************
// */
//+ (void)saveUpdateDocumentlist:(NSString*)documentNumber docProcessDate:(NSString*)processDate withPhyInvRef:(NSString *)phyInvRef withDocumentType:(BOOL)documentType;
//
//
//
///*
// *********************************************************************************************************************
// PLANOGRAM SAVE - This method stores the planogram,or update the status of existing planogram  into the core data
// *********************************************************************************************************************
// */
//+ (void)saveDataforPlanogramInDocument:(NSString*)documentNumber withPlanogram:(NSString*)planogramName withPlanogramID:(NSString*)planogramID withSkuCount:(NSNumber *)skuCount;
//
//
//
///*
// *********************************************************************************************************************
// SKU DETAILS SAVE - This method save SKU details corresponding to Planogram ID and increase the expected count by 1 corresponding to SNU number
// *********************************************************************************************************************
// */
//+ (void)saveDataforSKUItemsInSKUDetail:(NSString*)documentNumber withPlanogram:(NSString*)pLanogramID withSKUNumber:(NSString*)skuNumber withProductname:(NSString*)productName withsequenceNumber:(NSString*)sequenceNumber withShelfNumber:(NSString *)shelfNumber withActualQuantity:(NSInteger )actualQuantity withCost:(NSNumber *)cost withThresholdCost:(NSNumber *)thresholdCost withthresholdQuantity:(NSNumber*)thresholdQuantity isPromoItem:(BOOL)promoItem;
//
//
///*
// *********************************************************************************************************************
// CYCLECOUNTSKUDETAILS SAVE - This method stores the Documents,planogramID,SKU number and Actual Quantity
// *********************************************************************************************************************
// */
//+ (void)saveCycleCountSKUDetail:(NSString*)documentNumber withPlagramID:(NSString*)planogramID withPlanogramName:(NSString *)planoramName withSKUNumber:(NSString*)skuNumber withActualQuantity:(NSInteger)actualQuantity;
//
///*
// *********************************************************************************************************************
// Set count 0 to Expected Quantity of a particular SKU number
// *********************************************************************************************************************
// */
//+ (void)reSetExpectedQuantityOfSKUNumber:(NSString*)documentNumber withPlanogram:(NSString*)pLanogramID withSKUNumber:(NSString*)skuNumber withSequence:(NSString *) sequenceNumber andWithShelfNumber:(NSString *) shelfNumber;
//
///*
// *********************************************************************************************************************
// Set count 0 to Expected Quantity of all SKU number corresponding to particular Planogram ID
// *********************************************************************************************************************
// */
//+ (void)reSetExpectedQuantityOfPlanogramID:(NSString*)documentNumber withPlanogram:(NSString*)pLanogramID;
//
///*
// *********************************************************************************************************************
// Set count 0 to Expected Quantity of all SKU number corresponding to particular Planogram ID
// *********************************************************************************************************************
// */
//+ (void)reSetExpectedQuantityOfDocumentNumber:(NSString*)documentNumber;
//
///*
// *********************************************************************************************************************
// This method update the Document status -> is submitted
// *********************************************************************************************************************
// */
//+ (void)updateDocumentStatusWithDocumentNumber:(NSString*)documentNumber andWithStatus:(BOOL)isStatusOpen andWithDocumentOpenByOtherUser:(BOOL) isDocumentByOtherUser;
//
///*
// *********************************************************************************************************************
// Update Expected Quantity on successful submission to beack end.
// *********************************************************************************************************************
// */
//+ (void)updateExpectedQuantityOnSuccessfulSubmission: (BOOL)isSuccess andForArray:(NSMutableArray *) arrayToUpdate;
//
///*
// *********************************************************************************************************************
// This method fetch all the Document Number.
// *********************************************************************************************************************
// */
//+(NSMutableArray *)fetchDocumentNumber;
//
///*
// *********************************************************************************************************************
// This method fetch all the Planogram details with SKU count for particular Document no.
// *********************************************************************************************************************
// */
//+ (NSMutableArray *)fetchPlanogramWithSKUcountForDocument:(NSString*)documentNumber;
//
///*
// *********************************************************************************************************************
// This method fetch all the SKU level details for a palanogram No.
// *********************************************************************************************************************
// */
//+ (NSMutableArray *)fetchAllSkuItemDetails:(NSString*)documentNo  withPlanogramNo:(NSString *)planogramNo;
//
//
///*
// *********************************************************************************************************************
// This method increments the sku
// *********************************************************************************************************************
// */
//+ (BOOL)isIncrementOfSkuQuantitySuccessful:(NSString*)documentNumber withPlanogram:(NSString*)pLanogramID withSKUNumber:(NSString*)skuNumber;
//
//+ (BOOL)isIncrementOfSkuQuantityForMultipleShelvesOrSequenceSuccessful:(CycleCountSKU *) skuModel andWithupc:(NSString *) upcScanned ;
//
//
//+ (NSMutableArray *) fetchAllSkusBeforeIncrement:(NSString*)documentNumber withPlanogram:(NSString*)pLanogramID withSKUNumber:(NSString*)skuNumber ;
//
//
///*
// *********************************************************************************************************************
// This method fetch CYCLECOUNTSKUDETAIL entity attribute
// *********************************************************************************************************************
// */
//+(NSMutableArray *)fetchSKUdetailModalWithSkuNumber:(NSString *) skuNumber;
//
///*
// *********************************************************************************************************************
// This method fetch Unscanned SKU Details
// *********************************************************************************************************************
// */
//+ (NSMutableArray *)returnUnscannedSkus:(NSString*)documentNumber;
//
//
//+ (NSMutableArray *)fetchAllSkusForUpdateQuantityAtBAckEnd;
//
//+(NSMutableArray *)fetchAllSkusForUpdateQuantityInLocalDB;
//
//
//+ (void)deleteDocumentAfterSuccessfulSubmissionWithDocumentNumber:(NSString*)documentNumber;
//
//+ (void)saveUpcForSku:(NSString*)documentNumber withPlagramID:(NSString*)planogramID withSKUNumber:(NSString*)skuNumber withUpc:(NSString *)upcNumber;
//
//+ (NSNumber *)getCurrentScannedQuantityWithDocumentNumber:(NSString*)documentNumber withPlanogram:(NSString*)pLanogramID withSKUNumber:(NSString*)skuNumber;
//
//+ (void)setAutomaticRecountForDocumentNumber:(NSString*)documentNumber withSKUNumber:(NSString*)skuNumber withAggregatedQty:(NSNumber*)aggQty;
//
//
///*
// *********************************************************************************************************************
// This method checks if aggreagated web service call has been already made or not
// *********************************************************************************************************************
// */
//+(BOOL)isAggregatedCallRequiredWithDocumentNumber:(NSString *)documentNumber;
//
//
///*
// *********************************************************************************************************************
// This method checks if discrepancy has occured in this document number
// *********************************************************************************************************************
// */
//+ (BOOL)isDiscrepancyInDocumentNumber:(NSString*)documentNumber ;
//
///*
// *********************************************************************************************************************
// This method checks increase the discrepancy counter---
// *********************************************************************************************************************
// */
//+ (void)updateDiscrepancyCounterStatusWithDocumentNumber:(NSString*)documentNumber;
//
///*
// *********************************************************************************************************************
// This method resolves the discrepancy for Document if any
// *********************************************************************************************************************
// */
//+ (void)resolveDiscrepancyForDocumentNumber:(NSString*)documentNumber isLocalValidation:(BOOL)isLocalValidation;
//
///*
// *********************************************************************************************************************
// This method checks if discrepancy counter has reached value 4 or not. If Discrepancy counter reached 4, no recount else REcount again.
// *********************************************************************************************************************
// */
//+(BOOL)isRecountRequiredWithDocumentNumber:(NSString *)documentNumber;
//
//+ (void)revertScanningIfDocumentIsLockedForData:(NSMutableArray *) arrayToUpdate;
//+(NSMutableArray *)getArrayToPostInCaseOfRecountForDocumentMumber:(NSString *) documentNumber;
//+(BOOL)isDocumentOfTypeRecount:(NSString *) documentNumber;
//+(BOOL)updateDocumentRecountStatus:(NSString *) documentNumber;
//+(void)deleteAllRecordsOlderThan21Days;
//
//
///*
// *********************************************************************************************************************
// This method fetches the docProcess date to show on the CCDocument List screen
// *********************************************************************************************************************
// */
//+(NSString *)fetchProcessDateWithDocumentNumber:(NSString *)documentNumber;
//
//+(void)deleteAlreadySubmittedDocumentsWithListOfOpenDocuments:(NSMutableArray *) listOfOpenDocuments;
//
//+ (void)updateQuantityForTesting:(NSString*)documentNumber ;


@end
