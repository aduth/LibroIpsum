# Libro Ipsum

Libro Ipsum is a simple placeholder text generator similar to other [lorem ipsum](http://en.wikipedia.org/wiki/Lorem_ipsum) tools. Libro Ipsum differs from traditional lorem ipsum in that it can be used to generate random phrases from any source text, using character distribution analysis to generate new phrases.

[View annotated source code](http://aduth.github.com/LibroIpsum)

Use Libro Ipsum from Node.js, RequireJS, or directly in the browser.

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

## How it works

"Character distribution analysis" is a bit cryptic, so here's an example:

![Libro Ipsum illustration](http://libroipsum.com/css/img/howitworks.png)

Libro Ipsum begins by choosing a seed of `keyLength` characters. In this example, we'll use a key length of 3. Note that seeds which start a sentence are given preference. Of the candidates available, one is chosen at random. Since we have only two sentences, and both start with "The", this is guaranteed to be the key.

After a seed is chosen, Libro Ipsum will scan the text to find every instance of this key (in this case, there are two instances of "The"). A new character will be chosen to add to the current generated phrase based upon the probability of the character appearing following the key. For "The", there is an equal chance that it will be followed by a ' ' (space) or an 'n'. Let's assume it randomly chooses 'n'. This character is added to the phrase (now "Then"), and the key is updated to the latest 3 characters (now "hen").

Looking at the second line, Libro Ipsum will continue to choose a new character using the same process outlined above. The two instances of the key "hen" are both followed by ' ' (space). Therefore, there is a 100% chance this character will be chosen. The phrase is now "Then ", and the key is "en ".

A new word has been created (delimited by a space character), and Libro Ipsum will continue this process until the desired number of words has been reached.

## License

Copyright (c) 2013 Andrew Duthie

Released under the MIT License (see LICENSE.txt)
