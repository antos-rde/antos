# ![https://github.com/antos-rde/antos/raw/master/antos-64.png](https://github.com/antos-rde/antos/raw/master/antos-64.png) antOS v2.0.0
[![Build Status](https://ci.iohub.dev/buildStatus/icon?job=gitea-sync%2Fantos%2F2.0.x)](https://ci.iohub.dev/buildStatus/icon?job=gitea-sync%2Fantos%2F2.0.x)

AntOS is a web-based remote desktop environment that provides an all-in-one solution for setting up a cloud-based, self-hosted working environment. It features a backend API and services, a front-end web-based window manager, application APIs, a GUI toolkit, and file system abstractions. It also includes an application store and an SDK for in-browser application development, deployment, and packaging. AntOS is designed to work across devices, including desktop computers and mobile devices.

![https://github.com/antos-rde/antos/raw/master/antos-shot.png](https://github.com/antos-rde/antos/raw/master/antos-shot.png)

AntOS can be used in several application contexts, such as:
- Providing visual tools to access and control resources on remote servers and embedded Linux environments
- Providing and developing SaaS web-based applications
- Self-hosting a cloud-based working environment
- Creating a customized, user-friendly interface for managing and interacting with cloud-based resources and services
- Setting up a collaborative, online workspace for remote teams and distributed organizations
- Building a web-based operating system that can run on various devices, including laptops, tablets, and smartphones
- Creating a virtualized environment for testing and deploying web-based applications in a sandboxed environment
- Building a platform for creating and hosting web-based educational or training content
- Setting up a web-based development environment for prototyping and building web-based applications quickly and easily
- Etc, You name it!

With the provided application API and SDK, AntOS facilitates the development and deployment of user-specific applications inside the VDE environment

Github: [https://github.com/antos-rde](https://github.com/antos-rde)

## Demo
A demo of the VDE is available at  [https://app.iohub.dev/antos/](https://app.iohub.dev/antos/) using username: demo and password: demo.

If one want to run AntOS VDE locally in their system, a docker image is available at:
[https://hub.docker.com/r/iohubdev/antos](https://hub.docker.com/r/iohubdev/antos)

## Build and install

See [BUILD.md](BUILD.md) for more information on project building and installing

## AntOS applications (Available on the MarketPlace)
[https://github.com/antos-rde/antosdk-apps](https://github.com/antos-rde/antosdk-apps)

## Front-end Documentation
- API: [https://doc.iohub.dev/antos/api/](https://doc.iohub.dev/antos/api/)

## Change logs
### v.2.0.0
   - Work In Progress: The UI is redesigned to support mobile device
### V1.2.1
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
### V.1.2.0 Improvement GUI API
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
* Market place now classifies application by categories
* CodePad is no longer default system application, it has been moved to MarketPlace
* More applications added to MarketPlace
* Antos SDK
   - SDK is no longer included in base Antos release, it can be installed via MarketPlace
   - The SDK now has a generic API that can be used in different development tasks other than AntOS application
   - Heavy SDK tasks are now offloaded to workers
   - Introduce new JSON based syntax for SDK task/target definition
* From this version, docker image of All-in-one AntOS system is available at: [https://hub.docker.com/r/xsangle/antosaio](https://hub.docker.com/r/xsangle/antosaio)

## Licence

Copyright 2017-2022 Xuan Sang LE <mrsang AT iohub DOT dev>

AnTOS is is licensed under the GNU General Public License v3.0, see the LICENCE file for more information

 This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

   This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

**For comercial use, please contact author**
