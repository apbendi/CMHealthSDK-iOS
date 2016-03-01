#import <ResearchKit/ResearchKit.h>
#import "CMHQueryParser.h"

SpecBegin(CMHealth)

describe(@"CMHQueryParser", ^{
    it(@"should pass", ^{
        expect(1 == 1).to.equal(YES);
    });

    it(@"Should parse a query with one statement", ^{
        CMHQueryParser *parser = [CMHQueryParser new];

        [parser parse:@"[__class__ = \"ORKResult\"]"];

        expect(parser.queryStatements.count).to.equal(1);
        expect(parser.queryStatements.firstObject).to.equal(@"__class__ = \"ORKResult\"");
    });

    it(@"Should parse a query with two statements", ^{
        CMHQueryParser *parser = [CMHQueryParser new];

        [parser parse:@"[__class__ = \"ORKResult\", descriptor = \"MyDescriptor\"]"];

        expect(parser.queryStatements.count).to.equal(2);
        expect([parser.queryStatements objectAtIndex:0]).to.equal(@"__class__ = \"ORKResult\"");
        expect([parser.queryStatements objectAtIndex:1]).to.equal(@"descriptor = \"MyDescriptor\"");
    });

    it(@"Should handle whitespace gracefully", ^{
        it(@"Should parse a query with two statements", ^{
            CMHQueryParser *parser = [CMHQueryParser new];

            [parser parse:@"  [__class__ = \"ORKResult\",   descriptor = \"MyDescriptor\"]  "];

            expect(parser.queryStatements.count).to.equal(2);
            expect([parser.queryStatements objectAtIndex:0]).to.equal(@"__class__ = \"ORKResult\"");
            expect([parser.queryStatements objectAtIndex:1]).to.equal(@"descriptor = \"MyDescriptor\"");
        });
    });

    it(@"Should Pass", ^{
        expect(YES).to.equal(YES);
    });
});

SpecEnd

