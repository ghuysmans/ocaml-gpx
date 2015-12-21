(** GPX schema version 1.1 *)

(* For more information on GPX and this schema,
   visit http://www.topografix.com/gpx.asp GPX uses the following conventions:
   all coordinates are relative to the WGS84 datum. All measurements are in
   metric units. *)

(** This library is based on Xml-light.
    Metadata and extensions are represented as [Xml.xml],
    from Xml-light library. *)

module X :
  sig
    type t = Node of Xmlm.tag * t list | Data of string

    val node : string -> (string * string) list -> t list -> t
    val pcdata : string -> t
    val tag_is : string -> t -> bool
    val get_pcdata : t -> string
    val get_attr : string -> t -> string
    val childs : t -> t list

    val to_xmlm : ?dtd:string -> t -> Xmlm.output -> unit
    val of_xmlm : Xmlm.input -> Xmlm.dtd * t

    val to_buffer :
      ?ns_prefix:(string -> string option) -> t ->
      Buffer.t -> unit

    val to_string :
      ?ns_prefix:(string -> string
      option) -> t -> string

    val of_string : string -> t
end

type gpx =
  {
    version    : string; (* Must be 1.1 *)
    creator    : string;
    metadata   : metadata option;
    wpt        : wpt list;
    rte        : rte list;
    trk        : trk list;
    extensions : extension option;
  }

and metadata =
  {
    name       : string option;
    desc       : string option;
    author     : person option;
    copyright  : copyright option;
    link       : link list;
    time       : date_time option;
    keywords   : string option;
    bounds     : bounds option;
    extensions : extension option;
  }

and wpt =
  {
    lat           : latitude;
    lon           : longitude;
    time          : date_time option;
    ele           : float option;
    magvar        : degrees option;
    geoidheight   : float option;
    name          : string option;
    cmt           : string option;
    desc          : string option;
    src           : string option;
    link          : link list;
    sym           : string option;
    typ           : string option;
    fix           : fix option;
    sat           : int option;
    vdop          : float option;
    hdop          : float option;
    pdop          : float option;
    ageofdgpsdata : float option;
    dgpsid        : dgps_station option;
    extensions    : extension option;
  }

and rte =
  {
    name       : string option;
    cmt        : string option;
    desc       : string option;
    src        : string option;
    link       : link list;
    number     : int option;
    typ        : string option;
    extensions : extension option;
    rtept      : wpt list;
  }

and trk =
  {
    name       : string option;
    cmt        : string option;
    desc       : string option;
    src        : string option;
    link       : link list;
    number     : int option;
    typ        : string option;
    extensions : extension option;
    trkseg     : trkseg list;
  }

and extension = X.t

and trkseg =
  {
    trkpt      : wpt list;
    extensions : extension option;
  }

and copyright =
  {
    author  : string;
    year    : int option;
    license : string option;
  }

and link =
  {
    href : string;
    text : string option;
    typ  : string option;
  }

and email =
  {
    id     : string;
    domain : string;
  }

and person =
  {
    name  : string option;
    email : email option;
    link  : link option;
  }

and bounds =
  {
    minlat : latitude;
    minlon : longitude;
    maxlat : latitude;
    maxlon : longitude;
  }

and latitude = float (* -180.0 <= value <= 180.0 *)

and longitude = float (* -180.0 <= value <= 180.0 *)

and degrees = float (* 0.0 <= value <= 360.0 *)

and fix = FIX_none | FIX_2d | FIX_3d | FIX_dgps | FIX_pps

and dgps_station = int (* 0 <= value <= 1023 *)

and date_time = (float * float option) (* UTC time, timezone offset *)

module Make :
  sig
    val gpx :
      ?metadata:metadata ->
      ?wpts:wpt list ->
      ?rtes:rte list ->
      ?trks:trk list ->
      ?extensions:extension ->
      creator:string ->
      unit -> gpx

    val metadata :
      ?name:string ->
      ?description:string ->
      ?author:person ->
      ?copyright:copyright ->
      ?link:link list ->
      ?time:date_time ->
      ?keywords:string ->
      ?bounds:bounds ->
      ?extensions:extension ->
      unit -> metadata

    val wpt :
      ?elevation:float ->
      ?magnetic_variation:degrees ->
      ?height_from_sea_level:float ->
      ?comment:string ->
      ?source:string ->
      ?symbol:string ->
      ?typ:string ->
      ?fix:fix ->
      ?sat:int ->
      ?horizontal_dilution_of_precision:float ->
      ?vertical_dilution_of_precision:float ->
      ?position_dilution_of_precision:float ->
      ?last_dgps:float ->
      ?id_of_dgps:dgps_station ->
      ?time:date_time ->
      ?name:string ->
      ?description:string ->
      ?link:link list ->
      ?extensions:extension ->
      latitude:latitude ->
      longitude:longitude ->
      unit -> wpt

    val trk :
      ?name:string ->
      ?comment:string ->
      ?description:string ->
      ?source:string ->
      ?link:link list ->
      ?number:int ->
      ?typ:string ->
      ?extensions:extension ->
      ?tracks:trkseg list ->
      unit -> trk

    val rte :
      ?name:string ->
      ?comment:string ->
      ?description:string ->
      ?source:string ->
      ?link:link list ->
      ?number:int ->
      ?typ:string ->
      ?extensions:extension ->
      ?routes:wpt list ->
      unit -> rte

    val trkseg :
      ?pts:wpt list ->
      ?extensions:extension ->
      unit -> trkseg

    val copyright :
      ?year:int option ->
      ?license:string ->
      author:string ->
      copyright

    val person :
      ?name:string ->
      ?email:email ->
      ?link:link ->
      unit -> person

    val link :
      ?text:string ->
      ?typ:string ->
      href:string ->
      link

    val email : id:string -> domain:string -> email

    val bounds :
      min_latitude:latitude ->
      min_longitude:longitude ->
      max_latitude:latitude ->
      max_longitude:longitude ->
      bounds

    val latitude : float -> float
    val longitude : float -> float
    val degrees : float -> float
    val dgps_station : int -> int
  end

(** {2 Whole GPX }
    These two functions are probably all you will need.
    They allow you to go from a [Xml.xml] value to a [gpx] record,
    and vice versa. *)

val of_xml : X.t -> gpx
val to_xml : gpx -> X.t

(** {2 GPX parts }
    If you are interested in parsing a part of GPX only,
    you may find the following two modules useful. *)

(** From a [Xml.xml] value *)
module Of_XML :
  sig
    val gpx    : X.t -> gpx
    val rte    : X.t -> rte
    val rtept  : X.t -> wpt
    val trk    : X.t -> trk
    val trkpt  : X.t -> wpt
    val trkseg : X.t -> trkseg
    val wpt    : X.t -> wpt
  end

(** To a [Xml.xml] value *)
module To_XML :
  sig
    val gpx    : gpx -> X.t
    val rte    : rte -> X.t
    val rtept  : wpt -> X.t
    val trk    : trk -> X.t
    val trkpt  : wpt -> X.t
    val trkseg : trkseg -> X.t
    val wpt    : wpt -> X.t
  end
