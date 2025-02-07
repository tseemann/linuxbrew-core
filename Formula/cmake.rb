class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.16.4/cmake-3.16.4.tar.gz"
  sha256 "9bcc8c114d9da603af9512083ed7d4a39911d16105466beba165ba8fe939ac2c"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2133296c86e3b92305d34eb181a87d7b9c17a43b233264bdd02611afa2a856c" => :catalina
    sha256 "965268f016649761ce795b8fe9998cfe3929d849bfd1789e4e6e4862f6e43366" => :mojave
    sha256 "b94c0d7e2290ce04306f2a0754c68347d5b2e87121405751658f0c441a30c087" => :high_sierra
    sha256 "8c65268c6cb3cc80149c76f6b60f177e918cb528b52fe157e5f0da2d8b643fdc" => :x86_64_linux
  end

  depends_on "sphinx-doc" => :build
  depends_on "openssl@1.1" unless OS.mac?

  depends_on "ncurses"

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew cask install cmake`.

  def install
    ENV.cxx11 unless OS.mac?

    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
      --sphinx-html
      --sphinx-man
      --system-zlib
      --system-bzip2
      --system-curl
    ]
    args -= ["--system-zlib", "--system-bzip2", "--system-curl"] unless OS.mac?

    # There is an existing issue around macOS & Python locale setting
    # See https://bugs.python.org/issue18378#msg215215 for explanation
    ENV["LC_ALL"] = "en_US.UTF-8"

    system "./bootstrap", *args, "--", "-DCMAKE_BUILD_TYPE=Release"
    system "make"
    system "make", "install"

    elisp.install "Auxiliary/cmake-mode.el"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
