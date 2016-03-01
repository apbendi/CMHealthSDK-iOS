#import "CMHQueryParser.h"

#define END_OF_QUERY '#'

@interface NSMutableString (CMHQueryParser)
- (void)appendUnichar:(unichar)c;
@end

@implementation NSMutableString (CMHQueryParser)

- (void)appendUnichar:(unichar)c
{
    [self appendString:[NSString stringWithCharacters:&c length:1]];
}

@end

@interface CMHQueryParser ()
@property (nonatomic, nonnull, readwrite) NSArray<NSString *> *queryStatements;
@property (nonatomic) NSString *queryString;
@property (nonatomic) NSUInteger charIndex;
@property (nonatomic, readonly) unichar peek;
@end

@implementation CMHQueryParser

- (void)parse:(NSString *)query
{
    if (nil == query) {
        return;
    }

    if ([CMHQueryParser containsOr:query]) {
        @throw [NSException exceptionWithName:@"InvalidQueryException" reason:@"Use of 'or' statements not supported" userInfo:nil];
    }

    self.queryString = [CMHQueryParser stripWhite:query];
    self.charIndex = 0;

    [self match:'['];

    while (self.peek != END_OF_QUERY) {
        [self eatStatement];

        if (self.peek == ']') {
            return;
        } else {
            [self match:','];
        }
    }
}

#pragma mark Private
- (void)advanceChar
{
    self.charIndex++;
}

- (void)match:(unichar)c
{
    if (c != self.peek) {
        @throw [NSException exceptionWithName:@"InvalidQueryException" reason:nil userInfo:nil];
    }

    [self advanceChar];
}

- (void)eatStatement
{
    NSMutableString *statement = [NSMutableString stringWithFormat:@""];

    while (self.peek != ',' && self.peek != ']' && self.peek != END_OF_QUERY) {
        [statement appendUnichar:self.peek];
        [self advanceChar];
    }

    [self addStatement:[statement copy]];
}

- (void)addStatement:(NSString *)statement
{
    if ([@"" isEqualToString:statement]) {
        return;
    }

    NSMutableArray *mutableStatements = [self.queryStatements mutableCopy];
    [mutableStatements addObject:statement];
    self.queryStatements = [mutableStatements copy];
}

+ (BOOL)containsOr:(NSString *)query
{
    NSError *regexError = nil;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"\\s+or\\s+" options:0 error:&regexError];
    NSAssert(nil == regexError, @"Parser, internal error in regular expression %@", regexError.localizedDescription);

    NSArray *matches = [regEx matchesInString:query options:0 range:NSMakeRange(0, query.length)];

    return matches.count > 0;
}

+ (NSString *)stripWhite:(NSString *)aString
{
    NSMutableString *mutableNewString = [NSMutableString stringWithFormat:@""];

    for(int i = 0; i < aString.length; i++) {
        unichar thisChar = [aString characterAtIndex:i];
        if (' ' == thisChar || '\t' == thisChar) {
            continue;
        }

        [mutableNewString appendUnichar:thisChar];
    }

    return [mutableNewString copy];
}

#pragma mark Getter-Setters
- (NSArray<NSString *> *)queryStatements
{
    if (nil == _queryStatements) {
        _queryStatements = @[];
    }

    return _queryStatements;
}

- (NSString *)query
{
    NSMutableString *mutableQuery = [NSMutableString stringWithFormat:@"["];
    BOOL first = YES;

    for (NSString *statement in self.queryStatements) {
        if (first) {
            first = NO;
        } else {
            [mutableQuery appendString:@","];
        }

        [mutableQuery appendString:statement];
    }

    [mutableQuery appendString:@"]"];
    return [mutableQuery copy];
}

- (unichar)peek
{
    if (self.charIndex >= [self.queryString length]) {
        return END_OF_QUERY;
    }

    return [self.queryString characterAtIndex:self.charIndex];
}

@end
