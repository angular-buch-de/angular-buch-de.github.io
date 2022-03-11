docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  --publish 4000:4000 \
  --publish 35729:35729 \
  jekyll/jekyll \
  jekyll serve --livereload --livereload-port 35729
