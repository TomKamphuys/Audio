# Audio
Collection of scripts for audio purposes. It uses code from other people and combines that into a speaker measurement toolkit. It assumes a rotation device 

## Prerequisites

Choose a directory where you want to install MATAA, NTKSPH and this code. Go to that directory.

### MATAA
Clone MATAA from https://github.com/mbrennwa/mataa/tree/master

    git clone https://github.com/mbrennwa/mataa.git

### NTKSPH
Clone NTKSPH from https://github.com/TomKamphuys/NTKSPH

    git clone https://github.com/TomKamphuys/NTKSPH.git

### Audio (this code)
Clone Audio from https://github.com/TomKamphuys/Audio

    https://github.com/TomKamphuys/Audio.git

## Starting...
Open Octave/MATLAB. Add mataa and subdirs to the path. Go to the Audio directory and run 'init'.

You probably need to change init.m to your needs.

## Configuring
Change read_config.m to your liking.

## Measuring
Set the speaker in the 'zero' position.

Run

    angular_measurement

A new directory will be made with several output file. The directory is Measurements/SOMEDATESTRING

The speaker will first be rotated to a small negative angle and then move back to zero. A sound will be played and recorded and the speaker will move to its next position. Multiple measurements will be taken

At the end, the speaker is rotated back to 'zero'         
