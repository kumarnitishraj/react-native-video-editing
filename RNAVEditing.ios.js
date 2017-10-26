/**
 * @providesModule RNAVEditing
 * @flow
 */
'use strict';

var NativeRNAVEditing = require('NativeModules').RNAVEditing;

/**
 * High-level docs for the RNAVEditing iOS API can be written here.
 */

var RNAVEditing = {
  test: function() {
    NativeRNAVEditing.test();
  }
};

module.exports = RNAVEditing;
