#!/bin/bash

set -e

# Keep in sync with elixir_buildpack.config (heroku config)
#export ERLANG_VERSION="18.0" # set by Codeship
#export ELIXIR_VERSION="v1.0.5" # set by Codeship
#export LIBGIT2_VERSION="v0.22.1" # set by Codeship
export INSTALL_PATH="$HOME/cache"

export ERLANG_PATH="$INSTALL_PATH/otp_src_$ERLANG_VERSION"
export ELIXIR_PATH="$INSTALL_PATH/elixir_$ELIXIR_VERSION"

mkdir -p $INSTALL_PATH
cd $INSTALL_PATH

# Install erlang
if [ ! -e $ERLANG_PATH/bin/erl ]; then
  curl -O http://www.erlang.org/download/otp_src_$ERLANG_VERSION.tar.gz
  tar xzf otp_src_$ERLANG_VERSION.tar.gz
  cd $ERLANG_PATH
  ./configure --enable-smp-support \
              --enable-m64-build \
              --disable-native-libs \
              --disable-sctp \
              --enable-threads \
              --enable-kernel-poll \
              --disable-hipe \
              --without-javac
  make

  # Symlink to make it easier to setup PATH to run tests
  ln -sf $ERLANG_PATH $INSTALL_PATH/erlang
fi

# Install elixir
export PATH="$ERLANG_PATH/bin:$PATH"

if [ ! -e $ELIXIR_PATH/bin/elixir ]; then
  git clone https://github.com/elixir-lang/elixir $ELIXIR_PATH
  cd $ELIXIR_PATH
  git checkout $ELIXIR_VERSION
  make

  # Symlink to make it easier to setup PATH to run tests
  ln -sf $ELIXIR_PATH $INSTALL_PATH/elixir
fi

export PATH="$ELIXIR_PATH/bin:$PATH"

# Install other dependencies
if [ ! -d "$INSTALL_PATH/libgit2" ]; then
  rm -fr "$INSTALL_PATH/_build_libgit2" 2>/dev/null || [ 1 -eq 1 ]
  mkdir -p "$INSTALL_PATH/_build_libgit2"
  cd "$INSTALL_PATH/_build_libgit2"
  rm "$LIBGIT2_VERSION.tar.gz" 2>/dev/null || [ 1 -eq 1 ]
  wget "https://github.com/libgit2/libgit2/archive/$LIBGIT2_VERSION.tar.gz"
  tar -xzf "$LIBGIT2_VERSION.tar.gz"
  mv libgit2-*/* .
  mkdir build && cd build
  cmake ..
  cmake --build .
  mkdir -p "$INSTALL_PATH/libgit2"
  cmake .. -DCMAKE_INSTALL_PREFIX="$INSTALL_PATH/libgit2"
  cmake --build . --target install
fi
