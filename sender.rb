require 'eventmachine'
require 'em-hiredis'
require 'lzma'

EventMachine::run do
  @pub = EM::Hiredis.connect("redis://localhost:6379")

  @timer = EventMachine::PeriodicTimer.new(5) do
    puts "Sending message"
    message = "
ExploreGistBlogHelpeerwitt
344
Watch42 Fork6
PUBLIC nmrugg / LZMA-JS

Code
Network
Pull Requests 0
Issues 1
Wiki
Graphs
JavaScript
A standalone JavaScript implementation of the Lempel-Ziv-Markov chain (LZMA) compression algorithm — Read more
http://nmrugg.github.com/LZMA-JS/
ZIP
HTTP
Git Read-Only
Read-Only access
Tags  Downloads
branch: master
Files Commits Branches 3
 Latest commit to the master branch
Updated npm package.
commit 471adb4cc8
 nmrugg authored 2 months ago
LZMA-JS /
name  age history message
demos a year ago  Added npm package and fixed a few minor issues. [nmrugg]
src 2 months ago  Updated npm package. [nmrugg]
test  2 months ago  Added new test file. [nmrugg]
LICENSE 10 months ago Minor update to the readme and license. [nmrugg]
readme.md 5 months ago  Updated readme. [nmrugg]
 readme.md
LZMA in a Browser
LZMA.JS is a JavaScript implementation of the Lempel-Ziv-Markov chain (LZMA) compression algorithm. The JavaScript, CSS, and HTML is licensed under the MIT license. See LICENSE for more details.

It is based on gwt-lzma, which is a port of the LZMA SDK from Java into JavaScript. The original Java code is licensed under the Apache License 2.0 license.

Live demos can be found here.

How to Use
First, load the bootstrapping code.

/// In a browser:
<script src=../src/lzma.js></script>

/// In node:
var LZMA = require(../src/lzma.js).LZMA;
Create the LZMA object.

/// LZMA([optional path])
/// If lzma_worker.js is in the same directory, you don't need to set the path.
/// You should be able to do the first two steps simultaneously in Node.js: var my_lzma = require(../src/lzma.js).LZMA();
var my_lzma = new LZMA(../src/lzma_worker.js);
(De)Compress stuff.

/// To compress:
///NOTE: mode can be 1-9 (1 is fast but not as good; 9 will probably make your browser crash).
my_lzma.compress(string, mode, on_finish(result) {}, on_progress(percent) {});

/// To decompress:
my_lzma.decompress(byte_array, on_finish(result) {}, on_progress(percent) {});
Node.js Installation
LZMA.JS is available in the npm repository. If you have npm installed, you can install it by running

$ npm install lzma
and load it with the following code:

var my_lzma = require(lzma).LZMA();
Notes
The calls to compress() and decompress() are asynchronous, so you need to supply a callback function if you want to use the (de)compressed data. There was a synchronous version, which you can find in the archives, but it is no longer maintained.

LZMA.JS will use web workers if they are available. If the environment does not support web workers, it will create a few global functions (Worker(), onmessage(), and postMessage()) to mimic the functionality.


GitHub Links
GitHub
About
Blog
Features
Contact & Support
Training
GitHub Enterprise
Site Status
Clients
GitHub for Mac
GitHub for Windows
GitHub for Eclipse
GitHub Mobile Apps
Tools
Gauges: Web analytics
Speaker Deck: Presentations
Gist: Code snippets
Extras
Job Board
GitHub Shop
The Octodex
Documentation
GitHub Help
Developer API
GitHub Flavored Markdown
GitHub Pages
Terms of ServicePrivacySecurity© 2012 GitHub Inc. All rights reserved. "
    @pub.publish("test", LZMA.compress(message))
  end

  trap('INT') do
    STDERR.puts "Caught INT signal cleaning up"
    @timer.cancel
    @pub.close_connection
    EventMachine::stop_event_loop
  end
end
