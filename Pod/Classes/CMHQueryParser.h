#import <Foundation/Foundation.h>

@interface CMHQueryParser : NSObject

@property (nonatomic, nonnull, readonly) NSArray<NSString *> *queryStatements;

- (void)parse:(NSString *_Nullable)query;

@end
