% Parameters
int: S;                         % Number of slots per template
int: t;                         % Number of templates available/used
int: n;                         % Number of design variations
array[1..n] of int: d;          % Demand (minimum required) for each variation

% Variables
array[1..t, 1..S] of var 1..n: slot_var;
% slot_var[i,s] = design variation (1..n) assigned to slot s of template i

array[1..n] of var 0..sum(d): produced;
% Total number of items produced for each variation (depends on slot configuration)

array[1..n] of var 0..sum(d): surplus;
% Surplus for each variation: produced[v] - d[v] (non-negative)

var 0..sum(d): total_surplus;
% Total surplus across all variations

% Constraints

%--- Production calculation: produced[v] equals total number of slots assigned to v across all templates ---
constraint
  forall(v in 1..n) (
    produced[v] =
      sum(i in 1..t, s in 1..S) ( bool2int(slot_var[i,s] == v) )
  );

%--- Demand satisfaction and surplus definition (non-negative) ---
constraint
  forall(v in 1..n) (
    produced[v] >= d[v]
  );

constraint
  forall(v in 1..n) (
    surplus[v] = produced[v] - d[v]
  );

%--- Total surplus aggregation ---
constraint
  total_surplus = sum(v in 1..n) ( surplus[v] );

%--- Lexicographic ordering of templates (each template is a length-S vector) ---
constraint
  forall(i in 1..t-1) (
    lex_lesseq([ slot_var[i,s] | s in 1..S ],
               [ slot_var[i+1,s] | s in 1..S ])
  );

% Objective
solve minimize total_surplus;