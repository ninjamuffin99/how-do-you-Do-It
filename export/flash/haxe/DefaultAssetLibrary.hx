package;


import haxe.Timer;
import haxe.Unserializer;
import lime.app.Future;
import lime.app.Preloader;
import lime.app.Promise;
import lime.audio.AudioSource;
import lime.audio.openal.AL;
import lime.audio.AudioBuffer;
import lime.graphics.Image;
import lime.net.HTTPRequest;
import lime.system.CFFI;
import lime.text.Font;
import lime.utils.Bytes;
import lime.utils.UInt8Array;
import lime.Assets;

#if sys
import sys.FileSystem;
#end

#if flash
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.net.URLLoader;
import flash.net.URLRequest;
#end


class DefaultAssetLibrary extends AssetLibrary {
	
	
	public var className (default, null) = new Map <String, Dynamic> ();
	public var path (default, null) = new Map <String, String> ();
	public var type (default, null) = new Map <String, AssetType> ();
	
	private var lastModified:Float;
	private var timer:Timer;
	
	
	public function new () {
		
		super ();
		
		#if (openfl && !flash)
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_monsterrat_ttf);
		
		
		
		#end
		
		#if flash
		
		className.set ("assets/data/data-goes-here.txt", __ASSET__assets_data_data_goes_here_txt);
		type.set ("assets/data/data-goes-here.txt", AssetType.TEXT);
		className.set ("assets/images/barbieken.png", __ASSET__assets_images_barbieken_png);
		type.set ("assets/images/barbieken.png", AssetType.IMAGE);
		className.set ("assets/images/barb_armL.png", __ASSET__assets_images_barb_arml_png);
		type.set ("assets/images/barb_armL.png", AssetType.IMAGE);
		className.set ("assets/images/barb_armR.png", __ASSET__assets_images_barb_armr_png);
		type.set ("assets/images/barb_armR.png", AssetType.IMAGE);
		className.set ("assets/images/barb_chest.png", __ASSET__assets_images_barb_chest_png);
		type.set ("assets/images/barb_chest.png", AssetType.IMAGE);
		className.set ("assets/images/barb_footL.png", __ASSET__assets_images_barb_footl_png);
		type.set ("assets/images/barb_footL.png", AssetType.IMAGE);
		className.set ("assets/images/barb_footR.png", __ASSET__assets_images_barb_footr_png);
		type.set ("assets/images/barb_footR.png", AssetType.IMAGE);
		className.set ("assets/images/barb_head.png", __ASSET__assets_images_barb_head_png);
		type.set ("assets/images/barb_head.png", AssetType.IMAGE);
		className.set ("assets/images/barb_hips.png", __ASSET__assets_images_barb_hips_png);
		type.set ("assets/images/barb_hips.png", AssetType.IMAGE);
		className.set ("assets/images/barb_legL.png", __ASSET__assets_images_barb_legl_png);
		type.set ("assets/images/barb_legL.png", AssetType.IMAGE);
		className.set ("assets/images/barb_legR.png", __ASSET__assets_images_barb_legr_png);
		type.set ("assets/images/barb_legR.png", AssetType.IMAGE);
		className.set ("assets/images/blush.png", __ASSET__assets_images_blush_png);
		type.set ("assets/images/blush.png", AssetType.IMAGE);
		className.set ("assets/images/car.png", __ASSET__assets_images_car_png);
		type.set ("assets/images/car.png", AssetType.IMAGE);
		className.set ("assets/images/dolls.png", __ASSET__assets_images_dolls_png);
		type.set ("assets/images/dolls.png", AssetType.IMAGE);
		className.set ("assets/images/faces_strip.png", __ASSET__assets_images_faces_strip_png);
		type.set ("assets/images/faces_strip.png", AssetType.IMAGE);
		className.set ("assets/images/girl1.png", __ASSET__assets_images_girl1_png);
		type.set ("assets/images/girl1.png", AssetType.IMAGE);
		className.set ("assets/images/girl2.png", __ASSET__assets_images_girl2_png);
		type.set ("assets/images/girl2.png", AssetType.IMAGE);
		className.set ("assets/images/girl3.png", __ASSET__assets_images_girl3_png);
		type.set ("assets/images/girl3.png", AssetType.IMAGE);
		className.set ("assets/images/girl_body.png", __ASSET__assets_images_girl_body_png);
		type.set ("assets/images/girl_body.png", AssetType.IMAGE);
		className.set ("assets/images/girl_caught.png", __ASSET__assets_images_girl_caught_png);
		type.set ("assets/images/girl_caught.png", AssetType.IMAGE);
		className.set ("assets/images/girl_fingersL.png", __ASSET__assets_images_girl_fingersl_png);
		type.set ("assets/images/girl_fingersL.png", AssetType.IMAGE);
		className.set ("assets/images/girl_fingersR.png", __ASSET__assets_images_girl_fingersr_png);
		type.set ("assets/images/girl_fingersR.png", AssetType.IMAGE);
		className.set ("assets/images/girl_forearm.png", __ASSET__assets_images_girl_forearm_png);
		type.set ("assets/images/girl_forearm.png", AssetType.IMAGE);
		className.set ("assets/images/girl_handL.png", __ASSET__assets_images_girl_handl_png);
		type.set ("assets/images/girl_handL.png", AssetType.IMAGE);
		className.set ("assets/images/girl_handR.png", __ASSET__assets_images_girl_handr_png);
		type.set ("assets/images/girl_handR.png", AssetType.IMAGE);
		className.set ("assets/images/girl_notcaught.png", __ASSET__assets_images_girl_notcaught_png);
		type.set ("assets/images/girl_notcaught.png", AssetType.IMAGE);
		className.set ("assets/images/house.png", __ASSET__assets_images_house_png);
		type.set ("assets/images/house.png", AssetType.IMAGE);
		className.set ("assets/images/images-go-here.txt", __ASSET__assets_images_images_go_here_txt);
		type.set ("assets/images/images-go-here.txt", AssetType.TEXT);
		className.set ("assets/images/ken_armL.png", __ASSET__assets_images_ken_arml_png);
		type.set ("assets/images/ken_armL.png", AssetType.IMAGE);
		className.set ("assets/images/ken_armR.png", __ASSET__assets_images_ken_armr_png);
		type.set ("assets/images/ken_armR.png", AssetType.IMAGE);
		className.set ("assets/images/ken_chest.png", __ASSET__assets_images_ken_chest_png);
		type.set ("assets/images/ken_chest.png", AssetType.IMAGE);
		className.set ("assets/images/ken_footL.png", __ASSET__assets_images_ken_footl_png);
		type.set ("assets/images/ken_footL.png", AssetType.IMAGE);
		className.set ("assets/images/ken_footR.png", __ASSET__assets_images_ken_footr_png);
		type.set ("assets/images/ken_footR.png", AssetType.IMAGE);
		className.set ("assets/images/ken_head.png", __ASSET__assets_images_ken_head_png);
		type.set ("assets/images/ken_head.png", AssetType.IMAGE);
		className.set ("assets/images/ken_hips.png", __ASSET__assets_images_ken_hips_png);
		type.set ("assets/images/ken_hips.png", AssetType.IMAGE);
		className.set ("assets/images/ken_legL.png", __ASSET__assets_images_ken_legl_png);
		type.set ("assets/images/ken_legL.png", AssetType.IMAGE);
		className.set ("assets/images/ken_legR.png", __ASSET__assets_images_ken_legr_png);
		type.set ("assets/images/ken_legR.png", AssetType.IMAGE);
		className.set ("assets/images/mainbg.png", __ASSET__assets_images_mainbg_png);
		type.set ("assets/images/mainbg.png", AssetType.IMAGE);
		className.set ("assets/images/mom1.png", __ASSET__assets_images_mom1_png);
		type.set ("assets/images/mom1.png", AssetType.IMAGE);
		className.set ("assets/images/mom_shock.png", __ASSET__assets_images_mom_shock_png);
		type.set ("assets/images/mom_shock.png", AssetType.IMAGE);
		className.set ("assets/images/outside.png", __ASSET__assets_images_outside_png);
		type.set ("assets/images/outside.png", AssetType.IMAGE);
		className.set ("assets/images/thoughts.png", __ASSET__assets_images_thoughts_png);
		type.set ("assets/images/thoughts.png", AssetType.IMAGE);
		className.set ("assets/images/title_screen.png", __ASSET__assets_images_title_screen_png);
		type.set ("assets/images/title_screen.png", AssetType.IMAGE);
		className.set ("assets/music/bgm.mp3", __ASSET__assets_music_bgm_mp3);
		type.set ("assets/music/bgm.mp3", AssetType.MUSIC);
		className.set ("assets/music/music-goes-here.txt", __ASSET__assets_music_music_goes_here_txt);
		type.set ("assets/music/music-goes-here.txt", AssetType.TEXT);
		className.set ("assets/sounds/blegh.mp3", __ASSET__assets_sounds_blegh_mp3);
		type.set ("assets/sounds/blegh.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/cararrive.mp3", __ASSET__assets_sounds_cararrive_mp3);
		type.set ("assets/sounds/cararrive.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/cardoor.mp3", __ASSET__assets_sounds_cardoor_mp3);
		type.set ("assets/sounds/cardoor.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/carleave.mp3", __ASSET__assets_sounds_carleave_mp3);
		type.set ("assets/sounds/carleave.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/confused.mp3", __ASSET__assets_sounds_confused_mp3);
		type.set ("assets/sounds/confused.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/doorclose.mp3", __ASSET__assets_sounds_doorclose_mp3);
		type.set ("assets/sounds/doorclose.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/dooropen.mp3", __ASSET__assets_sounds_dooropen_mp3);
		type.set ("assets/sounds/dooropen.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/garageopen.mp3", __ASSET__assets_sounds_garageopen_mp3);
		type.set ("assets/sounds/garageopen.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/hehe.mp3", __ASSET__assets_sounds_hehe_mp3);
		type.set ("assets/sounds/hehe.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/hmm.mp3", __ASSET__assets_sounds_hmm_mp3);
		type.set ("assets/sounds/hmm.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/hmph.mp3", __ASSET__assets_sounds_hmph_mp3);
		type.set ("assets/sounds/hmph.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/kissu.mp3", __ASSET__assets_sounds_kissu_mp3);
		type.set ("assets/sounds/kissu.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/ooh.mp3", __ASSET__assets_sounds_ooh_mp3);
		type.set ("assets/sounds/ooh.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/sounds-go-here.txt", __ASSET__assets_sounds_sounds_go_here_txt);
		type.set ("assets/sounds/sounds-go-here.txt", AssetType.TEXT);
		className.set ("assets/sounds/toy1.mp3", __ASSET__assets_sounds_toy1_mp3);
		type.set ("assets/sounds/toy1.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/toy2.mp3", __ASSET__assets_sounds_toy2_mp3);
		type.set ("assets/sounds/toy2.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/toy3.mp3", __ASSET__assets_sounds_toy3_mp3);
		type.set ("assets/sounds/toy3.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/toy4.mp3", __ASSET__assets_sounds_toy4_mp3);
		type.set ("assets/sounds/toy4.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/toy5.mp3", __ASSET__assets_sounds_toy5_mp3);
		type.set ("assets/sounds/toy5.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/toy6.mp3", __ASSET__assets_sounds_toy6_mp3);
		type.set ("assets/sounds/toy6.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/toy7.mp3", __ASSET__assets_sounds_toy7_mp3);
		type.set ("assets/sounds/toy7.mp3", AssetType.MUSIC);
		className.set ("assets/sounds/uh.mp3", __ASSET__assets_sounds_uh_mp3);
		type.set ("assets/sounds/uh.mp3", AssetType.MUSIC);
		className.set ("flixel/sounds/beep.mp3", __ASSET__flixel_sounds_beep_mp3);
		type.set ("flixel/sounds/beep.mp3", AssetType.MUSIC);
		className.set ("flixel/sounds/flixel.mp3", __ASSET__flixel_sounds_flixel_mp3);
		type.set ("flixel/sounds/flixel.mp3", AssetType.MUSIC);
		className.set ("flixel/fonts/nokiafc22.ttf", __ASSET__flixel_fonts_nokiafc22_ttf);
		type.set ("flixel/fonts/nokiafc22.ttf", AssetType.FONT);
		className.set ("flixel/fonts/monsterrat.ttf", __ASSET__flixel_fonts_monsterrat_ttf);
		type.set ("flixel/fonts/monsterrat.ttf", AssetType.FONT);
		className.set ("flixel/images/ui/button.png", __ASSET__flixel_images_ui_button_png);
		type.set ("flixel/images/ui/button.png", AssetType.IMAGE);
		className.set ("flixel/images/logo/default.png", __ASSET__flixel_images_logo_default_png);
		type.set ("flixel/images/logo/default.png", AssetType.IMAGE);
		
		
		#elseif html5
		
		var id;
		id = "assets/data/data-goes-here.txt";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/images/barbieken.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/barb_armL.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/barb_armR.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/barb_chest.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/barb_footL.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/barb_footR.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/barb_head.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/barb_hips.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/barb_legL.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/barb_legR.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/blush.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/car.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/dolls.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/faces_strip.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/girl1.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/girl2.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/girl3.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/girl_body.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/girl_caught.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/girl_fingersL.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/girl_fingersR.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/girl_forearm.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/girl_handL.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/girl_handR.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/girl_notcaught.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/house.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/images-go-here.txt";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/images/ken_armL.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ken_armR.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ken_chest.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ken_footL.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ken_footR.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ken_head.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ken_hips.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ken_legL.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/ken_legR.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/mainbg.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/mom1.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/mom_shock.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/outside.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/thoughts.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/images/title_screen.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "assets/music/bgm.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/music/music-goes-here.txt";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/sounds/blegh.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/cararrive.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/cardoor.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/carleave.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/confused.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/doorclose.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/dooropen.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/garageopen.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/hehe.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/hmm.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/hmph.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/kissu.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/ooh.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/sounds-go-here.txt";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "assets/sounds/toy1.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/toy2.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/toy3.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/toy4.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/toy5.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/toy6.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/toy7.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "assets/sounds/uh.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "flixel/sounds/beep.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "flixel/sounds/flixel.mp3";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "flixel/fonts/nokiafc22.ttf";
		className.set (id, __ASSET__flixel_fonts_nokiafc22_ttf);
		
		type.set (id, AssetType.FONT);
		id = "flixel/fonts/monsterrat.ttf";
		className.set (id, __ASSET__flixel_fonts_monsterrat_ttf);
		
		type.set (id, AssetType.FONT);
		id = "flixel/images/ui/button.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "flixel/images/logo/default.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		
		
		var assetsPrefix = null;
		if (ApplicationMain.config != null && Reflect.hasField (ApplicationMain.config, "assetsPrefix")) {
			assetsPrefix = ApplicationMain.config.assetsPrefix;
		}
		if (assetsPrefix != null) {
			for (k in path.keys()) {
				path.set(k, assetsPrefix + path[k]);
			}
		}
		
		#else
		
		#if (windows || mac || linux)
		
		var useManifest = false;
		
		className.set ("assets/data/data-goes-here.txt", __ASSET__assets_data_data_goes_here_txt);
		type.set ("assets/data/data-goes-here.txt", AssetType.TEXT);
		
		className.set ("assets/images/barbieken.png", __ASSET__assets_images_barbieken_png);
		type.set ("assets/images/barbieken.png", AssetType.IMAGE);
		
		className.set ("assets/images/barb_armL.png", __ASSET__assets_images_barb_arml_png);
		type.set ("assets/images/barb_armL.png", AssetType.IMAGE);
		
		className.set ("assets/images/barb_armR.png", __ASSET__assets_images_barb_armr_png);
		type.set ("assets/images/barb_armR.png", AssetType.IMAGE);
		
		className.set ("assets/images/barb_chest.png", __ASSET__assets_images_barb_chest_png);
		type.set ("assets/images/barb_chest.png", AssetType.IMAGE);
		
		className.set ("assets/images/barb_footL.png", __ASSET__assets_images_barb_footl_png);
		type.set ("assets/images/barb_footL.png", AssetType.IMAGE);
		
		className.set ("assets/images/barb_footR.png", __ASSET__assets_images_barb_footr_png);
		type.set ("assets/images/barb_footR.png", AssetType.IMAGE);
		
		className.set ("assets/images/barb_head.png", __ASSET__assets_images_barb_head_png);
		type.set ("assets/images/barb_head.png", AssetType.IMAGE);
		
		className.set ("assets/images/barb_hips.png", __ASSET__assets_images_barb_hips_png);
		type.set ("assets/images/barb_hips.png", AssetType.IMAGE);
		
		className.set ("assets/images/barb_legL.png", __ASSET__assets_images_barb_legl_png);
		type.set ("assets/images/barb_legL.png", AssetType.IMAGE);
		
		className.set ("assets/images/barb_legR.png", __ASSET__assets_images_barb_legr_png);
		type.set ("assets/images/barb_legR.png", AssetType.IMAGE);
		
		className.set ("assets/images/blush.png", __ASSET__assets_images_blush_png);
		type.set ("assets/images/blush.png", AssetType.IMAGE);
		
		className.set ("assets/images/car.png", __ASSET__assets_images_car_png);
		type.set ("assets/images/car.png", AssetType.IMAGE);
		
		className.set ("assets/images/dolls.png", __ASSET__assets_images_dolls_png);
		type.set ("assets/images/dolls.png", AssetType.IMAGE);
		
		className.set ("assets/images/faces_strip.png", __ASSET__assets_images_faces_strip_png);
		type.set ("assets/images/faces_strip.png", AssetType.IMAGE);
		
		className.set ("assets/images/girl1.png", __ASSET__assets_images_girl1_png);
		type.set ("assets/images/girl1.png", AssetType.IMAGE);
		
		className.set ("assets/images/girl2.png", __ASSET__assets_images_girl2_png);
		type.set ("assets/images/girl2.png", AssetType.IMAGE);
		
		className.set ("assets/images/girl3.png", __ASSET__assets_images_girl3_png);
		type.set ("assets/images/girl3.png", AssetType.IMAGE);
		
		className.set ("assets/images/girl_body.png", __ASSET__assets_images_girl_body_png);
		type.set ("assets/images/girl_body.png", AssetType.IMAGE);
		
		className.set ("assets/images/girl_caught.png", __ASSET__assets_images_girl_caught_png);
		type.set ("assets/images/girl_caught.png", AssetType.IMAGE);
		
		className.set ("assets/images/girl_fingersL.png", __ASSET__assets_images_girl_fingersl_png);
		type.set ("assets/images/girl_fingersL.png", AssetType.IMAGE);
		
		className.set ("assets/images/girl_fingersR.png", __ASSET__assets_images_girl_fingersr_png);
		type.set ("assets/images/girl_fingersR.png", AssetType.IMAGE);
		
		className.set ("assets/images/girl_forearm.png", __ASSET__assets_images_girl_forearm_png);
		type.set ("assets/images/girl_forearm.png", AssetType.IMAGE);
		
		className.set ("assets/images/girl_handL.png", __ASSET__assets_images_girl_handl_png);
		type.set ("assets/images/girl_handL.png", AssetType.IMAGE);
		
		className.set ("assets/images/girl_handR.png", __ASSET__assets_images_girl_handr_png);
		type.set ("assets/images/girl_handR.png", AssetType.IMAGE);
		
		className.set ("assets/images/girl_notcaught.png", __ASSET__assets_images_girl_notcaught_png);
		type.set ("assets/images/girl_notcaught.png", AssetType.IMAGE);
		
		className.set ("assets/images/house.png", __ASSET__assets_images_house_png);
		type.set ("assets/images/house.png", AssetType.IMAGE);
		
		className.set ("assets/images/images-go-here.txt", __ASSET__assets_images_images_go_here_txt);
		type.set ("assets/images/images-go-here.txt", AssetType.TEXT);
		
		className.set ("assets/images/ken_armL.png", __ASSET__assets_images_ken_arml_png);
		type.set ("assets/images/ken_armL.png", AssetType.IMAGE);
		
		className.set ("assets/images/ken_armR.png", __ASSET__assets_images_ken_armr_png);
		type.set ("assets/images/ken_armR.png", AssetType.IMAGE);
		
		className.set ("assets/images/ken_chest.png", __ASSET__assets_images_ken_chest_png);
		type.set ("assets/images/ken_chest.png", AssetType.IMAGE);
		
		className.set ("assets/images/ken_footL.png", __ASSET__assets_images_ken_footl_png);
		type.set ("assets/images/ken_footL.png", AssetType.IMAGE);
		
		className.set ("assets/images/ken_footR.png", __ASSET__assets_images_ken_footr_png);
		type.set ("assets/images/ken_footR.png", AssetType.IMAGE);
		
		className.set ("assets/images/ken_head.png", __ASSET__assets_images_ken_head_png);
		type.set ("assets/images/ken_head.png", AssetType.IMAGE);
		
		className.set ("assets/images/ken_hips.png", __ASSET__assets_images_ken_hips_png);
		type.set ("assets/images/ken_hips.png", AssetType.IMAGE);
		
		className.set ("assets/images/ken_legL.png", __ASSET__assets_images_ken_legl_png);
		type.set ("assets/images/ken_legL.png", AssetType.IMAGE);
		
		className.set ("assets/images/ken_legR.png", __ASSET__assets_images_ken_legr_png);
		type.set ("assets/images/ken_legR.png", AssetType.IMAGE);
		
		className.set ("assets/images/mainbg.png", __ASSET__assets_images_mainbg_png);
		type.set ("assets/images/mainbg.png", AssetType.IMAGE);
		
		className.set ("assets/images/mom1.png", __ASSET__assets_images_mom1_png);
		type.set ("assets/images/mom1.png", AssetType.IMAGE);
		
		className.set ("assets/images/mom_shock.png", __ASSET__assets_images_mom_shock_png);
		type.set ("assets/images/mom_shock.png", AssetType.IMAGE);
		
		className.set ("assets/images/outside.png", __ASSET__assets_images_outside_png);
		type.set ("assets/images/outside.png", AssetType.IMAGE);
		
		className.set ("assets/images/thoughts.png", __ASSET__assets_images_thoughts_png);
		type.set ("assets/images/thoughts.png", AssetType.IMAGE);
		
		className.set ("assets/images/title_screen.png", __ASSET__assets_images_title_screen_png);
		type.set ("assets/images/title_screen.png", AssetType.IMAGE);
		
		className.set ("assets/music/bgm.mp3", __ASSET__assets_music_bgm_mp3);
		type.set ("assets/music/bgm.mp3", AssetType.MUSIC);
		
		className.set ("assets/music/music-goes-here.txt", __ASSET__assets_music_music_goes_here_txt);
		type.set ("assets/music/music-goes-here.txt", AssetType.TEXT);
		
		className.set ("assets/sounds/blegh.mp3", __ASSET__assets_sounds_blegh_mp3);
		type.set ("assets/sounds/blegh.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/cararrive.mp3", __ASSET__assets_sounds_cararrive_mp3);
		type.set ("assets/sounds/cararrive.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/cardoor.mp3", __ASSET__assets_sounds_cardoor_mp3);
		type.set ("assets/sounds/cardoor.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/carleave.mp3", __ASSET__assets_sounds_carleave_mp3);
		type.set ("assets/sounds/carleave.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/confused.mp3", __ASSET__assets_sounds_confused_mp3);
		type.set ("assets/sounds/confused.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/doorclose.mp3", __ASSET__assets_sounds_doorclose_mp3);
		type.set ("assets/sounds/doorclose.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/dooropen.mp3", __ASSET__assets_sounds_dooropen_mp3);
		type.set ("assets/sounds/dooropen.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/garageopen.mp3", __ASSET__assets_sounds_garageopen_mp3);
		type.set ("assets/sounds/garageopen.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/hehe.mp3", __ASSET__assets_sounds_hehe_mp3);
		type.set ("assets/sounds/hehe.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/hmm.mp3", __ASSET__assets_sounds_hmm_mp3);
		type.set ("assets/sounds/hmm.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/hmph.mp3", __ASSET__assets_sounds_hmph_mp3);
		type.set ("assets/sounds/hmph.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/kissu.mp3", __ASSET__assets_sounds_kissu_mp3);
		type.set ("assets/sounds/kissu.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/ooh.mp3", __ASSET__assets_sounds_ooh_mp3);
		type.set ("assets/sounds/ooh.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/sounds-go-here.txt", __ASSET__assets_sounds_sounds_go_here_txt);
		type.set ("assets/sounds/sounds-go-here.txt", AssetType.TEXT);
		
		className.set ("assets/sounds/toy1.mp3", __ASSET__assets_sounds_toy1_mp3);
		type.set ("assets/sounds/toy1.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/toy2.mp3", __ASSET__assets_sounds_toy2_mp3);
		type.set ("assets/sounds/toy2.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/toy3.mp3", __ASSET__assets_sounds_toy3_mp3);
		type.set ("assets/sounds/toy3.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/toy4.mp3", __ASSET__assets_sounds_toy4_mp3);
		type.set ("assets/sounds/toy4.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/toy5.mp3", __ASSET__assets_sounds_toy5_mp3);
		type.set ("assets/sounds/toy5.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/toy6.mp3", __ASSET__assets_sounds_toy6_mp3);
		type.set ("assets/sounds/toy6.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/toy7.mp3", __ASSET__assets_sounds_toy7_mp3);
		type.set ("assets/sounds/toy7.mp3", AssetType.MUSIC);
		
		className.set ("assets/sounds/uh.mp3", __ASSET__assets_sounds_uh_mp3);
		type.set ("assets/sounds/uh.mp3", AssetType.MUSIC);
		
		className.set ("flixel/sounds/beep.mp3", __ASSET__flixel_sounds_beep_mp3);
		type.set ("flixel/sounds/beep.mp3", AssetType.MUSIC);
		
		className.set ("flixel/sounds/flixel.mp3", __ASSET__flixel_sounds_flixel_mp3);
		type.set ("flixel/sounds/flixel.mp3", AssetType.MUSIC);
		
		className.set ("flixel/fonts/nokiafc22.ttf", __ASSET__flixel_fonts_nokiafc22_ttf);
		type.set ("flixel/fonts/nokiafc22.ttf", AssetType.FONT);
		
		className.set ("flixel/fonts/monsterrat.ttf", __ASSET__flixel_fonts_monsterrat_ttf);
		type.set ("flixel/fonts/monsterrat.ttf", AssetType.FONT);
		
		className.set ("flixel/images/ui/button.png", __ASSET__flixel_images_ui_button_png);
		type.set ("flixel/images/ui/button.png", AssetType.IMAGE);
		
		className.set ("flixel/images/logo/default.png", __ASSET__flixel_images_logo_default_png);
		type.set ("flixel/images/logo/default.png", AssetType.IMAGE);
		
		
		if (useManifest) {
			
			loadManifest ();
			
			if (Sys.args ().indexOf ("-livereload") > -1) {
				
				var path = FileSystem.fullPath ("manifest");
				lastModified = FileSystem.stat (path).mtime.getTime ();
				
				timer = new Timer (2000);
				timer.run = function () {
					
					var modified = FileSystem.stat (path).mtime.getTime ();
					
					if (modified > lastModified) {
						
						lastModified = modified;
						loadManifest ();
						
						onChange.dispatch ();
						
					}
					
				}
				
			}
			
		}
		
		#else
		
		loadManifest ();
		
		#end
		#end
		
	}
	
	
	public override function exists (id:String, type:String):Bool {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		var assetType = this.type.get (id);
		
		if (assetType != null) {
			
			if (assetType == requestedType || ((requestedType == SOUND || requestedType == MUSIC) && (assetType == MUSIC || assetType == SOUND))) {
				
				return true;
				
			}
			
			#if flash
			
			if (requestedType == BINARY && (assetType == BINARY || assetType == TEXT || assetType == IMAGE)) {
				
				return true;
				
			} else if (requestedType == TEXT && assetType == BINARY) {
				
				return true;
				
			} else if (requestedType == null || path.exists (id)) {
				
				return true;
				
			}
			
			#else
			
			if (requestedType == BINARY || requestedType == null || (assetType == BINARY && requestedType == TEXT)) {
				
				return true;
				
			}
			
			#end
			
		}
		
		return false;
		
	}
	
	
	public override function getAudioBuffer (id:String):AudioBuffer {
		
		#if flash
		
		var buffer = new AudioBuffer ();
		buffer.src = cast (Type.createInstance (className.get (id), []), Sound);
		return buffer;
		
		#elseif html5
		
		return null;
		//return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		if (className.exists(id)) return AudioBuffer.fromBytes (cast (Type.createInstance (className.get (id), []), Bytes));
		else return AudioBuffer.fromFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getBytes (id:String):Bytes {
		
		#if flash
		
		switch (type.get (id)) {
			
			case TEXT, BINARY:
				
				return Bytes.ofData (cast (Type.createInstance (className.get (id), []), flash.utils.ByteArray));
			
			case IMAGE:
				
				var bitmapData = cast (Type.createInstance (className.get (id), []), BitmapData);
				return Bytes.ofData (bitmapData.getPixels (bitmapData.rect));
			
			default:
				
				return null;
			
		}
		
		return cast (Type.createInstance (className.get (id), []), Bytes);
		
		#elseif html5
		
		var loader = Preloader.loaders.get (path.get (id));
		
		if (loader == null) {
			
			return null;
			
		}
		
		var bytes = loader.bytes;
		
		if (bytes != null) {
			
			return bytes;
			
		} else {
			
			return null;
		}
		
		#else
		
		if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), Bytes);
		else return Bytes.readFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getFont (id:String):Font {
		
		#if flash
		
		var src = Type.createInstance (className.get (id), []);
		
		var font = new Font (src.fontName);
		font.src = src;
		return font;
		
		#elseif html5
		
		return cast (Type.createInstance (className.get (id), []), Font);
		
		#else
		
		if (className.exists (id)) {
			
			var fontClass = className.get (id);
			return cast (Type.createInstance (fontClass, []), Font);
			
		} else {
			
			return Font.fromFile (path.get (id));
			
		}
		
		#end
		
	}
	
	
	public override function getImage (id:String):Image {
		
		#if flash
		
		return Image.fromBitmapData (cast (Type.createInstance (className.get (id), []), BitmapData));
		
		#elseif html5
		
		return Image.fromImageElement (Preloader.images.get (path.get (id)));
		
		#else
		
		if (className.exists (id)) {
			
			var fontClass = className.get (id);
			return cast (Type.createInstance (fontClass, []), Image);
			
		} else {
			
			return Image.fromFile (path.get (id));
			
		}
		
		#end
		
	}
	
	
	/*public override function getMusic (id:String):Dynamic {
		
		#if flash
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif openfl_html5
		
		//var sound = new Sound ();
		//sound.__buffer = true;
		//sound.load (new URLRequest (path.get (id)));
		//return sound;
		return null;
		
		#elseif html5
		
		return null;
		//return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		return null;
		//if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), Sound);
		//else return new Sound (new URLRequest (path.get (id)), null, true);
		
		#end
		
	}*/
	
	
	public override function getPath (id:String):String {
		
		//#if ios
		
		//return SystemPath.applicationDirectory + "/assets/" + path.get (id);
		
		//#else
		
		return path.get (id);
		
		//#end
		
	}
	
	
	public override function getText (id:String):String {
		
		#if html5
		
		var loader = Preloader.loaders.get (path.get (id));
		
		if (loader == null) {
			
			return null;
			
		}
		
		var bytes = loader.bytes;
		
		if (bytes != null) {
			
			return bytes.getString (0, bytes.length);
			
		} else {
			
			return null;
		}
		
		#else
		
		var bytes = getBytes (id);
		
		if (bytes == null) {
			
			return null;
			
		} else {
			
			return bytes.getString (0, bytes.length);
			
		}
		
		#end
		
	}
	
	
	public override function isLocal (id:String, type:String):Bool {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		
		#if flash
		
		//if (requestedType != AssetType.MUSIC && requestedType != AssetType.SOUND) {
			
			return className.exists (id);
			
		//}
		
		#end
		
		return true;
		
	}
	
	
	public override function list (type:String):Array<String> {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		var items = [];
		
		for (id in this.type.keys ()) {
			
			if (requestedType == null || exists (id, type)) {
				
				items.push (id);
				
			}
			
		}
		
		return items;
		
	}
	
	
	public override function loadAudioBuffer (id:String):Future<AudioBuffer> {
		
		var promise = new Promise<AudioBuffer> ();
		
		#if (flash)
		
		if (path.exists (id)) {
			
			var soundLoader = new Sound ();
			soundLoader.addEventListener (Event.COMPLETE, function (event) {
				
				var audioBuffer:AudioBuffer = new AudioBuffer();
				audioBuffer.src = event.currentTarget;
				promise.complete (audioBuffer);
				
			});
			soundLoader.addEventListener (ProgressEvent.PROGRESS, function (event) {
				
				if (event.bytesTotal == 0) {
					
					promise.progress (0);
					
				} else {
					
					promise.progress (event.bytesLoaded / event.bytesTotal);
					
				}
				
			});
			soundLoader.addEventListener (IOErrorEvent.IO_ERROR, promise.error);
			soundLoader.load (new URLRequest (path.get (id)));
			
		} else {
			
			promise.complete (getAudioBuffer (id));
			
		}
		
		#else
		
		promise.completeWith (new Future<AudioBuffer> (function () return getAudioBuffer (id)));
		
		#end
		
		return promise.future;
		
	}
	
	
	public override function loadBytes (id:String):Future<Bytes> {
		
		var promise = new Promise<Bytes> ();
		
		#if flash
		
		if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.dataFormat = flash.net.URLLoaderDataFormat.BINARY;
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bytes = Bytes.ofData (event.currentTarget.data);
				promise.complete (bytes);
				
			});
			loader.addEventListener (ProgressEvent.PROGRESS, function (event) {
				
				if (event.bytesTotal == 0) {
					
					promise.progress (0);
					
				} else {
					
					promise.progress (event.bytesLoaded / event.bytesTotal);
					
				}
				
			});
			loader.addEventListener (IOErrorEvent.IO_ERROR, promise.error);
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			promise.complete (getBytes (id));
			
		}
		
		#elseif html5
		
		if (path.exists (id)) {
			
			var request = new HTTPRequest ();
			promise.completeWith (request.load (path.get (id) + "?" + Assets.cache.version));
			
		} else {
			
			promise.complete (getBytes (id));
			
		}
		
		#else
		
		promise.completeWith (new Future<Bytes> (function () return getBytes (id)));
		
		#end
		
		return promise.future;
		
	}
	
	
	public override function loadImage (id:String):Future<Image> {
		
		var promise = new Promise<Image> ();
		
		#if flash
		
		if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bitmapData = cast (event.currentTarget.content, Bitmap).bitmapData;
				promise.complete (Image.fromBitmapData (bitmapData));
				
			});
			loader.contentLoaderInfo.addEventListener (ProgressEvent.PROGRESS, function (event) {
				
				if (event.bytesTotal == 0) {
					
					promise.progress (0);
					
				} else {
					
					promise.progress (event.bytesLoaded / event.bytesTotal);
					
				}
				
			});
			loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, promise.error);
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			promise.complete (getImage (id));
			
		}
		
		#elseif html5
		
		if (path.exists (id)) {
			
			var image = new js.html.Image ();
			image.onload = function (_):Void {
				
				promise.complete (Image.fromImageElement (image));
				
			}
			image.onerror = promise.error;
			image.src = path.get (id) + "?" + Assets.cache.version;
			
		} else {
			
			promise.complete (getImage (id));
			
		}
		
		#else
		
		promise.completeWith (new Future<Image> (function () return getImage (id)));
		
		#end
		
		return promise.future;
		
	}
	
	
	#if (!flash && !html5)
	private function loadManifest ():Void {
		
		try {
			
			#if blackberry
			var bytes = Bytes.readFile ("app/native/manifest");
			#elseif tizen
			var bytes = Bytes.readFile ("../res/manifest");
			#elseif emscripten
			var bytes = Bytes.readFile ("assets/manifest");
			#elseif (mac && java)
			var bytes = Bytes.readFile ("../Resources/manifest");
			#elseif (ios || tvos)
			var bytes = Bytes.readFile ("assets/manifest");
			#else
			var bytes = Bytes.readFile ("manifest");
			#end
			
			if (bytes != null) {
				
				if (bytes.length > 0) {
					
					var data = bytes.getString (0, bytes.length);
					
					if (data != null && data.length > 0) {
						
						var manifest:Array<Dynamic> = Unserializer.run (data);
						
						for (asset in manifest) {
							
							if (!className.exists (asset.id)) {
								
								#if (ios || tvos)
								path.set (asset.id, "assets/" + asset.path);
								#else
								path.set (asset.id, asset.path);
								#end
								type.set (asset.id, cast (asset.type, AssetType));
								
							}
							
						}
						
					}
					
				}
				
			} else {
				
				trace ("Warning: Could not load asset manifest (bytes was null)");
				
			}
		
		} catch (e:Dynamic) {
			
			trace ('Warning: Could not load asset manifest (${e})');
			
		}
		
	}
	#end
	
	
	public override function loadText (id:String):Future<String> {
		
		var promise = new Promise<String> ();
		
		#if html5
		
		if (path.exists (id)) {
			
			var request = new HTTPRequest ();
			var future = request.load (path.get (id) + "?" + Assets.cache.version);
			future.onProgress (function (progress) promise.progress (progress));
			future.onError (function (msg) promise.error (msg));
			future.onComplete (function (bytes) promise.complete (bytes.getString (0, bytes.length)));
			
		} else {
			
			promise.complete (getText (id));
			
		}
		
		#else
		
		promise.completeWith (loadBytes (id).then (function (bytes) {
			
			return new Future<String> (function () {
				
				if (bytes == null) {
					
					return null;
					
				} else {
					
					return bytes.getString (0, bytes.length);
					
				}
				
			});
			
		}));
		
		#end
		
		return promise.future;
		
	}
	
	
}


#if !display
#if flash

@:keep @:bind #if display private #end class __ASSET__assets_data_data_goes_here_txt extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__assets_images_barbieken_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_barb_arml_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_barb_armr_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_barb_chest_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_barb_footl_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_barb_footr_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_barb_head_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_barb_hips_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_barb_legl_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_barb_legr_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_blush_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_car_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_dolls_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_faces_strip_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_girl1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_girl2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_girl3_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_girl_body_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_girl_caught_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_girl_fingersl_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_girl_fingersr_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_girl_forearm_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_girl_handl_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_girl_handr_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_girl_notcaught_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_house_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_images_go_here_txt extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__assets_images_ken_arml_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ken_armr_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ken_chest_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ken_footl_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ken_footr_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ken_head_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ken_hips_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ken_legl_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_ken_legr_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_mainbg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_mom1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_mom_shock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_outside_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_thoughts_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_images_title_screen_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__assets_music_bgm_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_music_music_goes_here_txt extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_blegh_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_cararrive_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_cardoor_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_carleave_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_confused_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_doorclose_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_dooropen_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_garageopen_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_hehe_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_hmm_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_hmph_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_kissu_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_ooh_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends flash.utils.ByteArray { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_toy1_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_toy2_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_toy3_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_toy4_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_toy5_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_toy6_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_toy7_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__assets_sounds_uh_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends flash.media.Sound { }
@:keep @:bind #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends flash.text.Font { }
@:keep @:bind #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends flash.text.Font { }
@:keep @:bind #if display private #end class __ASSET__flixel_images_ui_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__flixel_images_logo_default_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }


#elseif html5






































































@:keep #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font { public function new () { super (); name = "Nokia Cellphone FC Small"; } } 
@:keep #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font { public function new () { super (); name = "Monsterrat"; } } 




#else



#if (windows || mac || linux || cpp)


@:file("assets/data/data-goes-here.txt") #if display private #end class __ASSET__assets_data_data_goes_here_txt extends lime.utils.Bytes {}
@:image("assets/images/barbieken.png") #if display private #end class __ASSET__assets_images_barbieken_png extends lime.graphics.Image {}
@:image("assets/images/barb_armL.png") #if display private #end class __ASSET__assets_images_barb_arml_png extends lime.graphics.Image {}
@:image("assets/images/barb_armR.png") #if display private #end class __ASSET__assets_images_barb_armr_png extends lime.graphics.Image {}
@:image("assets/images/barb_chest.png") #if display private #end class __ASSET__assets_images_barb_chest_png extends lime.graphics.Image {}
@:image("assets/images/barb_footL.png") #if display private #end class __ASSET__assets_images_barb_footl_png extends lime.graphics.Image {}
@:image("assets/images/barb_footR.png") #if display private #end class __ASSET__assets_images_barb_footr_png extends lime.graphics.Image {}
@:image("assets/images/barb_head.png") #if display private #end class __ASSET__assets_images_barb_head_png extends lime.graphics.Image {}
@:image("assets/images/barb_hips.png") #if display private #end class __ASSET__assets_images_barb_hips_png extends lime.graphics.Image {}
@:image("assets/images/barb_legL.png") #if display private #end class __ASSET__assets_images_barb_legl_png extends lime.graphics.Image {}
@:image("assets/images/barb_legR.png") #if display private #end class __ASSET__assets_images_barb_legr_png extends lime.graphics.Image {}
@:image("assets/images/blush.png") #if display private #end class __ASSET__assets_images_blush_png extends lime.graphics.Image {}
@:image("assets/images/car.png") #if display private #end class __ASSET__assets_images_car_png extends lime.graphics.Image {}
@:image("assets/images/dolls.png") #if display private #end class __ASSET__assets_images_dolls_png extends lime.graphics.Image {}
@:image("assets/images/faces_strip.png") #if display private #end class __ASSET__assets_images_faces_strip_png extends lime.graphics.Image {}
@:image("assets/images/girl1.png") #if display private #end class __ASSET__assets_images_girl1_png extends lime.graphics.Image {}
@:image("assets/images/girl2.png") #if display private #end class __ASSET__assets_images_girl2_png extends lime.graphics.Image {}
@:image("assets/images/girl3.png") #if display private #end class __ASSET__assets_images_girl3_png extends lime.graphics.Image {}
@:image("assets/images/girl_body.png") #if display private #end class __ASSET__assets_images_girl_body_png extends lime.graphics.Image {}
@:image("assets/images/girl_caught.png") #if display private #end class __ASSET__assets_images_girl_caught_png extends lime.graphics.Image {}
@:image("assets/images/girl_fingersL.png") #if display private #end class __ASSET__assets_images_girl_fingersl_png extends lime.graphics.Image {}
@:image("assets/images/girl_fingersR.png") #if display private #end class __ASSET__assets_images_girl_fingersr_png extends lime.graphics.Image {}
@:image("assets/images/girl_forearm.png") #if display private #end class __ASSET__assets_images_girl_forearm_png extends lime.graphics.Image {}
@:image("assets/images/girl_handL.png") #if display private #end class __ASSET__assets_images_girl_handl_png extends lime.graphics.Image {}
@:image("assets/images/girl_handR.png") #if display private #end class __ASSET__assets_images_girl_handr_png extends lime.graphics.Image {}
@:image("assets/images/girl_notcaught.png") #if display private #end class __ASSET__assets_images_girl_notcaught_png extends lime.graphics.Image {}
@:image("assets/images/house.png") #if display private #end class __ASSET__assets_images_house_png extends lime.graphics.Image {}
@:file("assets/images/images-go-here.txt") #if display private #end class __ASSET__assets_images_images_go_here_txt extends lime.utils.Bytes {}
@:image("assets/images/ken_armL.png") #if display private #end class __ASSET__assets_images_ken_arml_png extends lime.graphics.Image {}
@:image("assets/images/ken_armR.png") #if display private #end class __ASSET__assets_images_ken_armr_png extends lime.graphics.Image {}
@:image("assets/images/ken_chest.png") #if display private #end class __ASSET__assets_images_ken_chest_png extends lime.graphics.Image {}
@:image("assets/images/ken_footL.png") #if display private #end class __ASSET__assets_images_ken_footl_png extends lime.graphics.Image {}
@:image("assets/images/ken_footR.png") #if display private #end class __ASSET__assets_images_ken_footr_png extends lime.graphics.Image {}
@:image("assets/images/ken_head.png") #if display private #end class __ASSET__assets_images_ken_head_png extends lime.graphics.Image {}
@:image("assets/images/ken_hips.png") #if display private #end class __ASSET__assets_images_ken_hips_png extends lime.graphics.Image {}
@:image("assets/images/ken_legL.png") #if display private #end class __ASSET__assets_images_ken_legl_png extends lime.graphics.Image {}
@:image("assets/images/ken_legR.png") #if display private #end class __ASSET__assets_images_ken_legr_png extends lime.graphics.Image {}
@:image("assets/images/mainbg.png") #if display private #end class __ASSET__assets_images_mainbg_png extends lime.graphics.Image {}
@:image("assets/images/mom1.png") #if display private #end class __ASSET__assets_images_mom1_png extends lime.graphics.Image {}
@:image("assets/images/mom_shock.png") #if display private #end class __ASSET__assets_images_mom_shock_png extends lime.graphics.Image {}
@:image("assets/images/outside.png") #if display private #end class __ASSET__assets_images_outside_png extends lime.graphics.Image {}
@:image("assets/images/thoughts.png") #if display private #end class __ASSET__assets_images_thoughts_png extends lime.graphics.Image {}
@:image("assets/images/title_screen.png") #if display private #end class __ASSET__assets_images_title_screen_png extends lime.graphics.Image {}
@:file("assets/music/bgm.mp3") #if display private #end class __ASSET__assets_music_bgm_mp3 extends lime.utils.Bytes {}
@:file("assets/music/music-goes-here.txt") #if display private #end class __ASSET__assets_music_music_goes_here_txt extends lime.utils.Bytes {}
@:file("assets/sounds/blegh.mp3") #if display private #end class __ASSET__assets_sounds_blegh_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/cararrive.mp3") #if display private #end class __ASSET__assets_sounds_cararrive_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/cardoor.mp3") #if display private #end class __ASSET__assets_sounds_cardoor_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/carleave.mp3") #if display private #end class __ASSET__assets_sounds_carleave_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/confused.mp3") #if display private #end class __ASSET__assets_sounds_confused_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/doorclose.mp3") #if display private #end class __ASSET__assets_sounds_doorclose_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/dooropen.mp3") #if display private #end class __ASSET__assets_sounds_dooropen_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/garageopen.mp3") #if display private #end class __ASSET__assets_sounds_garageopen_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/hehe.mp3") #if display private #end class __ASSET__assets_sounds_hehe_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/hmm.mp3") #if display private #end class __ASSET__assets_sounds_hmm_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/hmph.mp3") #if display private #end class __ASSET__assets_sounds_hmph_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/kissu.mp3") #if display private #end class __ASSET__assets_sounds_kissu_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/ooh.mp3") #if display private #end class __ASSET__assets_sounds_ooh_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/sounds-go-here.txt") #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends lime.utils.Bytes {}
@:file("assets/sounds/toy1.mp3") #if display private #end class __ASSET__assets_sounds_toy1_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/toy2.mp3") #if display private #end class __ASSET__assets_sounds_toy2_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/toy3.mp3") #if display private #end class __ASSET__assets_sounds_toy3_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/toy4.mp3") #if display private #end class __ASSET__assets_sounds_toy4_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/toy5.mp3") #if display private #end class __ASSET__assets_sounds_toy5_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/toy6.mp3") #if display private #end class __ASSET__assets_sounds_toy6_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/toy7.mp3") #if display private #end class __ASSET__assets_sounds_toy7_mp3 extends lime.utils.Bytes {}
@:file("assets/sounds/uh.mp3") #if display private #end class __ASSET__assets_sounds_uh_mp3 extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/flixel/4,3,0/assets/sounds/beep.mp3") #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends lime.utils.Bytes {}
@:file("C:/HaxeToolkit/haxe/lib/flixel/4,3,0/assets/sounds/flixel.mp3") #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends lime.utils.Bytes {}
@:font("C:/HaxeToolkit/haxe/lib/flixel/4,3,0/assets/fonts/nokiafc22.ttf") #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font {}
@:font("C:/HaxeToolkit/haxe/lib/flixel/4,3,0/assets/fonts/monsterrat.ttf") #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font {}
@:image("C:/HaxeToolkit/haxe/lib/flixel/4,3,0/assets/images/ui/button.png") #if display private #end class __ASSET__flixel_images_ui_button_png extends lime.graphics.Image {}
@:image("C:/HaxeToolkit/haxe/lib/flixel/4,3,0/assets/images/logo/default.png") #if display private #end class __ASSET__flixel_images_logo_default_png extends lime.graphics.Image {}



#end
#end

#if (openfl && !flash)
@:keep #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { var font = new __ASSET__flixel_fonts_nokiafc22_ttf (); src = font.src; name = font.name; super (); }}
@:keep #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { var font = new __ASSET__flixel_fonts_monsterrat_ttf (); src = font.src; name = font.name; super (); }}

#end

#end