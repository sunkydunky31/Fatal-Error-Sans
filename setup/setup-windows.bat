@echo off
color 0a
cd ..
echo Installing dependencies.
haxelib install flixel 5.5.0
haxelib install flixel-addons 3.2.1
haxelib install flixel-ui 2.5.0
haxelib install flixel-tools
haxelib install hxdiscord_rpc 1.2.4
haxelib install lime 8.0.2
haxelib run lime setup
haxelib install openfl 9.3.2
echo No content for SScript! Skipping...
haxelib install tjson 1.4.0
haxelib git flxanimate https://github.com/ShadowMario/flxanimate dev
haxelib git hxCodec https://github.com/polybiusproxy/hxCodec.git
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
echo Finished!
pause
