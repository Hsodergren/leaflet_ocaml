type 'a evented
type 'a layer
type 'a event
type map
type tile
type marker
type mouse
type location

val log : string -> unit [@@js.global "console.log"]

module Zoom : sig
  type t = int
end

module Point : sig
  type t

  val create : x:int -> y:int -> t [@@js.builder]
  val distance_to : t -> t -> float [@@js.call]
end
[@@js.scope "L"]

module LatLng : sig
  type t

  val create : ?alt:float -> lat:float -> lon:float -> unit -> t [@@js.builder]
  val distance_to : t -> t -> float [@@js.call]
end
[@@js.scope "L"]

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
    [@@js.builder]
end

module Event : sig
  type 'a t = 'a event

  val type_ : 'a t -> string [@@js.get "type"]
end

module MouseEvent : sig
  type t = mouse event

  val t_of_js : Ojs.t -> t
  val t_to_js : t -> Ojs.t
  val latlng : t -> LatLng.t [@@js.get]
  val layer_point : t -> Point.t [@@js.get]
  val container_point : t -> Point.t [@@js.get]
end

module LocationEvent : sig
  type t = location event

  val t_of_js : Ojs.t -> t
  val t_to_js : t -> Ojs.t
  val latlng : t -> LatLng.t [@@js.get]
  val accuracy : t -> float [@@js.get]
  val altitude : t -> float [@@js.get]
  val altitude_accuracy : t -> float [@@js.get]
  val heading : t -> float [@@js.get]
  val speed : t -> float [@@js.get]
  val timestamp : t -> float [@@js.get]
end

(* module Evt : sig *)
(*   type 'a t = *)
(*     | Click : MouseEvent.t t [@js "click"] *)
(*     | DblClick : MouseEvent.t t [@js "dblclick"] *)
(*     | LocationFound : LocationEvent.t t [@js "locationfound"] *)
(*   [@@js.sum] *)

(*   (\* val t_to_js : ('a -> Ojs.t) -> 'a t -> Ojs.t *\) *)
(*   (\* val t_of_js : (Ojs.t -> 'a) -> Ojs.t -> 'a t *\) *)
(* end *)

module Evented : sig
  type 'a t = 'a evented

  val on : 'a t -> string -> (Ojs.t -> unit) -> unit [@@js.call]
end

module rec Map : sig
  type t = map evented

  val t_of_js : Ojs.t -> t
  val t_to_js : t -> Ojs.t

  module Options : sig
    type t

    val create :
      ?zoom:Zoom.t ->
      ?center:LatLng.t ->
      ?zoomControl:bool ->
      ?dragging:bool ->
      unit ->
      t
      [@@js.builder]
  end

  val map : string -> Options.t -> t [@@js.global]
  val add_layer : t -> 'a Layer.t -> unit [@@js.call]
  val set_view : t -> LatLng.t -> Zoom.t -> unit [@@js.call]
  val fly_to : t -> LatLng.t -> Zoom.t -> unit [@@js.call]
end
[@@js.scope "L"]

and Layer : sig
  type 'a t = 'a layer evented

  val t_to_js : ('a -> Ojs.t) -> 'a t -> Ojs.t
  val t_of_js : (Ojs.t -> 'a) -> Ojs.t -> 'a t
  val add_to : 'a t -> Map.t -> unit [@@js.call]
  val remove : 'a t -> unit [@@js.call]
  val remove_from : 'a t -> Map.t -> unit [@@js.call]
end
[@@js.scope "L"]

module LayerEvent : sig
  type 'a t = 'a layer Event.t

  val layer : 'a t -> 'a Layer.t [@@js.get]
end

module TileLayer : sig
  type t = tile layer evented

  val tile_layer : string -> t [@@js.global]
end
[@@js.scope "L"]

module Marker : sig
  type t = marker layer evented
  type options

  val opts :
    ?keyboard:bool ->
    ?title:string ->
    ?alt:string ->
    ?opacity:float ->
    ?icon:Icon.t ->
    unit ->
    options
    [@@js.builder]

  val marker : LatLng.t -> options -> t [@@js.global]
end
[@@js.scope "L"]
