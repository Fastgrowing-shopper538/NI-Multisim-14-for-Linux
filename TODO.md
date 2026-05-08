change the way the script handles wine at the end of the installation:

either

```bash
echo "Running Multisim installer via Wine..."

WINEPREFIX=~/.multisim32 wine setup.exe &
WINE_PID=$!

# Wait for installer to finish
wait $WINE_PID || true

echo "Installer finished. Cleaning Wine reboot state..."

# Kill possible reboot/shutdown dialogs
wineserver -k || true

# Optional: remove pending reboot flags
rm -f ~/.multisim32/system.reg.bak 2>/dev/null || true

sleep 2
```
or

```bash
echo "Running Multisim installer via Wine..."

WINEPREFIX=~/.multisim32 wine cmd /c "start /wait setup.exe"

echo "Installer closed."

# terminate remaining wine processes
WINEPREFIX=~/.multisim32 wineserver -k || true
```

fix the echo at the end with the ~/.wine/drive_c/...

```bash
rm -rf multisim_installer NI_Circuit_Design_Suite_14_0.zip
```

instead of 

```bash
sudo rm -rf multisim_installer NI_Circuit_Design_Suite_14_0.zip
```


- fix the ubuntu .desktop problem
- add do you want to reboot prompt
- fix fedora's problem with wine64
- merge the ubuntu fedora wine installations
- add if statement for ubuntu's creation of the 32bit prefix
- and tryout suse
