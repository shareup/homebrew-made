# Inspired by https://github.com/mxcl/homebrew-made/blob/master/swift-sh.rb
# originally created by Max Howell

class SwiftSh < Formula
  desc "Scripting with easy zero-conf dependency imports"
  homepage "https://github.com/shareup/swift-sh"
  url "https://github.com/shareup/swift-sh/archive/1.15.1.tar.gz"
  sha256 "2849d9712ace0ba08b3d7a640995b26b8684d23468008b1d48546c8b2fdf3273"

  # bottle do
  #   root_url "https://github.com/shareup/swift-sh/releases/download/1.15.0"
  #   cellar :any_skip_relocation
  #   sha256 "54de37eab01b7ab7603b0a0e32dc21ca10a9c94b02166062e797cef3ce811fb0" => :mojave
  # end

  def install
    args = ["swift", "build",
      "--configuration", "release",
      "--disable-sandbox"]
    args += ["-Xswiftc", "-static-stdlib"] unless swift_abi_safe or OS.linux?

    system *args

    bin.install '.build/release/swift-sh'
    bin.install '.build/release/swift-sh-edit' if OS.mac?
  end

  def swift_abi_safe
    # Swift 5 is ABI safe since Xcode 10.2-beta3
    return false unless OS.mac?
    return false unless MacOS.full_version >= '10.14.4'
    # this check is redundant really, but we’re just being careful
    return false unless File.file? "/usr/lib/swift/libswiftFoundation.dylib"
    `swift --version` =~ /Swift version (\d+)\.\d+/
    $1.to_i >= 5
  end

  pour_bottle? do
    reason "The bottle requires a Swift ABI stable version of macOS"
    satisfy do
      MacOS.version < '10.14.4'
    end
  end
end
