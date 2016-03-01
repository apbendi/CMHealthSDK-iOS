#import "CMHQueryParser.h"

#define END_OF_QUERY '#'

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

    self.queryString = [CMHQueryParser stripWhite:query];
    [self skipWhite];
    [self match:'['];

    while (self.peek != END_OF_QUERY) {
        [self eatStatement];
        [self skipWhite];

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

// TODO: remove for first pass extracting whitespace
- (void)skipWhite
{
    if (self.peek == ' ') {
        [self advanceChar];
    }
}

- (void)match:(unichar)c
{
    NSAssert(self.peek == c, @"Expected %C", c); // TODO: throw a real exception
    [self advanceChar];
}

- (void)eatStatement
{
    [self skipWhite];

    NSMutableString *statement = [NSMutableString stringWithFormat:@""];
    NSString *thisChar = nil;

    while (self.peek != ',' && self.peek != ']' && self.peek != END_OF_QUERY) {
        unichar peekChar = self.peek;
        thisChar = [NSString stringWithCharacters:&peekChar length:1];

        [statement appendString:thisChar];
        [self advanceChar];
    }

    if ([@"" isEqualToString:statement]) {
        return;
    }

    NSMutableArray *mutableStatements = [self.queryStatements mutableCopy];
    [mutableStatements addObject:[statement copy]];
    self.queryStatements = [mutableStatements copy];
}

+ (NSString *)stripWhite:(NSString *)aString
{
    NSMutableString *mutableNewString = [NSMutableString stringWithFormat:@""];

    for(int i = 0; i < aString.length; i++) {
        unichar thisChar = [aString characterAtIndex:i];
        if (' ' == thisChar || '\t' == thisChar) {
            continue;
        }

        [mutableNewString appendString:[NSString stringWithCharacters:&thisChar length:1]];
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
- (unichar)peek
{
    if (self.charIndex >= [self.queryString length]) {
        return END_OF_QUERY;
    }

    return [self.queryString characterAtIndex:self.charIndex];
}

@end
