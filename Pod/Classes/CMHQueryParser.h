#import <Foundation/Foundation.h>

@interface CMHQueryParser : NSObject

@property (nonatomic, nonnull) NSArray<NSString *> *statements;

- (void)parse:(NSString *_Nullable)query;

@end
