# LibroIpsum

LibroIpsum is a simple placeholder text generator similar to other [lorem ipsum](http://en.wikipedia.org/wiki/Lorem_ipsum) tools. LibroIpsum differs from traditional lorem ipsum in that it can be used to generate random phrases from any source text, using character distribution analysis to generate new phrases.

[View annotated source code](http://aduth.github.com/LibroIpsum)

Use LibroIpsum from Node.js, RequireJS, or directly in the browser.

### Node.js
    npm install LibroIpsum

### RequireJS
    define(['path/to/libs/LibroIpsum.js'],
    function(LibroIpsum) {
        // ...
    });

### Browser
    <script src="path/to/libs/LibroIpsum.js"></script>

## Usage
    new LibroIpsum(sourceText).generate(numberOfWords[, keyLength]);

* `sourceText`: String representation of text from which phrases are to be generated
* `numberOfWords`: Number of words to be generated
* `keyLength`: Length of key (integer), where larger number will create phrase more similar to original text (optional, defaults to 6)

## License

Copyright (c) 2013 Andrew Duthie

Released under the MIT License (see LICENSE.txt)
