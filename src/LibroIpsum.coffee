# [View on GitHub](http://github.com/aduth/LibroIpsum)

# LibroIpsum is a simple placeholder text generator similar to other [lorem ipsum](http://en.wikipedia.org/wiki/Lorem_ipsum) tools.
# LibroIpsum differs from traditional lorem ipsum in that it can be used to generate random phrases from any source text, using character distribution analysis to generate new phrases.

# Use LibroIpsum from Node.js, RequireJS, or directly in the browser.

# ## Node.js
#     npm install libroipsum
# ## RequireJS
#     define(['path/to/libs/LibroIpsum.js'],
#     function(LibroIpsum) {
#         // ...
#     });
# ## Browser
#     <script src="path/to/libs/LibroIpsum.js"></script>

# # Usage
#     new LibroIpsum(sourceText).generate(numberOfWords[, keyLength]);

# * `sourceText`: String representation of text from which phrases are to be generated
# * `numberOfWords`: Number of words to be generated
# * `keyLength`: Length of key (integer), where larger number will create phrase more similar to original text (optional, defaults to 6)

#
do ->
    # ## LibroIpsum
    # Generates phrases using character distribution of text from a given string
    class LibroIpsum
        # Ignore opening and closing punctuation because of difficulty to ensure matching pair
        @ignoredCharacters: [
            '"'
            '`'
            '‘', '’'
            '“', '”'
            '[', ']'
            '(', ')'
            '{', '}'
            '«', '»'
            '\r', '\n'
        ]

        # Sentence-ending characters. Used to locate phrase-starting key
        @sentenceEnders: [
            '.'
            '!'
            '?'
        ]

        # Clause-separating characters. Used to cleanly end generated phrase
        @clauseSeparators: [
            @sentenceEnders...
            ','
            ';'
        ]

        constructor: (@sourceText) ->
            @frequencyLib = new FrequencyLibrary

        # Return randomly generated phrase with `numberOfWords` words based on character distribution of text, using key length `keyLength`
        generate: (numberOfWords, keyLength = 6) ->
            currentWords = 1
            workingKey = @getKey(keyLength)
            phrase = workingKey

            while currentWords < numberOfWords
                distributedChar = @getDistributedChar(workingKey)
                if distributedChar?
                    workingKey += distributedChar
                    workingKey = workingKey.slice(1)
                else
                    phrase = phrase.replace /\s+$/, ''
                    distributedChar = ' '
                    if currentWords + 1 <= numberOfWords
                        workingKey = @getKey(keyLength)
                        distributedChar += workingKey

                phrase += distributedChar
                currentWords++ if /\s/.test(distributedChar)

            rCleanEnd = new RegExp("[\\\\#{LibroIpsum.clauseSeparators.join('\\\\')}\\s]*$")
            phrase = phrase.replace(rCleanEnd, '') + '.'

            phrase

        # Generates a random key from the text.
        # Preference is given to keys which start a sentence, but if no sentence structure is detected, a random substring is generated.
        getKey: (length) ->
            return '' if !length

            concatSentenceEnders = "\\\\#{LibroIpsum.sentenceEnders.join('\\\\')}"
            rKey = new RegExp("(^[A-Z][a-z]{#{length - 1}}|[#{concatSentenceEnders}]\\s*[A-Z][a-z]{#{length - 1}})", 'gm');
            keyMatch = @sourceText.match(rKey)

            if keyMatch
                rClean = new RegExp("^[#{concatSentenceEnders}]?\\s*(.+)")
                key = keyMatch[Math.floor(Math.random() * keyMatch.length)].replace(rClean, '$1')
            else
                startIndex = Math.floor(Math.random() * (@sourceText.length - length))
                key = @sourceText.substring(startIndex, startIndex + length)

            key

        # Returns a character based on the character distribution of characters following the specified key
        getDistributedChar: (key) ->
            unless @frequencyLib.contains(key)
                foundIndex = 0
                while foundIndex >= 0
                    foundIndex = @sourceText.indexOf(key, foundIndex)
                    keyMatchEnd = foundIndex + key.length
                    if foundIndex >= 0
                        foundIndex++
                        lookAhead = @sourceText[keyMatchEnd]
                        if keyMatchEnd < @sourceText.length and lookAhead not in LibroIpsum.ignoredCharacters
                            @frequencyLib.add(key, lookAhead)

            return null unless @frequencyLib.getFrequencies(key)
            @frequencyLib.randomUniformChoose(key)

    # ## MultiSet
    # A set in which members can appear more than once
    class MultiSet
        #
        constructor: (initialItem) ->
            @cardinality = 0
            @multiSetRep = {}

            @add(initialChar) if initialItem

        # Returns the number of elements in this multiset (ie its cardinality).
        # Because multisets can include duplicates, the cardinality may be larger than the number of distinct elements.
        getCardinality: ->
            @cardinality

        # Returns the number of occurrences of a given element in the multiset
        getElementCount: (target) ->
            @multiSetRep[target] or 0

        # Returns a set such that every element in the multiset is in the set (but no duplicates exist)
        getElementSet: ->
            Object.keys(@multiSetRep)

        # Adds a single element to the multiset, increasing cardinality by one
        add: (item) ->
            @multiSetRep[item] = 0 unless item of @multiSetRep
            @multiSetRep[item]++

            @cardinality++;

        # Removes the target, if it is present in the multiset.
        # Returns true if and only if it changes the multiset.
        # Note that this method removes only a single instance of the target.
        # Thus, assuming the target is in the multiset, this method decreases the cardinality of the multiset by one.
        remove: (target) ->
            return false unless target of @multiSetRep

            @multiSetRep[target]--
            delete @multiSetRep[target] if @multiSetRep[target] is 0

            @cardinality--

        # Returns an item chosen randomly based upon the distribution of items of the multiset
        randomUniformChoose: ->
            choice = Math.floor(Math.random() * @cardinality)

            for key, keyCount of @multiSetRep
                choice -= keyCount
                if choice < 0
                    return key

    # ## FrequencyLibrary
    # Helper class for tracking character distribution following keys, and choosing random character based upon distribution.
    class FrequencyLibrary
        #
        constructor: ->
            @freqLibRep = {}

        # Returns number of keys in the library
        size: ->
            Object.keys(@freqLibRep).length

        # Returns true if the target book is contained in the library
        contains: (target) ->
            target of @freqLibRep

        # Returns a MultiSet for the specified key in the library
        getFrequencies: (target) ->
            return @freqLibRep[target]

        # Modifies the character occurrences associated with name to include one more occurrence of element
        add: (name, element) ->
            ms = @getFrequencies(name)

            unless ms?
                ms = @freqLibRep[name] = new MultiSet

            ms.add(element)

        # Modifies the character occurrences associated with name to include one less occurrence of element.
        # If this removal results in no elements being associated with name, name is removed from the library.
        # Returns true if and only if removal was successful.
        remove: (name, element) ->
            return false unless @contains(target)

            ms = @getFrequencies(name)

            cardBefore = ms.getCardinality()
            ms.remove(element)
            cardAfter = ms.getCardinality()

            freqLibRep.remove(name) if ms.getCardinality() is 0

            cardBefore - cardAfter is 1

        # Returns a random character, chosen from the same distribution as the characters appear in the text.
        # For example, if 15% of the characters following "the" are 'i', then this method should return an 'i' 15% of the time.
        randomUniformChoose: (name) ->
            ms = @getFrequencies(name)
            return 0 unless ms?
            ms.randomUniformChoose()

    # Object.keys polyfill (ES5)
    Object.keys ?= (obj) ->
        key for key of obj when obj.hasOwnProperty(key)

    # ## Expose LibroIpsum

    # Add to global object
    this.LibroIpsum = LibroIpsum

    # Expose to Node.js
    module.exports = LibroIpsum if module?.exports?

    # Define with RequireJS
    if typeof define is 'function' and define.amd?
        define 'LibroIpsum', -> LibroIpsum
