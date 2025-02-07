require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.0.3.tgz"
  sha256 "8d7906bc2a5106b0bbd0e831688564a4bf07d3bcb3de0203cb093bd3b47a5108"

  bottle do
    cellar :any_skip_relocation
    sha256 "76468fde5e2592b5e32650fcb84448a4d6709d1c46be3976263dec53ba009d35" => :catalina
    sha256 "d0d5b02fb196458602ff95e5d218024f0866918691697384176430da08b9939b" => :mojave
    sha256 "b65cce5946b90ee76ec61cb0cb5bd7aedaeffafb947a5283292957199efca3a2" => :high_sierra
    sha256 "8172e64580a6c5b051a18338de14b747ea56749faf1913791ed57bdc06b0b29b" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
