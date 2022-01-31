module LL = Leaflet_low

type 'a evented = 'a LL.evented
type 'a layer = 'a LL.layer
type 'a event = 'a LL.event
type 'a path = 'a Leaflet_low.path
type 'a polyline = 'a Leaflet_low.polyline
type map = LL.map
type 'a tile = 'a LL.tile
type marker = LL.marker
type mouse = LL.mouse
type location = LL.location
type dragend = LL.dragend

module Zoom = LL.Zoom

module LatLng = struct
  type t = LL.LatLng.t

  let v ?alt lat lng =
    match alt with
    | None -> LL.LatLng.create lat lng
    | Some alt -> LL.LatLng.create_alt lat lng alt

  let distance_to = LL.LatLng.distance_to
  let equals = LL.LatLng.equals
  let lat = LL.LatLng.lat
  let lng = LL.LatLng.lng
  let alt = LL.LatLng.alt
end

module LatLngBounds = LL.LatLngBounds

module Point = struct
  type t = LL.Point.t

  let v = LL.Point.create
  let distance_to = LL.Point.distance_to
end

module Icon = LL.Icon
module Event = LL.Event
module MouseEvent = LL.MouseEvent
module DragendEvent = LL.DragendEvent
module LocationEvent = LL.LocationEvent

module Evt = struct
  type 'a t =
    | Click : MouseEvent.t t
    | DblClick : MouseEvent.t t
    | MouseMove : MouseEvent.t t
    | Location : LocationEvent.t t
    | MoveStart : unit Event.t t
    | Move : unit Event.t t
    | MoveEnd : unit Event.t t
    | DragStart : unit Event.t t
    | Drag : unit Event.t t
    | DragEnd : DragendEvent.t t

  let id : type a. a t -> string = function
    | Click -> "click"
    | DblClick -> "dblclick"
    | MouseMove -> "mousemove"
    | Location -> "location"
    | MoveStart -> "movestart"
    | Move -> "move"
    | MoveEnd -> "moveend"
    | DragStart -> "dragstart"
    | Drag -> "drag"
    | DragEnd -> "dragend"

  let click = Click
  let dblclick = DblClick
  let mousemove = MouseMove
  let location = Location
  let movestart = MoveStart
  let move = Move
  let moveend = MoveEnd
  let dragstart = DragStart
  let drag = Drag
  let dragend = DragEnd
end

module Evented = struct
  type 'a t = 'a LL.evented

  let to_mouseevt f ojs = f @@ MouseEvent.t_of_js ojs
  let to_locevt f ojs = f @@ LocationEvent.t_of_js ojs
  let to_unitevt f ojs = f @@ Event.t_of_js Ojs.unit_of_js ojs
  let to_dragendevt f ojs = f @@ DragendEvent.t_of_js ojs

  let on : type a. a Evt.t -> (a -> unit) -> 'b t -> unit =
   fun evt f t ->
    let a = LL.Evented.on t (Evt.id evt) in
    match evt with
    | Click -> a @@ to_mouseevt f
    | DblClick -> a @@ to_mouseevt f
    | MouseMove -> a @@ to_mouseevt f
    | Location -> a @@ to_locevt f
    | MoveStart -> a @@ to_unitevt f
    | Move -> a @@ to_unitevt f
    | MoveEnd -> a @@ to_unitevt f
    | DragStart -> a @@ to_unitevt f
    | Drag -> a @@ to_unitevt f
    | DragEnd -> a @@ to_dragendevt f
end

module Layer = struct
  type 'a t = 'a LL.Layer.t

  let remove = LL.Layer.remove
end

module Path = LL.Path

module Polyline = struct
  type 'a t = 'a LL.Polyline.t

  module Options = struct
    type t = LL.Polyline.Options.t

    let v = LL.Polyline.Options.create
    let empty = v ()
  end

  let line ?(opts = Options.empty) line = LL.Polyline.polyline line opts
  let polygon ?(opts = Options.empty) line = LL.Polyline.polygon line opts
  let rectangle ?(opts = Options.empty) line = LL.Polyline.rectangle line opts
  let set_lat_lngs pos t = LL.Polyline.set_lat_lngs t pos
  let is_empty = LL.Polyline.is_empty
  let get_lat_lngs = LL.Polyline.get_lat_lngs
  let get_center = LL.Polyline.get_center
  let add_lat_lng pos t = LL.Polyline.add_lat_lng t pos
end

module CircleOptions = struct
  type t = LL.CircleOptions.t

  let v = LL.CircleOptions.create
  let empty = v ()
end

module CircleMarker = struct
  type 'a t = 'a LL.CircleMarker.t

  let circle_marker ?(opts = CircleOptions.empty) pos =
    LL.CircleMarker.circle_marker pos opts

  let set_lat_lng pos t = LL.CircleMarker.set_lat_lng t pos
  let get_lat_lng = LL.CircleMarker.get_lat_lng
  let set_radius rad t = LL.CircleMarker.set_radius t rad
  let get_radius = LL.CircleMarker.get_radius
end

module Circle = struct
  type t = LL.Circle.t

  let circle ?(opts = CircleOptions.empty) pos = LL.Circle.circle pos opts
  let get_bounds = LL.Circle.get_bounds
end

module Map = struct
  type t = LL.Map.t

  module Options = struct
    type t = LL.Map.Options.t

    let v = LL.Map.Options.create
    let empty = v ()
  end

  let map ?(opts = Options.empty) id = LL.Map.map id opts
  let add_layer layer map = LL.Map.add_layer map layer
  let set_view ~pos ~zoom map = LL.Map.set_view map pos zoom
  let fly_to pos zoom map = LL.Map.fly_to map pos zoom
  let pan_to pos zoom map = LL.Map.pan_to map pos zoom
  let center = LL.Map.get_center
  let zoom = LL.Map.get_zoom
end

module LayerEvent = LL.LayerEvent

module TileLayer = struct
  type 'a t = 'a LL.TileLayer.t

  module Options = struct
    type t = LL.TileLayer.Options.t

    let v = LL.TileLayer.Options.create
    let empty = v ()
  end

  let v ?(opts = Options.empty) url = LL.TileLayer.tile_layer url opts
end

module WmsLayer = struct
  type t = LL.WmsLayer.t

  module Options = struct
    type t = LL.WmsLayer.Options.t

    let v = LL.WmsLayer.Options.create
    let empty = v ()
  end

  let v ?(opts = Options.empty) url = LL.WmsLayer.wms url opts
end

module Marker = struct
  type t = LL.Marker.t

  module Options = struct
    type t = LL.Marker.Options.t

    let v = LL.Marker.Options.create
    let empty = v ()
  end

  let v ?(opts = Options.empty) latlng = LL.Marker.marker latlng opts
end
