# GPX for OCaml

OCaml library for GPX documents manipulation.

Provides a `Gpx` module defining types to match GPX document
structure and functions to navigate between `gpx` type and
XML trees (`X.t`).

# Installation

Via opam:

    opam install gpx

# Usage

`Gpx.of_xml` returns a `Gpx.gpx` value from a `Gpx.X.t` value.

`Gpx.to_xml` returns a `Gpx.X.t` value from a `Gpx.gpx` value.

Example:

```ocaml
let _ = Xmlm.make_input (`Channel stdin)
        |> Gpx.X.of_xmlm
        |> snd
        |> Gpx.of_xml
        |> Gpx.to_xml
        |> Gpx.X.to_string
        |> print_endline
```

# Documentation

Browse [online documentation](https://rundat.github.io/ocaml-gpx/).
