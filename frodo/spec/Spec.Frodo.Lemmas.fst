module Spec.Frodo.Lemmas

open FStar.Mul
open FStar.Math.Lemmas

open Lib.IntTypes

friend Lib.IntTypes

#reset-options "--z3rlimit 50 --max_fuel 0 --max_ifuel 0 --using_facts_from '* -FStar.Seq'"

// The lemma [lognot_plus_one] below can be proved from this other lemma, but it looks
// hard to prove. Instead, we use [assert_norm] to exhaustively prove it from all values
// [0 < e < 12], which suffices for our purposes.
//
// [val lognot_plus_one': #n:nat -> a:uint_t n{0 < a} -> Lemma (lognot a + 1 = pow2 n - a)]
//
val lognot_plus_one:
    e:uint16{0 < uint_v e /\ uint_v e < 12}
  -> Lemma (lognot e +. u16 1 == u16 (modulus U16 - uint_v e))
let lognot_plus_one e =
  // lognot_plus_one' #16 (uint_v e)
  assert_norm ((lognot (u16 1) +. u16 1 == u16 (modulus U16 - uint_v (u16 1))));
  assert_norm ((lognot (u16 2) +. u16 1 == u16 (modulus U16 - uint_v (u16 2))));
  assert_norm ((lognot (u16 3) +. u16 1 == u16 (modulus U16 - uint_v (u16 3))));
  assert_norm ((lognot (u16 4) +. u16 1 == u16 (modulus U16 - uint_v (u16 4))));
  assert_norm ((lognot (u16 5) +. u16 1 == u16 (modulus U16 - uint_v (u16 5))));
  assert_norm ((lognot (u16 6) +. u16 1 == u16 (modulus U16 - uint_v (u16 6))));
  assert_norm ((lognot (u16 7) +. u16 1 == u16 (modulus U16 - uint_v (u16 7))));
  assert_norm ((lognot (u16 8) +. u16 1 == u16 (modulus U16 - uint_v (u16 8))));
  assert_norm ((lognot (u16 9) +. u16 1 == u16 (modulus U16 - uint_v (u16 9))));
  assert_norm ((lognot (u16 10) +. u16 1 == u16 (modulus U16 - uint_v (u16 10))));
  assert_norm ((lognot (u16 11) +. u16 1 == u16 (modulus U16 - uint_v (u16 11))));
  assert_norm ((lognot (u16 12) +. u16 1 == u16 (modulus U16 - uint_v (u16 12))))

let lemma_frodo_sample2 sign e =
  let open FStar.Math.Lib in
  if uint_v sign = 0 then
    begin
    assert_norm (powx (-1) 0 = 1);
    uintv_extensionality sign (u16 0);
    UInt.logxor_commutative #16 (uint_v e) 0;
    UInt.logxor_lemma_1 #16 (uint_v e);
    assert_norm (lognot (u16 0) +. u16 1 = u16 0)
    end
  else
    begin
    assert_norm (powx (-1) 1 = -1);
    uintv_extensionality sign (u16 1);
    UInt.logxor_commutative #16 (uint_v e) (UInt.ones 16);
    UInt.logxor_lemma_2 #16 (uint_v e);
    assert_norm (lognot (u16 1) +. u16 1 = u16 (maxint U16));
    if uint_v e = 0 then
      assert_norm (lognot (u16 0) +. u16 1 = u16 ((-1) * 0 % modulus U16))
    else
      lognot_plus_one e
    end

let modulo_pow2_u16 a b =
  uintv_extensionality (nat_to_uint 1) (u16 1);
  mod_mask_lemma #U16 a (u32 b)

let modulo_pow2_u32 a b =
  uintv_extensionality (nat_to_uint 1) (u32 1);
  mod_mask_lemma #U32 a (u32 b)

let modulo_pow2_u64 a b =
  uintv_extensionality (nat_to_uint 1) (u64 1);
  mod_mask_lemma #U64 a (u32 b)

let lemma_mul_acc_comm a b c = ()

let lemma_matrix_index_repeati1 n1 n2 i j =
  assert (2 * (i * n2 + j) + 2 <= 2 * ((n1 - 1) * n2 + n2 - 1) + 2);
  assert (2 * (n1 * n2 - 1) + 2 = 2 * n1 * n2 - 2 + 2);
  assert (2 * (i * n2 + j) + 2 <= 2 * n1 * n2)

let lemma_matrix_index_repeati2 n1 n2 i j =
  assert (2 * (n1 * j + i) + 2 <= 2 * (n1 * (n2 - 1) + n1 - 1) + 2);
  assert (2 * (n1 * n2 - 1) + 2 = 2 * n1 * n2 - 2 + 2);
  assert (2 * (n1 * j + i) + 2 <= 2 * n1 * n2)

#reset-options "--z3rlimit 50 --max_fuel 0 --max_ifuel 0 --smtencoding.elim_box true --smtencoding.l_arith_repr boxwrap --smtencoding.nl_arith_repr wrapped"

let lemma_matrix_index_repeati n1 n2 d i j =
  assert (i * n2 / 8 + j <= (n1 - 1) * n2 / 8 + n2 / 8 - 1);
//  assert ((n1 - 1) * n2 / 8 + n2 / 8 - 1 = n1 * n2 / 8 - 1);
  lemma_mult_le_right d (i * n2 / 8 + j) (n1 * n2 / 8 - 1)


// val ec:k:size_nat{k < pow2 params_extracted_bits} -> Tot (r:size_nat{r < pow2 params_logq})
// let ec k = k * pow2 (params_logq - params_extracted_bits)

// val dc:c:size_nat{c < pow2 params_logq} -> Tot (r:size_nat{r < pow2 params_extracted_bits})
// let dc c = ((c + pow2 (params_logq - params_extracted_bits - 1)) / pow2 (params_logq - params_extracted_bits)) % pow2 params_extracted_bits

// val lemma_dc_ec:
//   k:size_nat{k < pow2 params_extracted_bits} -> Lemma (dc (ec k) == k)
// let lemma_dc_ec k =
//   let c = ec k in
//   assert (c == k * pow2 (params_logq - params_extracted_bits));
//   assert (dc c == ((c + pow2 (params_logq - params_extracted_bits - 1)) / pow2 (params_logq - params_extracted_bits)) % pow2 params_extracted_bits);
//   assert (dc c == ((k * pow2 (params_logq - params_extracted_bits) + pow2 (params_logq - params_extracted_bits - 1)) / pow2 (params_logq - params_extracted_bits)) % pow2 params_extracted_bits);
//   pow2_plus 1 (params_logq - params_extracted_bits - 1);
//   //assert (pow2 (params_logq - params_extracted_bits) = pow2 1 * pow2 (params_logq - params_extracted_bits - 1));
//   distributivity_add_left (k * pow2 1) 1 (pow2 (params_logq - params_extracted_bits - 1));
//   //assert (dc c == (((k * pow2 1 + 1) * pow2 (params_logq - params_extracted_bits - 1)) / (pow2 1 * pow2 (params_logq - params_extracted_bits - 1))) % pow2 params_extracted_bits);
//   division_multiplication_lemma ((k * pow2 1 + 1) * pow2 (params_logq - params_extracted_bits - 1))  (pow2 (params_logq - params_extracted_bits - 1)) (pow2 1);
//   //assert (dc c == (((k * pow2 1 + 1) * pow2 (params_logq - params_extracted_bits - 1)) /  pow2 (params_logq - params_extracted_bits - 1) / pow2 1) % pow2 params_extracted_bits);
//   multiple_division_lemma (k * pow2 1 + 1) (pow2 (params_logq - params_extracted_bits - 1));
//   //assert (dc c == ((k * pow2 1 + 1) / pow2 1) % pow2 params_extracted_bits);
//   division_addition_lemma 1 (pow2 1) k;
//   //assert (dc c == (k + 1 / pow2 1) % pow2 params_extracted_bits);
//   small_division_lemma_1 1 (pow2 1);
//   small_modulo_lemma_1 k (pow2 params_extracted_bits)
