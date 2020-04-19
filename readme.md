# Run

- [ ] place script in the folder, where all the pdf's are (do not use subfolders)
- [ ] Run PowerShell ISE as Administrator (Need to install / import Modules)
- [ ] Open Script in Powershell (Ctrl + O)
- [ ] Change Directory in Console to where Script & PDF Files are
- [ ] Run (F5)
- [ ] Accept Promt 2x "Yes to All"

# Configuration / Restrictions

- Line 2 - 4 are changeable Parameters:
  - Separator
  - Separator Index
  - Text to Remove from Filename
- All Numbers in the Filename will be lost
- Merging is based on grouped Separator-Text at given Index and sorted by Filename (asc)
