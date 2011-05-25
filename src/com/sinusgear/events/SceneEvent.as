package com.sinusgear.events
{
	import flash.events.Event;
	
	public class SceneEvent extends Event
	{
		/**
		 * Indicate that scene is ready.
		 */
		public static const SCENE_READY:String = "sceneReady";
		
		public function SceneEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}