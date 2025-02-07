class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.12.21.tar.gz"
  sha256 "313f1fd527d9c2688c895e31be6cb43d817e01b4cf38511a413b26f4a602f44e"
  head "https://github.com/hashicorp/terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a87e29f9418b49edc7a70a30f29e569dd3dbb7c259304b87db48cf556b0efbd" => :catalina
    sha256 "dcf535db420f75c478d616be09da733a0ebedbbdbb1a35853acfbe3c3568ff18" => :mojave
    sha256 "1e6a06b503baf84d70ba84a03609ee100e0fc2065853c8d211215b1fe27f9dd3" => :high_sierra
    sha256 "8c1920481bbcdf163e49762c5de0ee1c1bdfce8ac77e6931ca4d7f26964c8039" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  conflicts_with "tfenv", :because => "tfenv symlinks terraform binaries"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on" unless OS.mac?
    ENV.prepend_create_path "PATH", buildpath/"bin"

    dir = buildpath/"src/github.com/hashicorp/terraform"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # v0.6.12 - source contains tests which fail if these environment variables are set locally.
      ENV.delete "AWS_ACCESS_KEY"
      ENV.delete "AWS_SECRET_KEY"

      os = OS.mac? ? "darwin" : "linux"
      ENV["XC_OS"] = os
      ENV["XC_ARCH"] = "amd64"
      system "make", "tools", "bin"

      bin.install "pkg/#{os}_amd64/terraform"
      prefix.install_metafiles
    end
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<~EOS
      variable "aws_region" {
        default = "us-west-2"
      }

      variable "aws_amis" {
        default = {
          eu-west-1 = "ami-b1cf19c6"
          us-east-1 = "ami-de7ab6b6"
          us-west-1 = "ami-3f75767a"
          us-west-2 = "ami-21f78e11"
        }
      }

      # Specify the provider and access details
      provider "aws" {
        access_key = "this_is_a_fake_access"
        secret_key = "this_is_a_fake_secret"
        region     = var.aws_region
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami           = var.aws_amis[var.aws_region]
        count         = 4
      }
    EOS
    system "#{bin}/terraform", "init"
    system "#{bin}/terraform", "graph"
  end
end
