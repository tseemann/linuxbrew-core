class Scons < Formula
  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://downloads.sourceforge.net/project/scons/scons/3.1.2/scons-3.1.2.tar.gz"
  sha256 "7801f3f62f654528e272df780be10c0e9337e897650b62ddcee9f39fde13f8fb"
  revision OS.mac? ? 1 : 2

  bottle do
    cellar :any_skip_relocation
    sha256 "d754617c360bfc6701d9b3e345ff08d28530adafb302227ec6fe8eea6760ca28" => :catalina
    sha256 "d754617c360bfc6701d9b3e345ff08d28530adafb302227ec6fe8eea6760ca28" => :mojave
    sha256 "d754617c360bfc6701d9b3e345ff08d28530adafb302227ec6fe8eea6760ca28" => :high_sierra
    sha256 "e2a7b71e6a79f285b8376ccc76c055f507e3f4bfb4b4ad760d6509efa25b2f3a" => :x86_64_linux
  end

  depends_on "python@3.8"

  def install
    unless OS.mac?
      inreplace "engine/SCons/Platform/posix.py",
        "env['ENV']['PATH']    = '/usr/local/bin:/opt/bin:/bin:/usr/bin'",
        "env['ENV']['PATH']    = '#{HOMEBREW_PREFIX}/bin:/usr/local/bin:/opt/bin:/bin:/usr/bin'"
    end

    Dir["**/*"].each do |f|
      next unless File.file?(f)
      next unless File.read(f).include?("/usr/bin/env python")

      inreplace f, %r{#! ?/usr/bin/env python}, "#! #{Formula["python@3.8"].opt_bin/"python3"}"
    end

    man1.install gzip("scons-time.1", "scons.1", "sconsign.1")
    system Formula["python@3.8"].opt_bin/"python3", "setup.py", "install",
             "--prefix=#{prefix}",
             "--standalone-lib",
             # SCons gets handsy with sys.path---`scons-local` is one place it
             # will look when all is said and done.
             "--install-lib=#{libexec}/scons-local",
             "--install-scripts=#{bin}",
             "--install-data=#{libexec}",
             "--no-version-script", "--no-install-man"

    # Re-root scripts to libexec so they can import SCons and symlink back into
    # bin. Similar tactics are used in the duplicity formula.
    bin.children.each do |p|
      mv p, "#{libexec}/#{p.basename}.py"
      bin.install_symlink "#{libexec}/#{p.basename}.py" => p.basename
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Homebrew");
        return 0;
      }
    EOS
    (testpath/"SConstruct").write "Program('test.c')"
    system bin/"scons"
    assert_equal "Homebrew", shell_output("#{testpath}/test")
  end
end
