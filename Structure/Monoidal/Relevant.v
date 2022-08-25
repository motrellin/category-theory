Set Warnings "-notation-overridden".

Require Import Category.Lib.
Require Export Category.Theory.Morphisms.
Require Export Category.Theory.Isomorphism.
Require Export Category.Theory.Functor.
Require Export Category.Functor.Bifunctor.
Require Export Category.Structure.Monoidal.
Require Export Category.Structure.Monoidal.Symmetric.

Generalizable All Variables.
Set Primitive Projections.
Set Universe Polymorphism.
Unset Transparent Obligations.

Section RelevantMonoidal.

Context {C : Category}.
Context `{@Monoidal C}.

Class RelevantMonoidal := {
  relevant_is_symmetric : SymmetricMonoidal;

  diagonal {x} : x ~> x ⨂ x;
  diagonal_natural : natural (@diagonal);

  (* These properties are given by Kosta Došen and Zoran Petrić in their 2007
     publication, "Relevant Categories and Partial Functions". *)

  diagonal_unit : @diagonal I ≈ unit_left⁻¹;

  diagonal_tensor_assoc {x} :
   id ⨂ diagonal ∘ diagonal ≈ tensor_assoc ∘ diagonal ⨂ id ∘ @diagonal x;

  braid_diagonal {x} :
    braid ∘ diagonal ≈ @diagonal x;

  braid2 {x y z w} : (x ⨂ y) ⨂ (z ⨂ w) ~> (x ⨂ z) ⨂ (y ⨂ w) :=
    tensor_assoc⁻¹
      ∘ id ⨂ (tensor_assoc ∘ braid ⨂ id ∘ tensor_assoc⁻¹)
      ∘ tensor_assoc;

  diagonal_braid2 {x y} :
    @diagonal (x ⨂ y) ≈ braid2 ∘ diagonal ⨂ diagonal
}.
#[export] Existing Instance relevant_is_symmetric.

Context `{RelevantMonoidal}.

Lemma braid2_natural : natural (@braid2 _).
Proof.
  unfold braid2; simpl; intros; normal.
  rewrite from_tensor_assoc_natural.
  rewrite <- !comp_assoc.
  rewrite <- to_tensor_assoc_natural.
  normal.
  comp_right.
  comp_left.
  normal.
  bimap_left.
  rewrite to_tensor_assoc_natural.
  rewrite <- !comp_assoc.
  rewrite <- from_tensor_assoc_natural.
  comp_left.
  comp_right.
  normal.
  bimap_right.
  spose (fst braid_natural _ _ h _ _ i) as X.
  normal; assumption.
Qed.

End RelevantMonoidal.

Notation "∆ x" := (@diagonal _ _ _ x)
  (at level 9, format "∆ x") : morphism_scope.
