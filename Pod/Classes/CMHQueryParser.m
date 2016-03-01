#import "CMHQueryParser.h"

#define END_OF_QUERY '#'

@interface CMHQueryParser ()
@property (nonatomic) NSString *queryString;
@property (nonatomic) NSUInteger charIndex;
@property (nonatomic, readonly) unichar peek;
@end

@implementation CMHQueryParser

- (instancetype)init
{
    self = [super init];
    if (nil == self) return nil;

    self.queryStatements = [NSMutableArray new];

    return self;
}

- (void)parse:(NSString *)query
{
    if (nil == query) {
        return;
    }

    self.queryString = query;
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

    [self.queryStatements addObject:[statement copy]];
}

#pragma mark Getter-Setters
- (unichar)peek
{
    if (self.charIndex >= [self.queryString length]) {
        return END_OF_QUERY;
    }

    return [self.queryString characterAtIndex:self.charIndex];
}

@end
