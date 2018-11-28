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
// 3. Boot the server and load the SynthDef's
s.waitForBoot({
	SynthDef(\saw3O, {|freq=440, gate=1, azi=0, elev=0|
		var sig, env;

		env = EnvGen.kr(Env.asr, gate, doneAction:2);

		sig = Saw.ar(freq, 0.2);

		// PanAmbi3O is a 3rd order ambisonics encoder, where you can specify and modulate azimuth and elevation. Takes mono input.
		sig = PanAmbi3O.ar(sig, azi, elev) * env;

		// Necessary re-routing.
		sig = [
			sig[0],
			sig[2],
			sig[3],
			sig[1],
			sig[5],
			sig[7],
			sig[8],
			sig[6],
			sig[4],
			sig[10],
			sig[12],
			sig[14],
			sig[15],
			sig[13],
			sig[11],
			sig[9]
		];

		Out.ar(0,sig)
	}).add;

	SynthDef(\stereoBuffer3O, {|buf=0, rate=1, azi=0, elev=0, width=0.2, gate=1|
		var sig, env, left, right;

		env = EnvGen.kr(Env.asr, gate, doneAction:2);

		#left, right = PlayBuf.ar(2, buf, rate, doneAction:2);

		// Encoding the left and right channels seperately, and offsetting the elevation according to the width argument.
		left = PanAmbi3O.ar(left, azi - (width * pi), elev);
		right = PanAmbi3O.ar(right, azi + (width * pi), elev);

		sig = Mix([left, right]);

		// Necessary re-routing.
		sig = [
			sig[0],
			sig[2],
			sig[3],
			sig[1],
			sig[5],
			sig[7],
			sig[8],
			sig[6],
			sig[4],
			sig[10],
			sig[12],
			sig[14],
			sig[15],
			sig[13],
			sig[11],
			sig[9]
		];

		Out.ar(0,sig)
	}).add
})
)

(
// 4. Sequencing events
Pbind(
	\instrument, \saw3O,
	\degree, Prand((0..7),inf),
	\azi, Pseq([-pi,-0.5pi,0,0.5pi],inf),
	\dur, 0.5
).play
)

(
// 5. Loading a stereobuffer and playing it back in ambisonics.
fork {
	var rain = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/rain.wav");

	s.sync;

	x = Synth(\stereoBuffer3O, [\buf, rain.bufnum, \azi, 0pi, \width, 0.5])
}
)
