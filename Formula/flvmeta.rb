class Flvmeta < Formula
  desc "Manipulate Adobe flash video files (FLV)"
  homepage "https://www.flvmeta.com/"
  url "https://www.flvmeta.com/download.php?file=flvmeta-1.2.1.tar.gz"
  sha256 "4b48afc2db8b0ff1c86861bc09a58481bc241d93b879b6f915fbf695fc4bff51"
  head "https://github.com/noirotm/flvmeta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0e6ac7e5c8daaf6b707656e97fc95e86b5c73a4f27dda58bb82bc973666892b" => :catalina
    sha256 "67e0f288fe10e2446cdb9bbbc2991256c69cf9622aba58d6c153b37308744d29" => :mojave
    sha256 "378420e627f64559bc36e9b80645b6aa4628e09823e408817e05a7cbfb202f2c" => :high_sierra
    sha256 "2413315dd7ef5bc4e3cde1710d8d54a5b8481c655e3097d7fa3cebd74aae1dfb" => :sierra
    sha256 "e38ef52c18acdf32d1a61e2604220eeff05b3ca1eb8ca8b215f20371b7b09f37" => :el_capitan
    sha256 "54e7dc4be603332324c5a0833fa03b982c315696b07321295886d1bc3232448f" => :yosemite
    sha256 "d50606001ee39c8fed3f928b38652e437fd3b8bb1fa97306114b93088fc98b0b" => :mavericks
    sha256 "6f91f86a1199767b4e5e10591508f38a363f563c97d62ed2b7f955c6170bc80b" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"flvmeta", "-V"
  end
end
