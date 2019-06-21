# Audio-pattern-extractor-generator

Audio Patter Extractor-Generator in Python

Our aim is to interpret an audio file by another audio file.

We take a wav file and split it into slices (determined by either the bpm or onsets). Then we apply k-means to cluster the slices.
We take another wav file, split it and cluster its slices according to the clusters defined by the previous step. 
Then we generate a sequence of slices from the second audio file that mimic the sequence of the slices of the first audio file.
This new audio can be exported as a wav file in the Jupyter Notebook or played in the Supercollider program.
