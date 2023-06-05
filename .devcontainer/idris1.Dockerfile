FROM mcr.microsoft.com/devcontainers/base:bullseye

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    make pkg-config cabal-install

RUN su vscode -c "cabal update && cabal install idris"

RUN git clone https://github.com/idris-lang/Idris-dev.git  /home/vscode/src/idris-lang/Idris-dev

RUN echo '#!/bin/bash\n\
if [ -t 1 ]; then\n\
  exec /home/vscode/.cabal/bin/idris "$@"\n\
fi\n\
\n\
ulimit -v 2000000\n\
while :; do\n\
  /home/vscode/.cabal/bin/idris "$@" | tee /tmp/idris.rkt\n\
done\n\
' >> /usr/local/bin/idris
RUN chmod +x /usr/local/bin/idris
