class OrgMode < Formula
  desc "Notes, TODOs, and project planning for Emacs"
  homepage "http://orgmode.org"
  url "http://orgmode.org/org-8.2.10.tar.gz"
  sha256 "df09451829219f4ff25185670823ad319f96839962b44b6836c78ccc3fb2a8f6"

  head "git://orgmode.org/org-mode.git", :shallow => false

  devel do
    url "git://orgmode.org/org-mode.git",
        :shallow => false,
        :tag => "release_8.3beta",
        :revision => "4a4dbe16d82b4c8d441e79358003577c1ffdb440"
    version "8.3beta"
  end

  depends_on "dunn/emacs/dash"

  option "with-texinfo+", "Install Jonas Bernoulli's extension of ox-texinfo"

  # sort of arbitrary; I can't find an official minimum version required
  depends_on :emacs => "22.2"
  depends_on :tex => :optional

  resource "ox-texinfo-plus" do
    url "https://github.com/tarsius/ox-texinfo-plus/raw/4e3c611ce8b79593171593d2907e0f95ae5c97fc/ox-texinfo%2B.el"
    sha256 "b4d3e376b361dbf24db33b542928f8b5c7acb13325b9a970dacb3ca50a83bbd5"
  end

  def install
    system "make", "all"
    rm "local.mk"
    (buildpath/"local.mk").write <<-EOS.undent
      prefix  = #{prefix}
      lispdir = #{share}/emacs/site-lisp/#{name}
      datadir = #{etc}/emacs/#{name}
      infodir = #{info}/emacs/#{name}
    EOS
    system "make", "install"

    if build.with? "texinfo+"
      resource("ox-texinfo-plus").stage { (share/"emacs/site-lisp/#{name}").install "ox-texinfo%2B.el" => "ox-texinfo+.el" }
    end

    (share/"emacs/site-lisp/#{name}").install "contrib/lisp" => "contrib"
    info.install "doc/org" => "org.info"
  end

  def caveats; <<-EOS.undent
    You may need to remove the version of org that's bundled with newer versions of Emacs.
    Lisp files have been installed to:
    #{HOMEBREW_PREFIX}/share/emacs/site-lisp/#{name}
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "org")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end
