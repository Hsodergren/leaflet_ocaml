type 'a evented = 'a Leaflet_low.evented
type 'a layer = 'a Leaflet_low.layer
type 'a event = 'a Leaflet_low.event
type map = Leaflet_low.map
type tile = Leaflet_low.tile
type marker = Leaflet_low.marker
type mouse = Leaflet_low.mouse
type location = Leaflet_low.location

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
  val location : LocationEvent.t t
  val move : unit Event.t t
end

module Evented : sig
  type 'a t = 'a Leaflet_low.evented

  val on : 'a Evt.t -> ('a -> unit) -> 'b t -> unit
end

module Layer : sig
  type 'a t = 'a Leaflet_low.Layer.t

  val remove : 'a t -> unit
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
  end

  val map : ?options:Options.t -> string -> t
  val add_layer : 'a Layer.t -> t -> unit
  val set_view : pos:LatLng.t -> zoom:Zoom.t -> t -> unit
  val fly_to : LatLng.t -> Zoom.t -> t -> unit
  val pan_to : LatLng.t -> Zoom.t -> t -> unit
  val center : t -> LatLng.t
  val zoom : t -> int
end

(* module LayerEvent : sig *)
(*   type t *)

(*   val layer : t -> 'a Layer.t *)
(* end *)

module TileLayer : sig
  type t = Leaflet_low.TileLayer.t

  val tile_layer : string -> t
end

module Marker : sig
  type t = Leaflet_low.Marker.t
  type opts

  val opts :
    ?keyboard:bool ->
    ?title:string ->
    ?alt:string ->
    ?opacity:float ->
    ?icon:Icon.t ->
    unit ->
    opts

  val v : ?options:opts -> LatLng.t -> t
end
