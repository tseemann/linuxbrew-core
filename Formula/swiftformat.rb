class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.3.tar.gz"
  sha256 "5249438143fa240f16d218727e30476739eddad048fef749103e72b928859929"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "78237244269a102d41f9d5abbad8c877c81bdff9baf25c2a33dbe03e41635ee6" => :catalina
    sha256 "1998d61dcc95bee80a784ddf4f556e90f9fa6f658cc9fffa8c65e23f485f9d96" => :mojave
    sha256 "dc033b41518d26b1123fbd1cf11317f0f60a9b0e1ba7cc0538f6b09fd410ea4e" => :high_sierra
  end

  depends_on :xcode => ["10.1", :build] if OS.mac?
  depends_on :macos

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
