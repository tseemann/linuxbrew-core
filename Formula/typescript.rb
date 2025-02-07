require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-3.8.2.tgz"
  sha256 "1cd64750f2ca8a3bac0ca8a34316564441e43319459ed646742ee2f6de730288"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4ae9f4a7860e5c88a0bcf293a1d5ba9b8825e73924da21e58d94434f0e27dca" => :catalina
    sha256 "c69183330ca2f50a07cc625fab3339c37bccda7ce1159cd492259f25f9e1c57e" => :mojave
    sha256 "436a68487e6253e9328f0cc85ff381eee066c8f7d45a51c82c5d27c8fda09eec" => :high_sierra
    sha256 "ba900a04c6935ca0a914ce67d37d79590f72d71dc2bb65bc2eae40a233c21065" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.ts").write <<~EOS
      class Test {
        greet() {
          return "Hello, world!";
        }
      };
      var test = new Test();
      document.body.innerHTML = test.greet();
    EOS

    system bin/"tsc", "test.ts"
    assert_predicate testpath/"test.js", :exist?, "test.js was not generated"
  end
end
