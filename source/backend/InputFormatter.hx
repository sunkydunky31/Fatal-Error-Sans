package backend;

import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.FlxGamepadManager;

class InputFormatter {
	public static function getKeyName(key:FlxKey):String {
		switch (key) {
			case BACKSPACE:
				return Language.getPhrase('flxkey_backspace', "BckSpc");
			case SPACE:
				return Language.getPhrase('flxkey_spacebar', "Space");
			case CONTROL:
				return Language.getPhrase('flxkey_ctrl', "CTRL");
			case ALT:
				return Language.getPhrase('flxkey_alt', "ALT");
			case CAPSLOCK:
				return Language.getPhrase('flxkey_capslock', "CapsLock");
			case PAGEUP:
				return Language.getPhrase('flxkey_pageup', "PgUp");
			case PAGEDOWN:
				return Language.getPhrase('flxkey_pagedown', "PgDown");
			case ZERO:
				return "0";
			case ONE:
				return "1";
			case TWO:
				return "2";
			case THREE:
				return "3";
			case FOUR:
				return "4";
			case FIVE:
				return "5";
			case SIX:
				return "6";
			case SEVEN:
				return "7";
			case EIGHT:
				return "8";
			case NINE:
				return "9";
			case NUMPADZERO:
				return "#0";
			case NUMPADONE:
				return "#1";
			case NUMPADTWO:
				return "#2";
			case NUMPADTHREE:
				return "#3";
			case NUMPADFOUR:
				return "#4";
			case NUMPADFIVE:
				return "#5";
			case NUMPADSIX:
				return "#6";
			case NUMPADSEVEN:
				return "#7";
			case NUMPADEIGHT:
				return "#8";
			case NUMPADNINE:
				return "#9";
			case NUMPADMULTIPLY:
				return "#*";
			case NUMPADPLUS:
				return "#+";
			case NUMPADMINUS:
				return "#-";
			case NUMPADPERIOD:
				return "#.";
			case SEMICOLON:
				return ";";
			case COMMA:
				return ",";
			case PERIOD:
				return ".";
			//case SLASH:
			//	return "/";
			case GRAVEACCENT:
				return "`";
			case LBRACKET:
				return "[";
			//case BACKSLASH:
			//	return "\\";
			case RBRACKET:
				return "]";
			case QUOTE:
				return "'";
			case PRINTSCREEN:
				return Language.getPhrase('flxkey_printscreen', "PrtScrn");
			case NONE:
				return '---';
			default:
				var label:String = Std.string(key);
				if(label.toLowerCase() == 'null') return '---';

				var arr:Array<String> = label.split('_');
				for (i in 0...arr.length) arr[i] = CoolUtil.capitalize(arr[i]);
				return arr.join(' ');
		}
	}

	public static function getGamepadName(key:FlxGamepadInputID)
	{
		var gamepad:FlxGamepad = FlxG.gamepads.firstActive;
		var model:FlxGamepadModel = gamepad != null ? gamepad.detectedModel : UNKNOWN;

		switch(key)
		{
			// Analogs
			case LEFT_STICK_DIGITAL_LEFT:
				return Language.getPhrase("flxkey_gamepad_left", "Left");
			case LEFT_STICK_DIGITAL_RIGHT:
				return Language.getPhrase("flxkey_gamepad_right", "Right");
			case LEFT_STICK_DIGITAL_UP:
				return Language.getPhrase("flxkey_gamepad_up", "Up");
			case LEFT_STICK_DIGITAL_DOWN:
				return Language.getPhrase("flxkey_gamepad_down", "Down");
			case LEFT_STICK_CLICK:
				switch (model) {
					case PS4: return "L3";
					case XINPUT: return "LS";
					default: return Language.getPhrase("flxkey_gamepad_analog-click", "Analog Click");
				}

			case RIGHT_STICK_DIGITAL_LEFT:
				return Language.getPhrase("flxkey_gamepad_c-left", "C. Left");
			case RIGHT_STICK_DIGITAL_RIGHT:
				return Language.getPhrase("flxkey_gamepad_c-right", "C. Right");
			case RIGHT_STICK_DIGITAL_UP:
				return Language.getPhrase("flxkey_gamepad_c-up", "C. Up");
			case RIGHT_STICK_DIGITAL_DOWN:
				return Language.getPhrase("flxkey_gamepad_c-down", "C. Down");
			case RIGHT_STICK_CLICK:
				switch (model) {
					case PS4: return "R3";
					case XINPUT: return "RS";
					default: return Language.getPhrase("flxkey_gamepad_c-click", "C. Click");
				}

			// Directional
			case DPAD_LEFT:
				return Language.getPhrase("flxkey_gamepad_dpad-left", "D. Left");
			case DPAD_RIGHT:
				return Language.getPhrase("flxkey_gamepad_dpad-right", "D. Right");
			case DPAD_UP:
				return Language.getPhrase("flxkey_gamepad_dpad-up", "D. Up");
			case DPAD_DOWN:
				return Language.getPhrase("flxkey_gamepad_dpad-down", "D. Down");

			// Top buttons
			case LEFT_SHOULDER:
				switch(model) {
					case PS4: return "L1";
					case XINPUT: return "LB";
					default: return Language.getPhrase("flxkey_gamepad_lbumper", "L. Bumper");
				}
			case RIGHT_SHOULDER:
				switch(model) {
					case PS4: return "R1";
					case XINPUT: return "RB";
					default: return Language.getPhrase("flxkey_gamepad_rbumper", "R. Bumper");
				}
			case LEFT_TRIGGER, LEFT_TRIGGER_BUTTON:
				switch(model) {
					case PS4: return "L2";
					case XINPUT: return "LT";
					default: return Language.getPhrase("flxkey_gamepad_ltriggger", "L. Trigger");
				}
			case RIGHT_TRIGGER, RIGHT_TRIGGER_BUTTON:
				switch(model) {
					case PS4: return "R2";
					case XINPUT: return "RT";
					default: return Language.getPhrase("flxkey_gamepad_rtriggger", "R. Trigger");
				}

			// Buttons
			case A:
				switch (model) {
					case PS4: return "X";
					case XINPUT: return "A";
					default: return "Action Down";
				}
			case B:
				switch (model) {
					case PS4: return "O";
					case XINPUT: return "B";
					default: return "Action Right";
				}
			case X:
				switch (model) {
					case PS4: return "["; //This gets its image changed through code
					case XINPUT: return "X";
					default: return "Action Left";
				}
			case Y:
				switch (model) { 
					case PS4: return "]"; //This gets its image changed through code
					case XINPUT: return "Y";
					default: return "Action Up";
				}

			case BACK:
				switch(model) {
					case PS4: return "Share";
					case XINPUT: return "Back";
					default: return "Select";
				}
			case START:
				switch(model) {
					case PS4: return "Options";
					default: return "Start";
				}

			case NONE:
				return '---';

			default:
				var label:String = Std.string(key);
				if(label.toLowerCase() == 'null') return '---';

				var arr:Array<String> = label.split('_');
				for (i in 0...arr.length) arr[i] = CoolUtil.capitalize(arr[i]);
				return arr.join(' ');
		}
	}
}