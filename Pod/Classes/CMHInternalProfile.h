#import <CloudMine/CloudMine.h>

@interface CMHInternalProfile : CMObject

@property (nonatomic, nullable) NSString *email;
@property (nonatomic, nullable) NSString *givenName;
@property (nonatomic, nullable) NSString *familyName;
@property (nonatomic, nullable) NSString *gender;
@property (nonatomic, nullable) NSDate *dateOfBirth;

@end
