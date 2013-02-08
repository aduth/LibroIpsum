/*! libroipsum 0.1.3 | (c) 2013 Andrew Duthie <andrew@andrewduthie.com> | MIT License */
(function() {
  var __slice = [].slice,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  (function() {
    var FrequencyLibrary, LibroIpsum, MultiSet, _ref;
    LibroIpsum = (function() {

      LibroIpsum.ignoredCharacters = ['"', '`', '‘', '’', '“', '”', '[', ']', '(', ')', '{', '}', '«', '»', '\r', '\n'];

      LibroIpsum.sentenceEnders = ['.', '!', '?'];

      LibroIpsum.clauseSeparators = __slice.call(LibroIpsum.sentenceEnders).concat([','], [';']);

      function LibroIpsum(sourceText) {
        this.sourceText = sourceText;
        this.frequencyLib = new FrequencyLibrary;
      }

      LibroIpsum.prototype.generate = function(numberOfWords, keyLength) {
        var currentWords, distributedChar, phrase, rCleanEnd, workingKey;
        if (keyLength == null) {
          keyLength = 6;
        }
        if (!(numberOfWords > 0)) {
          return '';
        }
        workingKey = this.getKey(keyLength);
        currentWords = (workingKey.match(/\s/g) || []).length + 1;
        phrase = workingKey;
        while (currentWords <= numberOfWords) {
          distributedChar = this.getDistributedChar(workingKey);
          if (distributedChar != null) {
            workingKey += distributedChar;
            workingKey = workingKey.slice(1);
            if (/\s/.test(distributedChar)) {
              currentWords++;
            }
          } else {
            phrase = phrase.replace(/\s+$/, '');
            workingKey = this.getKey(keyLength);
            distributedChar = " " + workingKey;
            currentWords += (workingKey.match(/\s/g) || []).length + 1;
          }
          phrase += distributedChar;
        }
        rCleanEnd = new RegExp("[\\\\" + (LibroIpsum.clauseSeparators.join('\\\\')) + "\\s]*$");
        phrase = phrase.split(' ').slice(0, numberOfWords).join(' ').replace(rCleanEnd, '') + '.';
        return phrase;
      };

      LibroIpsum.prototype.getKey = function(length) {
        var concatSentenceEnders, key, keyMatch, rClean, rKey, startIndex;
        if (!length) {
          return '';
        }
        concatSentenceEnders = "\\\\" + (LibroIpsum.sentenceEnders.join('\\\\'));
        rKey = new RegExp("(^[A-Z].{" + (length - 1) + "}|[" + concatSentenceEnders + "]\\s*[A-Z].{" + (length - 1) + "})", 'gm');
        keyMatch = this.sourceText.match(rKey);
        if (keyMatch) {
          rClean = new RegExp("^[" + concatSentenceEnders + "]?\\s*(.+)");
          key = keyMatch[Math.floor(Math.random() * keyMatch.length)].replace(rClean, '$1');
        } else {
          startIndex = Math.floor(Math.random() * (this.sourceText.length - length));
          key = this.sourceText.substring(startIndex, startIndex + length);
        }
        return key;
      };

      LibroIpsum.prototype.getDistributedChar = function(key) {
        var foundIndex, keyMatchEnd, lookAhead;
        if (!this.frequencyLib.contains(key)) {
          foundIndex = 0;
          while (foundIndex >= 0) {
            foundIndex = this.sourceText.indexOf(key, foundIndex);
            keyMatchEnd = foundIndex + key.length;
            if (foundIndex >= 0) {
              foundIndex++;
              lookAhead = this.sourceText[keyMatchEnd];
              if (keyMatchEnd < this.sourceText.length && __indexOf.call(LibroIpsum.ignoredCharacters, lookAhead) < 0) {
                this.frequencyLib.add(key, lookAhead);
              }
            }
          }
        }
        if (!this.frequencyLib.getFrequencies(key)) {
          return null;
        }
        return this.frequencyLib.randomUniformChoose(key);
      };

      return LibroIpsum;

    })();
    MultiSet = (function() {

      function MultiSet(initialItem) {
        this.cardinality = 0;
        this.multiSetRep = {};
        if (initialItem) {
          this.add(initialChar);
        }
      }

      MultiSet.prototype.getCardinality = function() {
        return this.cardinality;
      };

      MultiSet.prototype.getElementCount = function(target) {
        return this.multiSetRep[target] || 0;
      };

      MultiSet.prototype.getElementSet = function() {
        return Object.keys(this.multiSetRep);
      };

      MultiSet.prototype.add = function(item) {
        if (!(item in this.multiSetRep)) {
          this.multiSetRep[item] = 0;
        }
        this.multiSetRep[item]++;
        return this.cardinality++;
      };

      MultiSet.prototype.remove = function(target) {
        if (!(target in this.multiSetRep)) {
          return false;
        }
        this.multiSetRep[target]--;
        if (this.multiSetRep[target] === 0) {
          delete this.multiSetRep[target];
        }
        return this.cardinality--;
      };

      MultiSet.prototype.randomUniformChoose = function() {
        var choice, key, keyCount, _ref;
        choice = Math.floor(Math.random() * this.cardinality);
        _ref = this.multiSetRep;
        for (key in _ref) {
          keyCount = _ref[key];
          choice -= keyCount;
          if (choice < 0) {
            return key;
          }
        }
      };

      return MultiSet;

    })();
    FrequencyLibrary = (function() {

      function FrequencyLibrary() {
        this.freqLibRep = {};
      }

      FrequencyLibrary.prototype.size = function() {
        return Object.keys(this.freqLibRep).length;
      };

      FrequencyLibrary.prototype.contains = function(target) {
        return target in this.freqLibRep;
      };

      FrequencyLibrary.prototype.getFrequencies = function(target) {
        return this.freqLibRep[target];
      };

      FrequencyLibrary.prototype.add = function(name, element) {
        var ms;
        ms = this.getFrequencies(name);
        if (ms == null) {
          ms = this.freqLibRep[name] = new MultiSet;
        }
        return ms.add(element);
      };

      FrequencyLibrary.prototype.remove = function(name, element) {
        var cardAfter, cardBefore, ms;
        if (!this.contains(target)) {
          return false;
        }
        ms = this.getFrequencies(name);
        cardBefore = ms.getCardinality();
        ms.remove(element);
        cardAfter = ms.getCardinality();
        if (ms.getCardinality() === 0) {
          freqLibRep.remove(name);
        }
        return cardBefore - cardAfter === 1;
      };

      FrequencyLibrary.prototype.randomUniformChoose = function(name) {
        var ms;
        ms = this.getFrequencies(name);
        if (ms == null) {
          return 0;
        }
        return ms.randomUniformChoose();
      };

      return FrequencyLibrary;

    })();
    if ((_ref = Object.keys) == null) {
      Object.keys = function(obj) {
        var key, _results;
        _results = [];
        for (key in obj) {
          if (obj.hasOwnProperty(key)) {
            _results.push(key);
          }
        }
        return _results;
      };
    }
    this.LibroIpsum = LibroIpsum;
    if ((typeof module !== "undefined" && module !== null ? module.exports : void 0) != null) {
      module.exports = LibroIpsum;
    }
    if (typeof define === 'function' && (define.amd != null)) {
      return define('LibroIpsum', function() {
        return LibroIpsum;
      });
    }
  })();

}).call(this);
