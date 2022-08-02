# ReplayGain Scan Utility

## Introduction

The [ReplayGain](https://en.wikipedia.org/wiki/ReplayGain) standard describes a mechanism to measure and play music at a normalised volume level.

**ReplayGain Scan** will add tags to music files for playback at a reference loudness. These tags may be interpreted by the playback system to make albums sound roughly the same loudness. If a playback system doesn't support the tags, or if it is configured to ignore the tags, there will be no change in playback volume or quality.

I wrote this for playback using [Logitech Media Server](https://en.wikipedia.org/wiki/Logitech_Media_Server).

It runs on **macOS**. It has been tested on **macOS Monterey** 12.4, and is a 64-bit Intel app which runs on Apple Silicon using Rosetta.

During scanning, the audio (waveform) data is not changed, but the **music files are changed** to add the tags. Every track processed will have a track gain stored. Albums of tracks will have a common album gain stored.

On macOS, the excellent [Colibri](https://colibri-lossless.com) music player supports ReplayGain tags. On Windows, [foobar2000](http://www.foobar2000.org/) supports ReplayGain tags. I'm sure there are many others.

**FILES WILL BE MODIFIED. Back up your music first.**


## Running the App

The **ReplayGain Scan** app is not signed, and **macOS** will complain that it is from an unidentified developer. You can bypass this warning with the following procedure.

1. Right-click on the **ReplayGain Scan** app icon.
2. Click on the "Open" menu option.
3. A warning dialog will appear; click on the "Open" button.

This is a one-time procedure for each of the variants of the app.


## Usage

Drag folders or files onto the ReplayGain Scan icon (or window).

The music files dropped are treated as an album.

The music files directly in each folder are treated as an album, irrespective of their tags.

Folders are scanned for sub-folders, whose contents are treated as an album.

There are two versions provided:

- **‌ReplayGain Scan** will scan only those files (albums) which do not have complete and consistent album gain tags.
- **‌ReplayGain Full Rescan** will scan all files and replace any existing gain tags.

(Ideally this difference would be governed by a preference, but the tools used to build the application don't easily support such an approach.)

The progress window will display information about which directories are scanned and the computed gain values. Errors and warnings will be displayed.

**Remember: FILES WILL BE MODIFIED. Back up your music first.**


## Notes

Files with Extensions of flac, m4a, mp3 (any mix of upper and lower case) are scanned.

Lossless AAC files are not supported. Perhaps convert them to FLAC and process those files.

iTunes does not support ReplayGain. It has its own feature called SoundCheck which has a similar intent to track gain (but there is no apparent album gain mechanism).


## History

Version 0.4, 2 August 2022
- Updated icon for BigSur and Monterey.
- Readme is markdown.
- Moved to GitHub.

Version 0.3, 15 February 2020
- 64-bit app, should now work with macOS 10.15 Catalina.
- Updated icon.

Version 0.2, 17 January 2018
- Updated metaflac to 1.3.2, enabling support for higher sample and bitrates.
- New icon.

Version 0.1, 29 June 2011
- Initial release.


## License

ReplayGain Scan is Copyright 2011–2022 Martin Scott.

ReplayGain Scan is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.


## Acknowledgements

The original ReplayGain proposal is by David Robinson.

ReplayGain Scan was build using [Platypus](https://sveinbjorn.org/platypus) by Sveinbjorn Thordarson.

Original scripting inspiration was from [work by Bobulous](http://www.bobulous.org.uk/misc/Replay-Gain-in-Linux.html).

FLAC scanning uses [metaflac](https://xiph.org/flac/), using the static build from [xACT 2.50](http://xact.scottcbrown.org).

AAC and MP3 scanning uses [aacgain](http://altosdesign.com/aacgain/) (my build), derived from [mp3gain](http://mp3gain.sourceforge.net/).