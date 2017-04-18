module Hacl.Impl.Ed25519.ExtPoint

#reset-options "--max_fuel 0 --z3rlimit 20"

(* A point is buffer of size 20, that is 4 consecutive buffers of size 5 *)
let point = b:Buffer.buffer Hacl.Bignum.Parameters.limb{Buffer.length b = 20}

let getx (p:point) : Tot Hacl.Bignum.Parameters.felem = Buffer.sub p 0ul 5ul
let gety (p:point) : Tot Hacl.Bignum.Parameters.felem = Buffer.sub p 5ul 5ul
let getz (p:point) : Tot Hacl.Bignum.Parameters.felem = Buffer.sub p 10ul 5ul
let gett (p:point) : Tot Hacl.Bignum.Parameters.felem = Buffer.sub p 15ul 5ul

(** Extracts the specification representation of the point from a heap and a pointer *)
val as_point: h:HyperStack.mem -> p:point{Buffer.live h p} -> GTot Spec.Ed25519.ext_point
let as_point h p =
  let x = Buffer.as_seq h (getx p) in
  let y = Buffer.as_seq h (gety p) in
  let z = Buffer.as_seq h (getz p) in
  let t = Buffer.as_seq h (gett p) in
  Hacl.Bignum25519.seval x, Hacl.Bignum25519.seval y, Hacl.Bignum25519.seval z, Hacl.Bignum25519.seval t
