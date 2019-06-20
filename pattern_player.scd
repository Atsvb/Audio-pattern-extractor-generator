/*
This program takes a wav file, slice it and plays the slices in a sequence determined by a clustering alorithm implemented in Python.
*/

//First we load the wav file in a buffer
~path = thisProcess.nowExecutingPath.dirname +/+"/data/LPDrums.wav";
~buf = Buffer.read(s, ~path )

//We import the array of  starting samples of the file slices. This was exported to a csv file by the Python algorithm
~path = thisProcess.nowExecutingPath.dirname +/+"/data/LPsamples.csv";
x = CSVFileReader.read(~path, true).postcs;
~sample_array=collect((x.size), {|n| x[n][0].interpret});

//Now we compute the size of the slices and convert them to seconds.
~steps=~sample_array.differentiate
~steps=~steps[1..]
~times=~steps/44100

//We import the array of the order in which the slices are going to be played.
~path = thisProcess.nowExecutingPath.dirname +/+"/data/LPbeats.csv";
b = CSVFileReader.read(~path, true).postcs;
~beats_array=collect((b.size), {|n| b[n][0].interpret});
~beats_array
~sample_array[~beats_array]

//This synth plays the buffer
(
SynthDef(\bufferplayer, { |out, bufnum, start, time, amp=1|
    var    sig = PlayBuf.ar(1, bufnum, startPos: start, loop: 0),
        env = EnvGen.kr(Env.linen(0.01, time, 0.05, level: amp), doneAction: Done.freeSelf);
    Out.ar(out, (sig * env) ! 2)
}).add;
)

//This Pbind plays the slices in the order wanted.
(
~pb=Pbind(
	\instrument, \bufferplayer,
	\bufnum, ~buf.bufnum,
	\amp,1,
	//\startPos, Pwhite(0,~buf.numFrames,inf),
    \start, Pseq(~sample_array[~beats_array],1),
	\time, Pseq(~times[~beats_array], 1),
	//\start, Pseq(~frames),
	\pan, 0,
	//\pan, Pseries(0,0.5,inf),
	\dur, Pseq(~times[~beats_array], 1),
	//\dur, 1,
	//(''),
).play;
)

