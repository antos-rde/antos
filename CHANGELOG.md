## AntOS change logs
* v2.1.4
    - Frontend: ListView allows to navigate items using arrows keys
    - Backend: GridView allows to navigate items using arrows keys
* v2.1.3
    - Frontend: Calendar widget allows to change year
* v2.1.2
    - Fix docker image file permission
    - Improve security: backend create database file with 0600 mode
* v2.1.1
    - Fix notification bugs
* v2.1.0
    - improve backend security
    - Add REST API to display version info
* v.2.0.0
   - Work In Progress: The UI is redesigned to support mobile device
* V1.2.1
   - 9b5da17 - App name now can differ from pkgname
   - b381294 - fix: fix icon display problem when application is installed, remove all related settings when an application is uinstalled
   - b6c90e5 - update image path in readme
   - 14b72ef - Fix dragndrop bug on Fileview (grid mod)
   - c96919e - fix: correct jenkins build demo stage
   - 1cf7181 - Fix fileview status incorrect, add more build stage to Jenkinsfile
   - 255f9dc - update readme file, and include it to delivery
   - d08b33a - fix ar generation problem: with new version format
   - da5bbda - Allow to set version number and build ID to the current Antos build
   - 699c697 - update login form style
   - 2fd4bb5 - Bug fix + improvement
   - 6cbb463 - Fileview: list view display modified date instead of mime
   - f7081ae - Include current Antos version to login screen
   - 5d17c42 - Makefile read current version from gcode
   - 583a0c0 - update version number in code
   - c0603cd - Minor style fixes on menus and dropdown list
   - 8b029c2 - fix minor visual bug on grid view, list view and tree view
   - 86bcaf9 - visual bug fix on label: inline block by default
   - 61de957 - Visual improvements
   - 52af4b6 - fix visualize bug after style changes
   - e63cae1 - style improvement on Label, FileView, GridView, system menu  and app Panel
   - f97a45b - Add more control to mem file + bug fix on File
   - fdcc5ce - allow to create memory-based temporal VFS file system
   - 81d78aa - robusify VFS mem file handling
   - d109d6a - fix: file name display inconsitent between views
   - c26e27d - Fix multiple dialogs focus bug
   - 8b23ebe - Loading animation is now based on the current context (global or application context)
   - 2cdd8f9 - support dnd and grid sort
   - 079af3b - fix type conversion error in gridview tag
   - a6d725e - User a custom tag to manage the desktop instead of GUI
   - 0624f42 - API improvement & bug fix: - subscribed global event doesnt unsubcribed when process is killed - process killall API doesnt work as expected - improve core API
   - 3a24df1 - update announcement system
   - e345a61 - update bootstrap icons to v.1.7.1
   - b3d38cc - allow multiple files upload in single request
   - 66e96cc - update VFS API
   - 86a94a8 - update GUI API
   - 27ac7c0 - Minor bug fix on desktop handling
   - 99e0d02 - enable setting blur overlay window
   - 52709d5 - improve Window GUI API
   - 9c06d88 - AntOS load automatically custom VFS handles if available
   - c23cb1b - Improve core API: - improve OS exit API - improve VFS API
* V.1.2.0 Improvement GUI API
   - [x] File dialog should remember last opened folder
   - [x] Add dynamic key-value dialog that work on any object
   - [x] Window list panel should show window title in tooltip when mouse hovering on application icon
   - [x] Allow pinning application to system panel
   - [x] Improvement application list in market place
   - [x] Allow triplet keyboard shortcut in GUI
   - [x] CodePad allows setting shortcut in CommandPalette commands
   - [ ] Improvement multi-window application support
   - [x] CodePad should have recent menu entry that remember top n file opened
   - [x] Improve File application grid view
   - [x] Label text should be selectable 
   - [x] switch window using shortcut
   - [x] Loading bar animation on system pannel
   - [x] Multiple file upload support
   - [x] Generic key-value dialog 
   - [x] Add bootstrap font support for icons
   - [x] Class applications by categories in start menu
   - [x]  Support vertical and horizontal resize window
   - Market place now classifies application by categories
   - CodePad is no longer default system application, it has been moved to MarketPlace
   - More applications added to MarketPlace
   - Antos SDK
        - SDK is no longer included in base Antos release, it can be installed via MarketPlace
        - The SDK now has a generic API that can be used in different development tasks other than AntOS application
        - Heavy SDK tasks are now offloaded to workers
        - Introduce new JSON based syntax for SDK task/target definition
   - From this version, docker image of All-in-one AntOS system is available at: [https://hub.docker.com/r/xsangle/antosaio](https://hub.docker.com/r/xsangle/antosaio)