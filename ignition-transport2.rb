class IgnitionTransport2 < Formula
  desc "Transport middleware for robotics"
  homepage "http://ignitionrobotics.org"
  url "http://gazebosim.org/distributions/ign-transport/releases/ignition-transport2-2.0.0.tar.bz2"
  sha256 "186c3ae57843607568c2b756a6980dcb93305adcf676029a138865e0111651ed"
  revision 1

  head "https://bitbucket.org/ignitionrobotics/ign-transport", :branch => "default", :using => :hg

  bottle do
    root_url "http://gazebosim.org/distributions/ign-transport/releases"
    cellar :any
    sha256 "33a4ca0c505a599bd57c1cc78a8213d8a0ef06f30769693d6214b439e8a8df9e" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => [:build, :optional]
  depends_on "pkg-config" => :run

  depends_on "ignition-msgs"
  depends_on "ignition-tools"
  depends_on "protobuf"
  depends_on "protobuf-c" => :build
  depends_on "ossp-uuid"
  depends_on "zeromq"
  depends_on "cppzmq"

  patch do
    # Fix for pkg-config file
    url "https://bitbucket.org/ignitionrobotics/ign-transport/commits/9fc8a2312ba92aa3a6cad22dcd2fe4e6084a465c/raw/"
    sha256 "1bb1ee054798e13190d27e87c168d63053dde3ae20f7b99dddbe43beb811d7ca"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <ignition/transport.hh>
      int main() {
        ignition::transport::Node node;
        return 0;
      }
    EOS
    system "pkg-config", "ignition-transport2"
    cflags = `pkg-config --cflags ignition-transport2`.split(" ")
    system ENV.cc, "test.cpp",
                   *cflags,
                   "-L#{lib}",
                   "-lignition-transport2",
                   "-lc++",
                   "-o", "test"
    system "./test"
  end
end
