#import "ORKResult+CMHealth.h"
#import "CMHResult.h"
#import "Cocoa+CMHealth.h"
#import "ORKConsentSignature+CMHealth.h"
#import "CMHConstants_internal.h"
#import "CMHErrors.h"
#import "CMHErrorUtilities.h"

@implementation ORKResult (CMHealth)

#pragma mark Public API

- (void)cmh_saveWithCompletion:(_Nullable CMHSaveCompletion)block
{
    [self cmh_saveToStudyWithDescriptor:nil withCompletion:block];
}

- (void)cmh_saveToStudyWithDescriptor:(NSString *_Nullable)descriptor withCompletion:(_Nullable CMHSaveCompletion)block;
{
    CMHResult *resultWrapper = [[CMHResult alloc] initWithResearchKitResult:self andStudyDescriptor:descriptor];

    [resultWrapper saveWithUser:[CMStore defaultStore].user callback:^(CMObjectUploadResponse *response) {
        if (nil == block) {
            return;
        }

        NSError *error = [ORKResult errorForUploadWithObjectId:resultWrapper.objectId uploadResponse:response];
        if (nil != error) {
            block(nil, error);
            return;
        }

        block(response.uploadStatuses[resultWrapper.objectId], nil);
    }];
}

+ (void)cmh_fetchUserResultsWithCompletion:(_Nullable CMHFetchCompletion)block
{
    [self cmh_fetchUserResultsForStudyWithDescriptor:nil withCompletion:block];
}

+ (void)cmh_fetchUserResultsForStudyWithDescriptor:(NSString *_Nullable)descriptor withCompletion:(_Nullable CMHFetchCompletion)block;
{
    if (nil == descriptor) {
        descriptor = @"";
    }

    NSString *queryString = [NSString stringWithFormat:@"[%@ = \"%@\", %@ = \"%@\"]", CMInternalClassStorageKey, [CMHResult class], CMHStudyDescriptorKey, descriptor];

    [[CMStore defaultStore] searchUserObjects:queryString
                            additionalOptions:nil
                                     callback:^(CMObjectFetchResponse *response)
     {
         NSMutableArray *mutableResults = [NSMutableArray new];
         for (CMHResult *wrappedResult in response.objects) {
             if (nil == wrappedResult.rkResult || ![wrappedResult.rkResult isKindOfClass:[self class]]) {
                 continue;
             }

             [mutableResults addObject:wrappedResult.rkResult];
         }

         block([mutableResults copy], nil);
     }];
}

# pragma mark Error Generators

+ (NSError * _Nullable)errorWithMessage:(NSString * _Nonnull)message andCode:(NSInteger)code
{
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: message };
    NSError *error = [NSError errorWithDomain:@"CMHResultSaveError" code:code userInfo:userInfo];
    return error;
}

+ (NSError *_Nullable)errorForUploadWithObjectId:(NSString *_Nonnull)objectId uploadResponse:(CMObjectUploadResponse *)response
{
    NSString *errorPrefix = NSLocalizedString(@"Failed to save results", nil);

    NSError *responseError = [self errorForInternalError:response.error withPrefix:errorPrefix];
    if (nil != responseError) {
        return responseError;
    }

    if (nil == response.uploadStatuses || nil == [response.uploadStatuses objectForKey:objectId]) {
        NSString *noStatusMessage = [NSString localizedStringWithFormat:@"%@. No response received", errorPrefix];
        return [CMHErrorUtilities errorWithCode:CMHErrorInvalidResponse
                           localizedDescription:noStatusMessage];
    }

    NSString *resultUploadStatus = [response.uploadStatuses objectForKey:objectId];

    if(![@"created" isEqualToString:resultUploadStatus] && ![@"updated" isEqualToString:resultUploadStatus]) {
        NSString *invalidStatusMessage = [NSString localizedStringWithFormat:@"%@. Invalid upload status returned: %@", errorPrefix, resultUploadStatus];
        return [CMHErrorUtilities errorWithCode:CMHErrorInvalidResponse localizedDescription:invalidStatusMessage];
    }

    return nil;
}

+ (NSError *_Nullable)errorForInternalError:(NSError *_Nullable)error withPrefix:(NSString *_Nonnull)prefix
{
    if (nil == error) {
        return nil;
    }

    if (![error.domain isEqualToString:CMErrorDomain]) {
        NSString *unknownMessage = [NSString stringWithFormat:@"%@. %@ (%@, %li)", prefix, error.localizedDescription, error.domain, error.code];
        return [CMHErrorUtilities errorWithCode:CMHErrorUnknown localizedDescription:unknownMessage];
    }

    CMHError localCode = [self localCodeForCloudMineCode:error.code];
    NSString *message = [NSString stringWithFormat:@"%@. %@", prefix, [self messageForCode:localCode]];

    return [CMHErrorUtilities errorWithCode:localCode localizedDescription:message];
}

+ (CMHError)localCodeForCloudMineCode:(CMErrorCode)code
{
    switch (code) {
        case CMErrorUnknown:
            return CMHErrorUnknown;
        case CMErrorServerConnectionFailed:
            return CMHErrorServerConnectionFailed;
        case CMErrorServerError:
            return CMHErrorServerError;
        case CMErrorNotFound:
            return CMHErrorNotFound;
        case CMErrorInvalidRequest:
            return CMHErrorInvalidRequest;
        case CMErrorInvalidResponse:
            return CMHErrorInvalidResponse;
        case CMErrorUnauthorized:
            return CMHErrorUnauthorized;
        default:
            return CMHErrorUnknown;
    }
}

+ (NSString *_Nullable)messageForCode:(CMHError)errorCode
{
    switch (errorCode) {
        case CMHErrorServerConnectionFailed:
            return NSLocalizedString(@"Connection to the server failed", nil);
        case CMHErrorServerError:
            return NSLocalizedString(@"A server error occurred", nil);
        case CMHErrorNotFound:
            return NSLocalizedString(@"Requested object was not found", nil);
        case CMHErrorInvalidRequest:
            return NSLocalizedString(@"The request was invalid", nil);
        case CMHErrorInvalidResponse:
            return NSLocalizedString(@"The response was invalid", nil);
        case CMHErrorUnauthorized:
            return NSLocalizedString(@"The request was unauthorized", nil);
        case CMHErrorUnknown:
        default:
            return NSLocalizedString(@"An unknown error occurred", nil);
            break;
    }
}

@end
