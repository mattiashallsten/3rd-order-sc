# 3rd order ambisonics using SuperCollider, Jack and Reaper

## Requirements

- [SuperCollider](https://supercollider.github.io/download)
- [Reaper](https://www.reaper.fm/download.php)
- [Jack](http://www.jackosx.com/download.html)
- [IEM Plug-in suite](https://plugins.iem.at/download/)
- ambiIEM Quark for SuperCollider

## Setup

1. Start JackPilot, the number of virtual channels equals 16 or higher (if you have more loudspeakers than 16, the number of virtual channels should equal the number of speakers)
2. Start SuperCollider, open `3O-SC.scd` and execute the code blocks in order.
3. Start Reaper, open `decoder.rpp` and make sure the channel named "Binaural" is record enabled.
4. Route the outputs of scsynth in JackPilot to the inputs of Reaper via Jack.
5. Route the outputs of Reaper to the System via Jack.

## Jack

I've included a Jack installer for OSX, out of convenience. I can't seem to find it onlin, but it was included in a Faust package I had on my laptop.
