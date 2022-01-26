module LL = Leaflet_low

type 'a evented = 'a LL.evented
type 'a layer = 'a LL.layer
type 'a event = 'a LL.event
type map = LL.map
type tile = LL.tile
type marker = LL.marker
type mouse = LL.mouse
type location = LL.location

module Zoom = LL.Zoom

module LatLng = struct
  type t = LL.LatLng.t

  let v ?alt lat lon =
    match alt with
    | None -> LL.LatLng.create ~lat ~lon ()
    | Some alt -> LL.LatLng.create ~lat ~lon ~alt ()

  let distance_to = LL.LatLng.distance_to
end

module Point = struct
  type t = LL.Point.t

  let v = LL.Point.create
  let distance_to = LL.Point.distance_to
end

module Icon = LL.Icon
module Event = LL.Event
module MouseEvent = LL.MouseEvent
module LocationEvent = LL.LocationEvent

module Evt = struct
  type 'a t =
    | Click : MouseEvent.t t
    | DblClick : MouseEvent.t t
    | Location : LocationEvent.t t
    | Move : unit Event.t t

  let id : type a. a t -> string = function
    | Click -> "click"
    | DblClick -> "dblclick"
    | Location -> "location"
    | Move -> "move"

  let click = Click
  let dblclick = DblClick
  let location = Location
  let move = Move
end

module Evented = struct
  type 'a t = 'a LL.evented

  let to_mouseevt f ojs = f @@ MouseEvent.t_of_js ojs
  let to_locevt f ojs = f @@ LocationEvent.t_of_js ojs
  let to_unitevt f ojs = f @@ Event.t_of_js Ojs.unit_of_js ojs

  let on : type a. a Evt.t -> (a -> unit) -> 'b t -> unit =
   fun evt f t ->
    let a = LL.Evented.on t (Evt.id evt) in
    match evt with
    | Click -> a @@ to_mouseevt f
    | DblClick -> a @@ to_mouseevt f
    | Location -> a @@ to_locevt f
    | Move -> a @@ to_unitevt f
end

module rec Map : sig
  type t = LL.Map.t

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
end = struct
  type t = LL.Map.t

  module Options = struct
    type t = LL.Map.Options.t

    let v = LL.Map.Options.create
  end

  let map ?options id =
    match options with
    | Some opts -> LL.Map.map id opts
    | None -> LL.Map.map id (LL.Map.Options.create ())

  let add_layer layer map = LL.Map.add_layer map layer
  let set_view ~pos ~zoom map = LL.Map.set_view map pos zoom
  let fly_to pos zoom map = LL.Map.fly_to map pos zoom
end

and Layer : sig
  type 'a t = 'a LL.Layer.t

  val add_to : map:Map.t -> 'a t -> unit
  val remove : 'a t -> unit
  val remove_from : 'a t -> Map.t -> unit
end = struct
  type 'a t = 'a LL.Layer.t

  let add_to ~map t = LL.Layer.add_to t map
  let remove = LL.Layer.remove
  let remove_from = LL.Layer.remove_from
end

module LayerEvent = LL.LayerEvent
module TileLayer = LL.TileLayer

module Marker = struct
  type t = LL.Marker.t
  type opts = LL.Marker.options

  let opts = LL.Marker.opts

  let v ?options latlng =
    match options with
    | None -> LL.Marker.marker latlng (opts ())
    | Some options -> LL.Marker.marker latlng options
end
