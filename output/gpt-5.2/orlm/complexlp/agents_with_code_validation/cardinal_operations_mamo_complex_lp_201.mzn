% International Wool Company - Minimum cost feed mix
% Use exact rational scaling to avoid float-linear limits in Gecode.

% Sets
int: nNutrients = 4;
set of int: NUTRIENTS = 1..nNutrients; % 1=A, 2=B, 3=C, 4=D

int: nGrains = 3;
set of int: GRAINS = 1..nGrains;

% Scale all amounts by 2 to eliminate the 2.5 in nutrient D for grain 2.
% Decision variables are half-pounds: x[g] = 2 * pounds[g]
% Then all constraints/objective can be integer linear.

int: SCALE = 2;

% Nutrient content per pound, scaled by SCALE (i.e., units per half-pound * 2)
array[GRAINS, NUTRIENTS] of int: nutrient_scaled =
  [| 40, 20, 100, 12    % Grain 1: (20,10,50,6) * 2
   | 60, 20,  60,  5    % Grain 2: (30,10,30,2.5) * 2
   |140,  0,   0, 20    % Grain 3: (70,0,0,10) * 2
  |];

% Minimum daily requirements, scaled by SCALE
array[NUTRIENTS] of int: min_req_scaled = [220, 36, 180, 28];

% Cost in cents per pound -> scaled objective for half-pounds:
% total_cost_scaled = sum(cost[g] * x[g]) where x[g] = 2*pounds[g]
array[GRAINS] of int: cost_cents_per_lb = [41, 36, 96];

% Variables: half-pounds of each grain (nonnegative integers)
array[GRAINS] of var 0..1000000: x;

% Scaled total cost (in "cents * 2")
var 0..intmax: total_cost_scaled = sum(g in GRAINS)(cost_cents_per_lb[g] * x[g]);

% Constraints: meet or exceed minimum nutrient requirements
constraint
  forall(n in NUTRIENTS)(
    sum(g in GRAINS)(nutrient_scaled[g,n] * x[g]) >= min_req_scaled[n]
  );

solve minimize total_cost_scaled;

% Output minimum cost in cents (may be .5 increments)
output [
  "minimum_cost_cents = ",
  show(total_cost_scaled div SCALE),
  if total_cost_scaled mod SCALE = 0 then "" else ".5" endif,
  "\n",
  "half_pounds (x) = ", show(x), "\n",
  "pounds = [",
  concat([ if g>1 then ", " else "" endif ++
           show(x[g] div SCALE) ++ (if x[g] mod SCALE = 0 then "" else ".5" endif)
         | g in GRAINS ]),
  "]\n"
];