package states;

class ErrorState extends MusicBeatState {
	public var acceptCallback:Void->Void;
	public var backCallback:Void->Void;
	public var errorMsg:String;

	/**
	 * Creates an Error Screen
	 * @param error Error message
	 * @param accept (Void) Function that acts if `ACCEPT` button is pressed
	 * @param back (Void) Function that acts if `BACK` button is pressed
	 * @param translation Translation key for `.lang` files
	 * @author Sunkydev31
	 */
	public function new(error:String, accept:Void->Void = null, back:Void->Void = null, translation:String = null) {
		this.errorMsg = Language.getPhrase('error_$translation', error, ["Accept", "Back"]);
		this.acceptCallback = accept;
		this.backCallback = back;

		// trace('translation: error_$translation');

		super();
	}

	public var errorSine:Float = 0;
	public var errorText:FlxText;

	override function create() {
		var bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = FlxColor.GRAY;
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
		bg.screenCenter();

		errorText = new FlxText(0, 0, FlxG.width - 300, errorMsg, 32);
		errorText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		errorText.scrollFactor.set();
		errorText.borderSize = 2;
		errorText.screenCenter();
		add(errorText);
		super.create();
	}

	override function update(elapsed:Float) {
		errorSine += 180 * elapsed;
		errorText.alpha = 1 - Math.sin((Math.PI * errorSine) / 180);

		if (controls.ACCEPT && acceptCallback != null)
			acceptCallback();
		else if (controls.BACK && backCallback != null)
			backCallback();

		super.update(elapsed);
	}
}
