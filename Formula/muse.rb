require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Muse < EmacsFormula
  desc "Authoring and publishing environment for Emacs"
  homepage "https://www.gnu.org/software/emacs-muse/"
  url "https://github.com/alexott/muse/archive/v3.20.tar.gz"
  sha256 "2ef519db1c1119b2346d40ac8ea640143a5ea939d7b40ac3d142200dc275d584"
  head "https://github.com/alexott/muse.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf1cc4ddfd35590820de2188338c07b93739c19602e43bd86ebdee280f953b5f" => :sierra
    sha256 "cf1cc4ddfd35590820de2188338c07b93739c19602e43bd86ebdee280f953b5f" => :el_capitan
    sha256 "cf1cc4ddfd35590820de2188338c07b93739c19602e43bd86ebdee280f953b5f" => :yosemite
  end

  depends_on emacs: "21.1"
  depends_on "dunn/emacs/htmlize"

  def install
    inreplace "Makefile.defs.default", "/usr/local", prefix

    # for some reason `make all` hangs in Homebrew
    system "make", "autoloads"
    system "make", "lisp"
    system "make", "contrib"
    system "make", "experimental"
    system "make", "info-only"

    system "make", "test"
    system "make", "install"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "muse-mode")
      (load "muse-project")

      (load "muse-html")
      (load "muse-latex")
      (load "muse-texinfo")
      (load "muse-docbook")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
