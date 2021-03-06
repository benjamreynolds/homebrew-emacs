require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Js2Mode < EmacsFormula
  desc "Improved major mode for editing JavaScript in Emacs"
  homepage "https://github.com/mooz/js2-mode"
  url "https://github.com/mooz/js2-mode/archive/20170116.tar.gz"
  sha256 "ad18557494b4b251829dbc0b01a1976215799ddba04140475786797f122a9e67"
  head "https://github.com/mooz/js2-mode.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddeb0113cf9564fc6b5d0e85fe41bec0b710e72c0ba99600612e36440b812b7c" => :sierra
    sha256 "f0396350a6d250c5aeca1d9ccf77a206333606f4980635704477ee71e444458a" => :el_capitan
    sha256 "f0396350a6d250c5aeca1d9ccf77a206333606f4980635704477ee71e444458a" => :yosemite
  end

  depends_on :emacs => "24.1"

  def install
    system "make", "all"
    system "make", "test"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "js2-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
