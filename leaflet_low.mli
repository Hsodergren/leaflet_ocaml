type 'a evented
type 'a layer
type 'a event
type 'a path
type 'a polyline
type map
type 'a tile
type marker
type wms
type mouse
type location
type dragend
type 'a circlemarker
type circle

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

  val create : float -> float -> t [@@js.global "latLng"]
  val create_alt : float -> float -> float -> t [@@js.global "latLng"]
  val distance_to : t -> t -> float [@@js.call]
  val lat : t -> float [@@js.get]
  val lng : t -> float [@@js.get]
  val alt : t -> float option [@@js.get]
  val equals : t -> t -> bool [@@js.call]
end
[@@js.scope "L"]

module LatLngBounds : sig
  type t

  val lat_lng_bounds : LatLng.t -> LatLng.t -> t [@@js.global]
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

  val t_to_js : ('a -> Ojs.t) -> 'a t -> Ojs.t
  val t_of_js : (Ojs.t -> 'a) -> Ojs.t -> 'a t
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

module DragendEvent : sig
  type t = dragend event

  val t_of_js : Ojs.t -> t
  val t_to_js : t -> Ojs.t
  val distance : t -> float [@@js.get]
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

module Evented : sig
  type 'a t = 'a evented

  val on : 'a t -> string -> (Ojs.t -> unit) -> unit [@@js.call]
end

module Layer : sig
  type 'a t = 'a layer evented

  val t_to_js : ('a -> Ojs.t) -> 'a t -> Ojs.t
  val t_of_js : (Ojs.t -> 'a) -> Ojs.t -> 'a t
  val remove : 'a t -> unit [@@js.call]
end
[@@js.scope "L"]

module Path : sig
  type 'a t = 'a path layer evented

  val redraw : 'a t -> unit [@@js.call]
end

module Polyline : sig
  type 'a t = 'a polyline Path.t

  module Options : sig
    type t

    val create :
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
      [@@js.builder]
  end

  val polyline : LatLng.t list -> Options.t -> unit t [@@js.global]
  val polygon : LatLng.t list -> Options.t -> unit t [@@js.global]
  val rectangle : LatLng.t list -> Options.t -> unit t [@@js.global]
  val set_lat_lngs : 'a t -> LatLng.t list -> 'a t [@@js.call]
  val is_empty : 'a t -> bool [@@js.call]
  val get_lat_lngs : 'a t -> LatLng.t list [@@js.call]
  val get_center : 'a t -> LatLng.t [@@js.call]
  val add_lat_lng : 'a t -> LatLng.t -> 'a t [@@js.call]
end
[@@js.scope "L"]

module CircleOptions : sig
  type t

  val create :
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
    [@@js.builder]
end

module CircleMarker : sig
  type 'a t = 'a circlemarker Path.t

  val circle_marker : LatLng.t -> CircleOptions.t -> unit t [@@js.global]
  val set_lat_lng : 'a t -> LatLng.t -> 'a t [@@js.call]
  val get_lat_lng : 'a t -> LatLng.t [@@js.call]
  val set_radius : 'a t -> float -> 'a t [@@js.call]
  val get_radius : 'a t -> float [@@js.call]
end
[@@js.scope "L"]

module Circle : sig
  type t = circle CircleMarker.t

  val circle : LatLng.t -> CircleOptions.t -> t [@@js.global]
  val get_bounds : t -> LatLngBounds.t [@@js.call]
end
[@@js.scope "L"]

module Map : sig
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
  val add_layer : t -> 'a Layer.t -> t [@@js.call]
  val set_view : t -> LatLng.t -> Zoom.t -> t [@@js.call]
  val fly_to : t -> LatLng.t -> Zoom.t -> t [@@js.call]
  val pan_to : t -> LatLng.t -> Zoom.t -> t [@@js.call]
  val get_center : t -> LatLng.t [@@js.call]
  val get_zoom : t -> int [@@js.call]
end
[@@js.scope "L"]

module LayerEvent : sig
  type 'a t = 'a layer Event.t

  val layer : 'a t -> 'a Layer.t [@@js.get]
end

module TileLayer : sig
  type 'a t = 'a tile layer evented

  module Options : sig
    type t

    val create :
      ?min_zoom:Zoom.t ->
      ?max_zoom:Zoom.t ->
      ?subdomains:string list ->
      ?error_tile_url:string ->
      ?zoom_offset:Zoom.t ->
      ?tms:bool ->
      ?zoom_reverse:bool ->
      ?detect_retina:bool ->
      ?cross_origin:string ->
      unit ->
      t
      [@@js.builder]
  end

  val tile_layer : string -> Options.t -> 'a t [@@js.global]
end
[@@js.scope "L"]

module WmsLayer : sig
  type t = wms TileLayer.t

  module Options : sig
    type t

    val create :
      ?layers:string ->
      ?styles:string ->
      ?format:string ->
      ?transparent:bool ->
      ?version:string ->
      ?uppercase:bool ->
      ?min_zoom:Zoom.t ->
      ?max_zoom:Zoom.t ->
      ?subdomains:string list ->
      ?error_tile_url:string ->
      ?zoom_offset:Zoom.t ->
      ?tms:bool ->
      ?zoom_reverse:bool ->
      ?detect_retina:bool ->
      ?cross_origin:string ->
      unit ->
      t
      [@@js.builder]
  end

  val wms : string -> Options.t -> t [@@js.global]
end
[@@js.scope "L"]

module Marker : sig
  type t = marker layer evented

  module Options : sig
    type t

    val create :
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
      [@@js.builder]
  end

  val marker : LatLng.t -> Options.t -> t [@@js.global]
end
[@@js.scope "L"]
