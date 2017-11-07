npm ls | \
  grep ' [a-zA-Z\-\.@]*@' -o | \
  sed 's/@$//g' | \
  sort | \
  uniq | \
  awk '{ print $1 }' | \
  xargs -I{} npm view {} repository.url | \
  sed 's/git+//g' | \
  sed 's/https\|http/git/g' | \
  sed 's/git:\/\//ssh:\/\/git@/g' | \
  xargs -I{} git clone {}

ls | \
  grep -v 'package.json\|node_modules' | \
  xargs -I{} gource --output-custom-log {}.txt {}

ls | \
  grep -v 'package.json\|node_modules\|\.txt' | \
  xargs -I{} sed -i -r 's#(.+)\|#\1|/{}#' {}.txt

cat *.txt | \
  sort -n > viz.gource

gource viz.gource | \
  ffmpeg \
    -y \
    -r 30 \
    -f image2pipe \
    -vcodec ppm \
    -i \
    - \
    -vcodec libx264 \
    -preset ultrafast \
    -pix_fmt yuv420p \
    -crf 1 \
    -threads 0 \
    -bf 0 \
    gource.mp4
