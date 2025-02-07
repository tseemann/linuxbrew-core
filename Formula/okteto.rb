class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.7.2.tar.gz"
  sha256 "d7d439d5c1d6ffd396458b82fe31b0c464430a1b2bd7ca1bda727057c90cf572"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0b2d5b1956ed905962efc8b388ef092f42bdfa58525c6db99e3f0e6763195d8" => :catalina
    sha256 "f0dc0e2df67358d66ea9597df0ced9c25d9a8b4cce510300ec41b9c7564c9d8e" => :mojave
    sha256 "18c2dee567d44558124c4303f570fe5e068b9d728fbb208f180686db170208a5" => :high_sierra
    sha256 "bd06e508a9c113902e255509fc542f551134e879e1ca756418997034a254f96e" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", "-o", "#{bin}/#{name}", "-trimpath", "-ldflags", ldflags, "-tags", tags
  end

  test do
    touch "test.rb"
    system "echo | okteto init --overwrite --file test.yml"
    expected = <<~EOS
      name: #{Pathname.getwd.basename}
      image: okteto/ruby:2
      command:
      - bash
      workdir: /usr/src/app
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
