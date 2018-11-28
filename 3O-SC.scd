/*
Before doing anything, make sure you have installed:

- Jack
- Reaper
- IEM Plug-in suite (both VST and SC)
*/

// 1. Boot the Jack server

(
// 2. Some initial settings to make sure SC is behaving as it should.
Server.killAll;

s.options.device = "JackRouter";
s.options.numOutputBusChannels = 16;
s.latency = 0.5
)


(
// 3. Boot the server and load the SynthDef
s.waitForBoot({
	SynthDef(\saw3O, {|freq=440, gate=1, azi=0, elev=0|
		var sig, env;

		env = EnvGen.kr(Env.asr, gate, doneAction:2);

		sig = Saw.ar(freq, 0.2);

		// PanAmbi3O is a 3rd order ambisonics encoder, where you can specify and modulate azimuth and elevation. Takes mono input.
		sig = PanAmbi3O.ar(sig, azi, elev) * env;

		Out.ar(0,sig)
	}).add;
})
)

(
// 4. Sequencing events
Pbind(
	\instrument, \saw3O,
	\degree, Prand((0..7),inf),
	\azi, Pwhite(-pi,pi),
	\elev, Pwhite(-pi,pi),
	\dur, 0.5
).play
)
