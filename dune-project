(lang dune 2.0)

(name gpx)
(version 1.1.1)

(generate_opam_files true)

(source
 (github LamaUrbain/ocaml-gpx))

(authors "Julien Sagot <ju.sagot@gmail.com>")

(maintainers "Romain Calascibetta <romain.calascibetta@gmail.com>")

(license MIT)

(package
 (name gpx)
 (synopsis "GPX in OCaml")
 (depends
  (ocaml (>= 4.02))
  dune
  xmlm
  ISO8601
  (re (and :with-test (>= 1.7.2)))
  (alcotest :with-test)))
