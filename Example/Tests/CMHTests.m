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
        expect(parser.queryStatements.firstObject).to.equal(@"__class__=\"ORKResult\"");
    });

    it(@"Should parse a query with two statements", ^{
        CMHQueryParser *parser = [CMHQueryParser new];

        [parser parse:@"[__class__ = \"ORKResult\", descriptor = \"MyDescriptor\"]"];

        expect(parser.queryStatements.count).to.equal(2);
        expect([parser.queryStatements objectAtIndex:0]).to.equal(@"__class__=\"ORKResult\"");
        expect([parser.queryStatements objectAtIndex:1]).to.equal(@"descriptor=\"MyDescriptor\"");
    });

    it(@"Should handle whitespace gracefully", ^{
        CMHQueryParser *parser = [CMHQueryParser new];

        [parser parse:@"  [\t__class__ =  \"ORKResult\" ,     descriptor = \"MyDescriptor\"]  "];

        expect(parser.queryStatements.count).to.equal(2);
        expect([parser.queryStatements objectAtIndex:0]).to.equal(@"__class__=\"ORKResult\"");
        expect([parser.queryStatements objectAtIndex:1]).to.equal(@"descriptor=\"MyDescriptor\"");
    });

    it(@"Should handle an empty query", ^{
        CMHQueryParser *parser = [CMHQueryParser new];

        [parser parse: @"[]"];

        expect(parser.queryStatements.count).to.equal(0);
    });

    it(@"Should ignore empty statements", ^{
        CMHQueryParser *parser = [CMHQueryParser new];

        [parser parse:@"[,__class__=\"ORKResult\", ,]"];

        expect(parser.queryStatements.count).to.equal(1);
        expect(parser.queryStatements.firstObject).to.equal(@"__class__=\"ORKResult\"");
    });

    it(@"Should raise an exception if the query doesn't start with brackets", ^{
        CMHQueryParser *parser = [CMHQueryParser new];

        expect(^{
            [parser parse:@"__class__ = \"NSObject\""];
        }).to.raise(@"InvalidQueryException");
    });

    it(@"Should combine statements when parsing multiple queries", ^{
        CMHQueryParser *parser = [CMHQueryParser new];

        [parser parse:@"[__class__ = \"ORKResult\"]"];
        [parser parse:@"[descriptor = \"MyDescriptor\"]"];

        expect(parser.queryStatements.count).to.equal(2);
        expect([parser.queryStatements objectAtIndex:0]).to.equal(@"__class__=\"ORKResult\"");
        expect([parser.queryStatements objectAtIndex:1]).to.equal(@"descriptor=\"MyDescriptor\"");
    });

    it(@"Should return empty brackets for an empty query", ^{
        CMHQueryParser *parser = [CMHQueryParser new];

        expect(parser.query).to.equal(@"[]");
    });

    it(@"Should reassemble a query with two statements", ^{
        CMHQueryParser *parser = [CMHQueryParser new];

        [parser parse:@"[__class__ = \"ORKResult\", descriptor = \"MyDescriptor\"]"];

        expect(parser.query).to.equal(@"[__class__=\"ORKResult\",descriptor=\"MyDescriptor\"]");
    });

    it(@"Should reassemble a query with one statement", ^{
        CMHQueryParser *parser = [CMHQueryParser new];

        [parser parse:@"[__class__ = \"ORKResult\"]"];

        expect(parser.query).to.equal(@"[__class__=\"ORKResult\"]");
    });

    it(@"Should raise an exception for a query joined by or statements", ^{
        CMHQueryParser *parser = [CMHQueryParser new];

        expect(^{
            [parser parse:@"[__class__ = \"ORKResult\" or descriptor = \"MyDescriptor\"]"];
        }).to.raise(@"InvalidQueryException");
    });

    it(@"Should raise an excpetion for a query combining ',' and 'or' statements", ^{
        CMHQueryParser *parser = [CMHQueryParser new];

        expect(^{
            [parser parse:@"[__class__ = \"ORKResult\", descriptor = \"SomeDescriptor\" or descriptor = \"MyDescriptor\"]"];
        }).to.raise(@"InvalidQueryException");
    });

    it(@"Should Pass", ^{
        expect(YES).to.equal(YES);
    });
});

SpecEnd

