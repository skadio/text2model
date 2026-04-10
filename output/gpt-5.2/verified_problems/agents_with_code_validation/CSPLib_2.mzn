include "globals.mzn";

% Parameters
int: S;                          % Number of slots per template
int: t;                          % Number of templates
int: n;                          % Number of design variations
array[1..n] of int: d;           % Minimum demand for each variation (non-negative)

% Variables
array[1..t, 1..S] of var 1..n: slot_design;
% slot_design[k,s] = variation assigned to slot s of template k

array[1..t, 1..n] of var 0..S: slots_per_template;
% slots_per_template[k,i] = number of slots on template k assigned to variation i

array[1..n] of var 0..sum(d): produced;
% produced[i] = total amount produced of variation i (across all templates)

array[1..n] of var 0..sum(d): surplus;
% surplus[i] = produced[i] - d[i]

var 0..sum(d): total_surplus;

% Constraints

% --- Slot counting per template/variation ---
% Use global_cardinality to link slot assignments to counts.
constraint
  forall(k in 1..t) (
    global_cardinality(
      [slot_design[k,s] | s in 1..S],
      [i | i in 1..n],
      [slots_per_template[k,i] | i in 1..n]
    )
  );

% Each template has exactly S slots (redundant but consistent)
constraint
  forall(k in 1..t) (
    sum(i in 1..n)(slots_per_template[k,i]) = S
  );

% --- Production, demand satisfaction, and surplus definition ---
constraint
  forall(i in 1..n) (
    produced[i] = sum(k in 1..t)(slots_per_template[k,i])
  );

constraint
  forall(i in 1..n) (
    produced[i] >= d[i]
  );

constraint
  forall(i in 1..n) (
    surplus[i] = produced[i] - d[i]
  );

constraint
  total_surplus = sum(i in 1..n)(surplus[i]);

% --- Lexicographic ordering of templates ---
constraint
  forall(k in 1..t-1) (
    lex_lesseq([slot_design[k,s] | s in 1..S],
               [slot_design[k+1,s] | s in 1..S])
  );

% Objective
solve minimize total_surplus;