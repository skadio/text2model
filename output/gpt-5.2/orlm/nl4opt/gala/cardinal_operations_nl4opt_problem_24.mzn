include "globals.mzn";

% Data (embedded from problem statement)
int: people_needed = 80;

int: cap_large = 6;
int: spots_large = 2;

int: cap_small = 2;
int: spots_small = 1;

int: min_small_units = 5;
int: min_large_percent = 75; % percent

% Decision variables: number of each unit type
var 0..people_needed: L; % large units
var 0..people_needed: S; % small units

% Total vehicles and parking spots
var 0..2*people_needed: V = L + S;
var 0..2*people_needed: P = spots_large * L + spots_small * S;

% Constraints
constraint cap_large * L + cap_small * S >= people_needed;
constraint S >= min_small_units;

% Large units must be at least 75% of all vehicles:
% L / (L+S) >= 0.75  <=>  4L >= 3(L+S)  <=>  L >= 3S
constraint L >= 3 * S;

solve minimize P;

output [
  "Large units (L) = ", show(L), "\n",
  "Small units (S) = ", show(S), "\n",
  "Total vehicles (V) = ", show(V), "\n",
  "Total parking spots (P) = ", show(P), "\n",
  "Total capacity = ", show(cap_large*L + cap_small*S), "\n"
];