#import <Foundation/Foundation.h>

@interface CMHQueryParser : NSObject

@property (nonatomic, nonnull) NSMutableArray<NSString *> *queryStatements;

- (void)parse:(NSString *_Nullable)query;

@end
