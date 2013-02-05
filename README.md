# LibroIpsum

LibroIpsum is a simple placeholder text generator similar to other [lorem ipsum](http://en.wikipedia.org/wiki/Lorem_ipsum) tools. LibroIpsum differs from traditional lorem ipsum in that it can be used to generate random phrases from any source text, using character distribution analysis to generate new phrases.

[View annotated source code](http://aduth.github.com/LibroIpsum)

Use LibroIpsum from Node.js, RequireJS, or directly in the browser.

### Node.js
    npm install libroipsum

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

## Examples

The following texts where generated from texts available at [Project Gutenberg](http://www.gutenberg.org/) and the [Commission on Presidential Debates](http://www.debates.org/index.php?page=debate-transcripts), using a key length of 7 with 80 words generated each.

_The Republic_ by Plato

> Certainly not. Neither purposes? At any rate let us place, and five of the bodily strength at the greatest repugnance to be what were we not say heavenly light? Perfectly unjust will not be creditable than an instrument which imitations and justice, if they will fancying that you are them bad? Assuredly no one knows, and who see the vision about as Stesichorus says that he.

_The Adventures of Huckleberry Finn_ by Mark Twain

> Grangerfords used to be all right. We'll send you worry; these thing down there we could get the thing he'd struck into the worst; one thing, and down from St. Petersburg. Goshen. Testament. So she hollow; but about yo' pints. I wish to be treated bad, and said if we minded our legs was taking the ordered and be a fool uv ole Jim's a night come look oncommon servants. It warn't hardly wait.

_Obama-Romney Debates (October 2012)_

> Veterans who were out the public lands than a year or two ago, we went first lady has said that lead nowhere it is also this debates, months with unemployed right that will always be the governor Romney because I think it's more that America as the same as Simpson as a man for you absolutely think interesting here. And when I sit down artificially our very expenses when the side of the hands of criminals, that we're.

## License

Copyright (c) 2013 Andrew Duthie

Released under the MIT License (see LICENSE.txt)
