package states;

import backend.Achievements;

import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import flixel.input.keyboard.FlxKey;

import lime.app.Application;

import objects.AchievementPopup;
import states.editors.MasterEditorMenu;
import options.OptionsState;

using StringTools;

class MainMenuState extends MusicBeatState {
	public static var psychEngineVersion:String = '0.7.3'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxText>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story mOde',
		'freePlay',
		#if MODS_ALLOWED 'moDs', #end
		#if ACHIEVEMENTS_ALLOWED 'awaRds', #end
		'creDits',
		'optiOns'
	];

	var camFollow:FlxObject;

	override function create() {
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence(Language.getPhrase('discordrpc_in_menu', 'In the menus'), null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn  = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		menuItems = new FlxTypedGroup<FlxText>();
		add(menuItems);
			for (num => str in optionShit) {
				var menuItem:FlxText = new FlxText (0, 100 + (num * 55), 0, Language.getPhrase('mainmenu_$str', str), false);
				menuItem.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER);
				menuItem.borderSize = 2;
				menuItem.antialiasing = false;
				menuItem.screenCenter(X);
				menuItem.ID = num;
				menuItems.add(menuItem);
				menuItem.updateHitbox();
			}

		FlxG.camera.follow(camFollow, null, 0);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var funkinVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		funkinVer.scrollFactor.set();
		funkinVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(funkinVer);

		changeItem();

		#if ACHIEVEMENTS_ALLOWED // Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float) {
		if (PlayState.SONG != null) {
			PlayState.SONG.arrowSkin = null;
			PlayState.SONG.splashSkin = null;
			PlayState.stageUI = 'normal';
		}

		if (FlxG.sound.music.volume < 0.8) {
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}
		FlxG.camera.followLerp = FlxMath.bound(elapsed * 9 / (FlxG.updateFramerate / 60), 0, 1);

		if (!selectedSomethin) {
			if (controls.UI_UP_P) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK) {
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT) {
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				menuItems.forEach(function(txt:FlxText) {
					if (curSelected != txt.ID) {
						FlxTween.tween(txt, {alpha: 0}, 0.2, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween) {
								txt.kill();
							}
						});
					}
					else {
						FlxFlicker.flicker(txt, 1, 0.06, false, false, function(flick:FlxFlicker) {
							var daChoice:String = optionShit[curSelected];

							switch (daChoice) {
								case 'story mOde':
									MusicBeatState.switchState(new StoryMenuState());
								case 'freePlay':
									MusicBeatState.switchState(new FreeplayState());
							#if MODS_ALLOWED
								case 'moDs':
									MusicBeatState.switchState(new ModsMenuState());
							#end
								case 'awaRds':
									MusicBeatState.switchState(new AchievementsMenuState());
								case 'creDits':
									MusicBeatState.switchState(new CreditsState());
								case 'optiOns':
									LoadingState.loadAndSwitchState(new OptionsState());
									OptionsState.onPlayState = false;
							}
						});
					}
				});
			}
			#if desktop
			else if (controls.justPressed('debug_1')) {
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
			#if SUNKY_COBIA_HIDDEN_SECRET
			else if (FlxG.keys.firstJustPressed() != FlxKey.NONE)
			{
				var keyPressed:FlxKey = FlxG.keys.firstJustPressed();
				var keyName:String = Std.string(keyPressed);
				if (allowedKeys.contains(keyName))
				{
					easterEggKeysBuffer += keyName;
					if (easterEggKeysBuffer.length >= 32)
						easterEggKeysBuffer = easterEggKeysBuffer.substring(1);
					// trace('Test! Allowed Key pressed!!! Buffer: ' + easterEggKeysBuffer);

					for (wordRaw in easterEggKeys)
					{
						var word:String = wordRaw.toString().toUpperCase(); // just for being sure you're doing it right
						if (easterEggKeysBuffer.contains(word))
						{
							// trace('YOOO! ' + word);
							if (FlxG.save.data.sunkyCobiaEasterEgg == word)
								FlxG.save.data.sunkyCobiaEasterEgg = '';
							else
								FlxG.save.data.sunkyCobiaEasterEgg = word;
							FlxG.save.flush();

							FlxG.sound.music.stop();
							FlxG.sound.play(Paths.sound('mttOhYes'));

							var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
							black.alpha = 0;
							add(black);

							FlxTween.tween(black, {alpha: 1}, 1, {
								onComplete: function(twn:FlxTween) {
									FlxTransitionableState.skipNextTransIn = true;
									FlxTransitionableState.skipNextTransOut = true;
									MusicBeatState.switchState(new MainMenuState());
								}
							});
							FlxG.sound.music.fadeOut();
							if (FreeplayState.vocals != null)
							{
								FreeplayState.vocals.fadeOut();
							}
							easterEggKeysBuffer = '';
							break;
						}
					}
				}
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0) {
		curSelected += huh;

		if (curSelected >= menuItems.length) curSelected = 0;
		if (curSelected < 0) curSelected = menuItems.length - 1;

		menuItems.forEach(function(txt:FlxText) { //https://github.com/Jorge-SunSpirit/Doki-Doki-Takeover/blob/main/source/MainMenuState.hx#L390; Sorry
			txt.setBorderStyle(OUTLINE, (txt.ID == curSelected) ? 0xFFFF0000 : 0xFF000000, 2);
		});
	}
}
 