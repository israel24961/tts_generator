#!/bin/sh
#f="https://www.creepypasta.com/the-secrets-of-mr-thomas/"
# f="https://www.creepypasta.com/when-the-siren-came/"
f="$1"
cd "$(dirname "$0")" || exit 1
rm -rfd example_*.wav
curl -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8' -H 'accept-language: en-US,en;q=0.6' -s "$f" -o ./example.html

awk -f ./2_awkcmd.awk ./example.html |recode html| sed -e 's/<[^>]*>//g'  > example.txt
#perl -i.bak -pe 's/[^[:ascii:]]//g' example.txt
#-e 's/\./\n/g'

# handle line breaks properly; needed when a line has spaces or tabs
tifs="$IFS"
fn=0
IFS=$(printf '\n.');
IFS=${IFS%.};
for i in $(cat example.txt)
do
  tts --text "$i" --model_name "tts_models/en/ljspeech/glow-tts" --vocoder_name "vocoder_models/en/ljspeech/univnet" --out_path example_$fn.wav ;
  fn=$((fn+1));
done;
IFS="$tifs";
find . -name "example_*.wav" | sort -V | xargs basename -a | awk '{print "file " $0}' > list.txt;
ffmpeg -f concat -safe 0 -i list.txt -c copy output.wav
