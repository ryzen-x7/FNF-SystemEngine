package system;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxSprite;
import lime.system.System;
import sys.FileSystem;
import sys.io.File;

import system.DesktopState;

class BootState extends FlxState {
    var loadingText:FlxText;

    override public function create():Void {
        super.create();

        // Background
        var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        add(bg);

        // Loading message
        loadingText = new FlxText(0, FlxG.height / 2 - 20, FlxG.width, "System Engine is booting...");
        loadingText.setFormat(null, 18, 0xFFFFFF, "center");
        add(loadingText);

        FlxG.sound.play(Paths.sound("ui/boot"));

        FlxG.camera.fade(0xFF000000, 1, false, function() {
            #if STORAGE_ACESS
            checkStoragePermission();
            #else
            goToDesktop();
            #end
        });
    }

    #if STORAGE_ACESS
    function checkStoragePermission():Void {
        try {
            var path = "/storage/emulated/0/.System64";
            if (!FileSystem.exists(path)) {
                FileSystem.createDirectory(path);
                loadingText.text = "Creating System64 workspace...";
            } else {
                loadingText.text = "System64 workspace found.";
            }
        } catch (e:Dynamic) {
            loadingText.text = "Permission needed to create .System64 folder.";
            // Use Lime or extension here to ask for storage access (manually in AndroidManifest if needed)
        }
        FlxG.timer.start(1, function(_) goToDesktop());
    }
    #end

    function goToDesktop():Void {
        FlxG.switchState(new DesktopState());
    }
}