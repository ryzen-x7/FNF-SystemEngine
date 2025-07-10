package system;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import openfl.Lib;
import openfl.utils.Assets;

import system.BootState;

class DesktopState extends FlxState {
	var desktopBG:FlxSprite;
	var iconGroup:FlxGroup;
	var mouseCursor:FlxSprite;

	override public function create():Void {
		super.create();

		// Desktop background image
		desktopBG = new FlxSprite(0, 0);
		desktopBG.loadGraphic(Paths.image("ui/windowsxp/bg")); // Make sure this file exists
		add(desktopBG);

		// Group to hold all desktop icons
		iconGroup = new FlxGroup();

		// Example desktop icons
		addIcon("My Computer", 32, 32, function() {
			FlxG.sound.play(Paths.sound("ui/select"));
			// TODO: Open mods list
		});

		addIcon("Recycle Bin", 32, 128, function() {
			FlxG.sound.play(Paths.sound("ui/trash"));
			// TODO: Trash action or confirmation dialog
		});

		addIcon("Terminal", 32, 224, function() {
			FlxG.switchState(new TerminalState());
		});

		add(iconGroup);

		// Mouse cursor (should be replaced with spritesheet later)
		mouseCursor = new FlxSprite();
		mouseCursor.loadGraphic(Paths.image("ui/windowsxp/cursor"));
		mouseCursor.scrollFactor.set(0, 0);
		add(mouseCursor);
	}

	// Adds a new desktop icon
	function addIcon(label:String, x:Float, y:Float, callback:Void->Void):Void {
		var icon = new FlxButton(x, y, label, callback);
		icon.loadGraphic(Paths.image("ui/windowsxp/icon-$label"), true, 48, 48);
		iconGroup.add(icon);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		// Update cursor position depending on platform
		#if mobile
			if (FlxG.touches.getFirst() != null) {
				mouseCursor.x = FlxG.touches.getFirst().x;
				mouseCursor.y = FlxG.touches.getFirst().y;
			}
		#else
			mouseCursor.x = FlxG.mouse.screenX;
			mouseCursor.y = FlxG.mouse.screenY;
		#end
	}
}

class TerminalState extends FlxState {
	var inputText:FlxText;
	var currentCommand:String = "";
	
	override public function create():Void {
		super.create();

		// Basic terminal UI
		add(new FlxText(10, 10, 0, "System Engine Terminal", 16));
		inputText = new FlxText(10, 40, 0, "> ", 14);
		add(inputText);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		// Listen to key presses
		var key = FlxG.keys.getFirstJustPressed();
		if (key != null) {
			if (key == "ENTER") {
				executeCommand(currentCommand);
				currentCommand = "";
				inputText.text = "> ";
			} else if (key == "BACKSPACE") {
				if (currentCommand.length > 0) {
					currentCommand = currentCommand.substr(0, currentCommand.length - 1);
					inputText.text = "> " + currentCommand;
				}
			} else {
				currentCommand += key;
				inputText.text = "> " + currentCommand;
			}
		}
	}

	// Executes typed command
	function executeCommand(command:String):Void {
		switch (command.toLowerCase()) {
			case "cmd pe_ofc":
				FlxG.switchState(new TitleState());
			case "cmd mods":
				// TODO: Open mods menu
			case "cmd help":
				FlxG.log.add("Available commands: cmd pe_ofc, cmd mods, cmd help");
			default:
				FlxG.log.add("Unknown command: " + command);
		}
	}
}