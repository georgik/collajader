package com.sinusgear.scenes
{
	import alternativa.engine3d.containers.ConflictContainer;
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Vertex;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.loaders.ParserCollada;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.Box;
	
	import flash.display.BitmapData;
	import flash.display.Scene;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.sampler.NewObjectSample;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	public class SampleScene extends Sprite
	{
		
		public var data:XML;
		public function SampleScene()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public var camera:Camera3D = new Camera3D();
		public var container:ConflictContainer = new ConflictContainer();
		public var controller:SimpleObjectController;
		public var isOrbitEnabled:Boolean = false;
		public var scaleFactor:int = 200;
		public var cameraScaleFactor:int = 40;

		
		public var vector:Vector3D = new Vector3D();
		public var focusBox:Box;
		
		
		public function init(event:Event):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			
			
			camera.view = new View(800,400);
			this.addChild(camera.view);
			camera.x = -900;
			camera.y = -950;
			camera.z = 100;
			camera.rotationX = -1.7;
			camera.rotationZ = -1.1;
			//camera.view.hideLogo();
			
			this.focusBox = new Box();
			var material:FillMaterial = new FillMaterial(0x909090);
			focusBox.setMaterialToAllFaces(material);
			//container.addChild(box);

			
			container.addChild(camera);
			
			//this.controller = new SimpleObjectController(this.parent, this.camera, 200);
			this.controller = new SimpleObjectController(this.parent, this.focusBox, 200);
			
			this.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
		}
		
		[Bindable]
		public var nodes:ArrayCollection = new ArrayCollection();
		
		public function scaleObject(child:Object3D):void
		{
			child.scaleX = this.scaleFactor;
			child.scaleY = this.scaleFactor;
			child.scaleZ = this.scaleFactor;
			
		}
		
		
		public function set controlObject(obj:Object3D):void
		{
			this.controller.object = obj;
		}
		
		public var glowFilter:GlowFilter = new  GlowFilter(0x904020);
		
		public function highlight(obj:Object3D):void
		{
			if (!obj.filters)
			{
				obj.filters = [];
			}
			if (obj.filters.length == 0)
			{
				obj.filters.push(this.glowFilter);
				
			}
		}

		public function deselectAll():void
		{
			for each (var oldChild:Object3D in this.nodes)
			{
				if (oldChild.filters)
				{
					if (oldChild.filters.length > 0)
					{
						oldChild.filters.pop();
					}
				}
			}
		}
		
		public function loadData(textData:String):void
		{
			for each (var oldChild:Object3D in this.nodes)
			{
				container.removeChild(oldChild);
			}
			this.nodes.removeAll();
			
			var parser:ParserCollada = new ParserCollada();
			parser.parse(XML(textData));
			for each (var child:Object3D in parser.hierarchy)
			{
				this.scaleObject(child);
				this.nodes.addItem(child);
				container.addChild(child);
				
			}

		}
		
		public function enterFrameHandler(event:Event):void
		{
			
			if (this.isOrbitEnabled)
			{
				var v:Vector3D = this.focusBox.localToGlobal(new Vector3D(50,50,50));
				this.camera.x = v.x * this.cameraScaleFactor ;
				this.camera.y = v.y * this.cameraScaleFactor ;
				this.camera.z = v.z * this.cameraScaleFactor ;
				this.camera.lookAt(0,0,0);
			}
			this.controller.update();
			camera.render();
		}
	}
}