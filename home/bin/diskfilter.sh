# Download
wget https://gist.githubusercontent.com/rarylson/da6b77ad6edde25529b2/raw/99f266a10e663e1829efc25eca6eddb9412c6fdc/00_header_patched
# Apply
mv /etc/grub.d/00_header /etc/grub.d/00_header.orig
mv 00_header_patched /etc/grub.d/00_header
# Disable the old script and enable the new one
chmod -x /etc/grub.d/00_header.orig
chmod +x /etc/grub.d/00_header
# Update Grub
update-grub
