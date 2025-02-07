class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.16.1/mongo-c-driver-1.16.1.tar.gz"
  sha256 "ad479a6d3499038ec19ca80a30dfa99277644bb884e424362935b06e2d5f7988"
  head "https://github.com/mongodb/mongo-c-driver.git"

  bottle do
    cellar :any
    sha256 "aee2877a0585bc827c93de0dcaf60417b9d52b3074c0cea7a9040fbedc25f982" => :catalina
    sha256 "a08ee417be2fc5bc458fe5eaef9623ef1cbe7d7a075e164db4ff7a3f6f63f054" => :mojave
    sha256 "57c9b322d581ac1e96a599fabd13912812da387f2744a98a7f5121650e5b4150" => :high_sierra
    sha256 "046820b0c0d5ceeafe2cf0b08e0c2a3cba1ebd28b271634b2b1f8a2f92a15d94" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  unless OS.mac?
    depends_on "openssl@1.1"
    depends_on "zlib"
  end

  def install
    cmake_args = std_cmake_args
    if build.head?
      cmake_args << "-DBUILD_VERSION=1.17.0-pre"
    end
    system "cmake", ".", *cmake_args
    system "make", "install"
    (pkgshare/"libbson").install "src/libbson/examples"
    (pkgshare/"libmongoc").install "src/libmongoc/examples"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"libbson/examples/json-to-bson.c",
      "-I#{include}/libbson-1.0", "-L#{lib}", "-lbson-1.0"
    (testpath/"test.json").write('{"name": "test"}')
    assert_match "\u0000test\u0000", shell_output("./test test.json")

    system ENV.cc, "-o", "test", pkgshare/"libmongoc/examples/mongoc-ping.c",
      "-I#{include}/libmongoc-1.0", "-I#{include}/libbson-1.0",
      "-L#{lib}", "-lmongoc-1.0", "-lbson-1.0"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 3)
  end
end
