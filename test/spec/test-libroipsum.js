(function() {
  var sourceText;

  sourceText = {
    long: 'The third birds of which they made off. To them, a bird\'s offer was often managed. Thus, it was.',
    single: 'The'
  };

  describe('LibroIpsum', function() {
    var acceptableRandomVariance;
    acceptableRandomVariance = 0.10;
    describe('#generate()', function() {
      it('should generate the correct number of words', function() {
        var genText, keyLength, li, numWords, _i, _results;
        li = new LibroIpsum(sourceText.long);
        _results = [];
        for (keyLength = _i = 3; _i <= 7; keyLength = ++_i) {
          _results.push((function() {
            var _j, _results1;
            _results1 = [];
            for (numWords = _j = 1; _j <= 6; numWords = ++_j) {
              genText = li.generate(numWords, keyLength);
              _results1.push(expect(genText.split(' ').length).to.be(numWords));
            }
            return _results1;
          })());
        }
        return _results;
      });
      it('should have a cleanly formatted ending', function() {
        var genText, isClean, li;
        li = new LibroIpsum(sourceText.long);
        genText = li.generate(10);
        isClean = new RegExp("[^\\s\\\\" + (LibroIpsum.clauseSeparators.join('\\\\')) + "]+\\.$").test(genText);
        return expect(isClean).to.be.ok();
      });
      return it('should gracefully handle end of text', function() {
        var expected, genText, li;
        li = new LibroIpsum(sourceText.single);
        expected = 'The The The.';
        genText = li.generate(3, 3);
        return expect(genText).to.be(expected);
      });
    });
    describe('#getKey()', function() {
      var li;
      li = new LibroIpsum(sourceText.long);
      it('should choose keys from start of text or sentences', function() {
        var i, key, starters, _i, _results;
        starters = ['The', 'To ', 'Thu'];
        _results = [];
        for (i = _i = 0; _i <= 10; i = ++_i) {
          key = li.getKey(3);
          _results.push(expect(starters).to.contain(key));
        }
        return _results;
      });
      it("should choose keys with acceptable randomness (<" + (acceptableRandomVariance * 100) + "% variance)", function() {
        var avg, i, iter, k, keys, sum, val, variance, _i, _results;
        keys = {
          'The': 0,
          'To ': 0,
          'Thu': 0
        };
        iter = 1500;
        for (i = _i = 1; 1 <= iter ? _i <= iter : _i >= iter; i = 1 <= iter ? ++_i : --_i) {
          keys[li.getKey(3)]++;
        }
        sum = 0;
        for (k in keys) {
          val = keys[k];
          sum += val;
        }
        expect(sum).to.equal(iter);
        avg = sum / Object.keys(keys).length;
        _results = [];
        for (k in keys) {
          val = keys[k];
          variance = Math.abs((val - avg) / val);
          _results.push(expect(variance).to.be.lessThan(acceptableRandomVariance));
        }
        return _results;
      });
      return it('should choose keys of correct length', function() {
        var key, len, _i, _results;
        _results = [];
        for (len = _i = 0; _i <= 10; len = ++_i) {
          key = li.getKey(len);
          _results.push(expect(key.length).to.equal(len));
        }
        return _results;
      });
    });
    return describe('#getDistributedChar', function() {
      var li;
      li = new LibroIpsum(sourceText.long);
      return it("should choose characters with acceptable randomness (<" + (acceptableRandomVariance * 100) + "% variance)", function() {
        var avg, i, iter, k, key, options, sum, val, variance, _i, _results;
        key = 'ird';
        iter = 1500;
        options = {
          ' ': 0,
          's': 0,
          '\'': 0
        };
        for (i = _i = 1; 1 <= iter ? _i <= iter : _i >= iter; i = 1 <= iter ? ++_i : --_i) {
          options[li.getDistributedChar(key)]++;
        }
        sum = 0;
        for (k in options) {
          val = options[k];
          sum += val;
        }
        expect(sum).to.equal(iter);
        avg = sum / Object.keys(options).length;
        _results = [];
        for (k in options) {
          val = options[k];
          variance = Math.abs((val - avg) / val);
          _results.push(expect(variance).to.be.lessThan(acceptableRandomVariance));
        }
        return _results;
      });
    });
  });

}).call(this);
