class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.33.tar.gz"
  sha256 "2d7efab31005cb7f120aebb2b81f88628947a04e55f1a35d368a1c88cface285"

  bottle do
    cellar :any_skip_relocation
    sha256 "af7018868ee72bd1b32e538f4a5d426ce3c45b280d577b90cc5de699e25186e0" => :catalina
    sha256 "0ad7f582f4f4b8babf6e1d8520747ef6d919ffbf6be89b4d8f3453f66092aff2" => :mojave
    sha256 "9d368f4a8de5e455cd984e27baa030698a26ec1f53485933e668223ffe81d1b5" => :high_sierra
    sha256 "82cb8a0787597a5f36546accab316785003e628bcb96f6ed6cea6b9f32726885" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "off"
    ENV["GOPATH"] = buildpath
    ENV["PATH"] = "#{ENV["PATH"]}:#{buildpath}/bin"
    (buildpath/"src/github.com/aliyun/aliyun-cli").install buildpath.children
    cd "src/github.com/aliyun/aliyun-cli" do
      system "make", "metas"
      system "go", "build", "-o", bin/"aliyun", "-ldflags", "-X 'github.com/aliyun/aliyun-cli/cli.Version=#{version}'", "main/main.go"
      prefix.install_metafiles
    end
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
