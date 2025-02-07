class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  url "https://www.pjsip.org/release/2.9/pjproject-2.9.tar.bz2"
  sha256 "d185ef7855c8ec07191dde92f54b65a7a4b7a6f7bf8c46f7af35ceeb1da2a636"
  revision 1
  head "https://svn.pjsip.org/repos/pjproject/trunk"

  bottle do
    cellar :any
    sha256 "784718544f0553b52ffa60aa895d405a95401112164c72962242f4b801b168c4" => :catalina
    sha256 "ea18f1105154234f2c89b17d5973fd96c4821910a3e902a70d79ba219b655a4b" => :mojave
    sha256 "05291521fbceb75e3abf7a0c185cce9c491a00afde019a52ccbbc4b91a38710c" => :high_sierra
    sha256 "5d45094d142f489dc1792c5e5c19e789ac1bfd11264e4e3726ce287080e2c3d2" => :x86_64_linux
  end

  depends_on :macos => :high_sierra # Uses Security framework API enum cases introduced in 10.13.4
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "dep"
    system "make"
    system "make", "install"

    arch = Utils.popen_read("uname -m").chomp
    if OS.mac?
      rel = Utils.popen_read("uname -r").chomp
      bin.install "pjsip-apps/bin/pjsua-#{arch}-apple-darwin#{rel}" => "pjsua"
    else
      bin.install "pjsip-apps/bin/pjsua-#{arch}-unknown-linux-gnu" => "pjsua"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pjsua --version 2>&1")
  end
end
