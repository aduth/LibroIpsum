sourceText =
    long: 'The third birds of which they made off. To them, a bird\'s offer was often managed. Thus, it was.'
    single: 'The'

describe 'LibroIpsum', ->
    acceptableRandomVariance = 0.10

    describe '#generate()', ->
        it 'should generate the correct number of words', ->
            li = new LibroIpsum sourceText.long
            for keyLength in [3..7]
                for numWords in [1..6]
                    genText = li.generate numWords, keyLength
                    expect(genText.split(' ').length).to.be numWords

        it 'should have a cleanly formatted ending', ->
            li = new LibroIpsum sourceText.long
            genText = li.generate 10
            isClean = new RegExp("[^\\s\\\\#{LibroIpsum.clauseSeparators.join('\\\\')}]+\\.$").test genText
            expect(isClean).to.be.ok()

        it 'should gracefully handle end of text', ->
            li = new LibroIpsum sourceText.single
            expected = 'The The The.'
            genText = li.generate 3, 3
            expect(genText).to.be expected


    describe '#getKey()', ->
        li = new LibroIpsum sourceText.long

        it 'should choose keys from start of text or sentences', ->
            starters = ['The', 'To ', 'Thu']
            for i in [0..10]
                key = li.getKey 3
                expect(starters).to.contain key

        it "should choose keys with acceptable randomness (<#{acceptableRandomVariance * 100}% variance)", ->
            keys =
                'The': 0
                'To ': 0
                'Thu': 0
            iter = 1500
            for i in [1..iter]
                keys[li.getKey(3)]++

            sum = 0
            sum += val for k, val of keys
            expect(sum).to.equal iter
            avg = sum / Object.keys(keys).length
            for k, val of keys
                variance = Math.abs((val - avg)/val)
                expect(variance).to.be.lessThan acceptableRandomVariance


        it 'should choose keys of correct length', ->
            for len in [0..10]
                key = li.getKey len
                expect(key.length).to.equal len

    describe '#getDistributedChar', ->
        li = new LibroIpsum sourceText.long

        it "should choose characters with acceptable randomness (<#{acceptableRandomVariance * 100}% variance)", ->
            key = 'ird'
            iter = 1500
            options =
                ' ': 0
                's': 0
                '\'': 0
            for i in [1..iter]
                options[li.getDistributedChar(key)]++

            sum = 0
            sum += val for k, val of options
            expect(sum).to.equal iter
            avg = sum / Object.keys(options).length
            for k, val of options
                variance = Math.abs((val - avg)/val)
                expect(variance).to.be.lessThan acceptableRandomVariance