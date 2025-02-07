class Sqliteodbc < Formula
  desc "SQLite ODBC driver"
  homepage "https://ch-werner.homepage.t-online.de/sqliteodbc/"
  url "https://ch-werner.homepage.t-online.de/sqliteodbc/sqliteodbc-0.9996.tar.gz"
  sha256 "8afbc9e0826d4ff07257d7881108206ce31b5f719762cbdb4f68201b60b0cb4e"
  revision 1 unless OS.mac?

  bottle do
    cellar :any
    rebuild 1
    sha256 "d39f27293fed805c898f3967de7f02b7a77a4fa5a0c88546b91ab42eb03c63f4" => :catalina
    sha256 "a49afbd00eb6230ecf0a0a4573c961fe697ab6326998f2a894348d8509dc1c0d" => :mojave
    sha256 "6afd81a210f7a0f7b70e70d4d5b89a659c4cf2c9916d85ff65d89ef042bdba52" => :high_sierra
    sha256 "73755a497df2713b8f3cc9cd0f19df24aaab01f33bf001be3718c5f8318c784c" => :sierra
    sha256 "1b34e2dc2a7fb806b0102f34e0128285f8f5842159b9ecb99dee8efa13ef1155" => :x86_64_linux
  end

  depends_on "sqlite"
  depends_on "unixodbc"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    unless OS.mac?
      # sqliteodbc ships its own version of libtool, which breaks superenv.
      # Therefore, we set the following enviroment to help it find superenv.
      ENV["CC"] = which("cc")
      ENV["CXX"] = which("cxx")
    end
    lib.mkdir
    args = ["--prefix=#{prefix}", "--with-odbc=#{Formula["unixodbc"].opt_prefix}"]
    unless OS.mac?
      args += ["--with-sqlite3=#{Formula["sqlite"].opt_prefix}",
               "--with-libxml2=#{Formula["libxml2"].opt_prefix}"]
    end

    if OS.mac?
      ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra
    end
    system "./configure", *args

    system "make"
    system "make", "install"
    lib.install_symlink "#{lib}/libsqlite3odbc.dylib" => "libsqlite3odbc.so" if OS.mac?
  end

  test do
    output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/libsqlite3odbc.so")
    assert_equal "SUCCESS: Loaded #{lib}/libsqlite3odbc.so\n", output
  end
end
