type 'a evented = 'a Leaflet_low.evented
type 'a layer = 'a Leaflet_low.layer
type 'a event = 'a Leaflet_low.event
type 'a path = 'a Leaflet_low.path
type 'a polyline = 'a Leaflet_low.polyline
type map = Leaflet_low.map
type tile = Leaflet_low.tile
type marker = Leaflet_low.marker
type mouse = Leaflet_low.mouse
type location = Leaflet_low.location
type dragend = Leaflet_low.dragend

module Zoom : sig
  type t = int
end

module Point : sig
  type t

  val v : x:int -> y:int -> t
  val distance_to : t -> t -> float
end

module LatLng : sig
  type t

  val v : ?alt:float -> float -> float -> t
  val distance_to : t -> t -> float
  val equals : t -> t -> bool
  val lat : t -> float
  val lng : t -> float
  val alt : t -> float option
end

module LatLngBounds : sig
  type t

  val lat_lng_bounds : LatLng.t -> LatLng.t -> t
end

module Icon : sig
  type t

  val create :
    ?icon_url:string ->
    ?icon_size:Point.t ->
    ?icon_anchor:Point.t ->
    ?shadow_url:string ->
    ?class_name:string ->
    unit ->
    t
end

module Event : sig
  type 'a t = 'a event

  val type_ : 'a t -> string
end

module MouseEvent : sig
  type t = mouse event

  val latlng : t -> LatLng.t
  val layer_point : t -> Point.t
  val container_point : t -> Point.t
end

module DragendEvent : sig
  type t = dragend event

  val distance : t -> float
end

module LocationEvent : sig
  type t = location event

  val latlng : t -> LatLng.t
  val accuracy : t -> float
  val altitude : t -> float
  val altitude_accuracy : t -> float
  val heading : t -> float
  val speed : t -> float
  val timestamp : t -> float
end

module Evt : sig
  type 'a t

  val click : MouseEvent.t t
  val dblclick : MouseEvent.t t
  val mousemove : MouseEvent.t t
  val location : LocationEvent.t t
  val movestart : unit Event.t t
  val move : unit Event.t t
  val moveend : unit Event.t t
  val dragstart : unit Event.t t
  val drag : unit Event.t t
  val dragend : DragendEvent.t t
end

module Evented : sig
  type 'a t = 'a Leaflet_low.evented

  val on : 'a Evt.t -> ('a -> unit) -> 'b t -> unit
end

module Layer : sig
  type 'a t = 'a Leaflet_low.Layer.t

  val remove : 'a t -> unit
end

module Path : sig
  type 'a t = 'a path layer evented

  val redraw : 'a t -> unit
end

module Polyline : sig
  type 'a t = 'a Leaflet_low.Polyline.t

  module Options : sig
    type t

    val v :
      ?stroke:bool ->
      ?color:string ->
      ?weight:int ->
      ?opacity:float ->
      ?line_cap:string ->
      ?line_join:string ->
      ?dash_array:string ->
      ?dash_offset:string ->
      ?fill:bool ->
      ?fill_color:string ->
      ?fill_opacity:float ->
      ?fill_rule:string ->
      ?smooth_factor:float ->
      ?no_clip:bool ->
      unit ->
      t

    val empty : t
  end

  val line : ?opts:Options.t -> LatLng.t list -> unit t
  val polygon : ?opts:Options.t -> LatLng.t list -> unit t [@@js.global]
  val rectangle : ?opts:Options.t -> LatLng.t list -> unit t [@@js.global]
  val set_lat_lngs : LatLng.t list -> 'a t -> 'a t [@@js.call]
  val is_empty : 'a t -> bool [@@js.call]
  val get_lat_lngs : 'a t -> LatLng.t list [@@js.call]
  val get_center : 'a t -> LatLng.t [@@js.call]
  val add_lat_lng : LatLng.t -> 'a t -> 'a t [@@js.call]
end

module CircleOptions : sig
  type t

  val v :
    ?radius:float ->
    ?stroke:bool ->
    ?color:string ->
    ?weight:int ->
    ?opacity:float ->
    ?line_cap:string ->
    ?line_join:string ->
    ?dash_array:string ->
    ?dash_offset:string ->
    ?fill:bool ->
    ?fill_color:string ->
    ?fill_opacity:float ->
    ?fill_rule:string ->
    ?smooth_factor:float ->
    ?no_clip:bool ->
    unit ->
    t

  val empty : t
end

module CircleMarker : sig
  type 'a t = 'a Leaflet_low.CircleMarker.t

  val circle_marker : ?opts:CircleOptions.t -> LatLng.t -> unit t
  val set_lat_lng : LatLng.t -> 'a t -> 'a t
  val get_lat_lng : 'a t -> LatLng.t
  val set_radius : float -> 'a t -> 'a t
  val get_radius : 'a t -> float
end

module Circle : sig
  type t = Leaflet_low.Circle.t

  val circle : ?opts:CircleOptions.t -> LatLng.t -> t
  val get_bounds : t -> LatLngBounds.t
end

module Map : sig
  type t = Leaflet_low.Map.t

  module Options : sig
    type t

    val v :
      ?zoom:Zoom.t ->
      ?center:LatLng.t ->
      ?zoomControl:bool ->
      ?dragging:bool ->
      unit ->
      t

    val empty : t
  end

  val map : ?opts:Options.t -> string -> t
  val add_layer : 'a Layer.t -> t -> t
  val set_view : pos:LatLng.t -> zoom:Zoom.t -> t -> t
  val fly_to : LatLng.t -> Zoom.t -> t -> t
  val pan_to : LatLng.t -> Zoom.t -> t -> t
  val center : t -> LatLng.t
  val zoom : t -> int
end

module TileLayer : sig
  type t = Leaflet_low.TileLayer.t

  val tile_layer : string -> t
end

module Marker : sig
  type t = Leaflet_low.Marker.t

  module Options : sig
    type t

    val v :
      ?keyboard:bool ->
      ?title:string ->
      ?alt:string ->
      ?opacity:float ->
      ?icon:Icon.t ->
      ?draggable:bool ->
      ?rise_on_hover:bool ->
      ?rise_offset:bool ->
      ?pane:string ->
      ?shadow_pane:string ->
      ?bubbling_mouse_events:bool ->
      unit ->
      t

    val empty : t
  end

  val v : ?opts:Options.t -> LatLng.t -> t
end
