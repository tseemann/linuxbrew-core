class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs/archive/0.8.2.tar.gz"
  sha256 "831c013bb8a5b32e21dca0e2503cf770dcd3c0c4ed9264769d0ab101707829ca"
  head "https://github.com/netheril96/securefs.git"

  bottle do
    cellar :any
    sha256 "d851b6a0987ac11b3ff5a6ede8b88bfa9e09251ef1fdd76237ad7e9910688242" => :high_sierra
    sha256 "13d67e18b133621ddb49ddc5b34caff453aec85d95607d2ab83f03cdf0c79b76" => :sierra
    sha256 "f42c0d8e15ddcd2212235b4954e8ce0896e8f3fc1f07c388cfcf49dca96888f3" => :el_capitan
    sha256 "a39c8bb5e026edb3edf556c154d622ed6d3da7e64c8a497e45ba119d5f0680f4" => :x86_64_linux
  end

  depends_on "cmake" => :build
  if OS.mac?
    depends_on :osxfuse
  else
    depends_on "libfuse"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/securefs", "version" # The sandbox prevents a more thorough test
  end
end
