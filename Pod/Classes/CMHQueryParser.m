#import "CMHQueryParser.h"

#define END_OF_QUERY '#'

@interface CMHQueryParser ()
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

    self.queryString = query;
    [self skipWhite];
    [self match:'['];

    while (self.peek != END_OF_QUERY) {
        [self eatStatement];
        [self skipWhite];

        if (self.peek != ']') {
            return;
        } else {
            [self match:','];
        }
    }
}

#pragma mark Private
- (void)advanceChar
{

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
}

- (void)eatStatement
{
    [self skipWhite];
    // TODO: advance past legal statement chars
}

#pragma mark Getter-Setters

- (NSArray<NSString *> *)statements
{
    if (nil == _statements) {
        return @[];
    }

    return _statements;
}

- (unichar)peek
{
    if (self.charIndex >= [self.queryString length]) {
        return END_OF_QUERY;
    }

    return [self.queryString characterAtIndex:self.charIndex];
}

@end
