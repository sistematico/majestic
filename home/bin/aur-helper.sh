git clone ssh://aur@aur.archlinux.org/pkgbase.git
makepkg --printsrcinfo > .SRCINFO
git add PKGBUILD .SRCINFO
git commit -m "useful commit message"
git push
