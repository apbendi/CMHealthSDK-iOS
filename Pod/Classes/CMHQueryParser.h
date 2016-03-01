#import <Foundation/Foundation.h>

@interface CMHQueryParser : NSObject

@property (nonatomic, nonnull, readonly) NSArray<NSString *> *queryStatements;
@property (nonatomic, nullable, readonly) NSString *query;

- (void)parse:(NSString *_Nullable)query;

@end
