require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AsyncEmacs < EmacsFormula
  desc "Emacs library for asynchronous processing"
  homepage "https://github.com/jwiegley/emacs-async"
  url "https://github.com/jwiegley/emacs-async/archive/v1.9.tar.gz"
  sha256 "1abf379c971d8b9d60969aa53f743db97e2bf6587cc13a406c632ed3ccdc4f5b"
  head "https://github.com/jwiegley/emacs-async.git"

  depends_on :emacs
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "async")
      (let ((fut (async-start
             (lambda () (sleep-for 2) "mkdir brew"))))
        (shell-command (async-get fut)))
    EOS
    system "emacs", "-Q", "--batch", "-l", "#{testpath}/test.el"
    sleep 3
    (testpath/"brew").directory?
  end
end
