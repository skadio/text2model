% Parameters
% Workshops and components
int: nWorkshops = 4;
set of int: WORKSHOPS = 1..nWorkshops;

int: nComponents = 3;
set of int: COMPONENTS = 1..nComponents;

% Production capacity in hours for each workshop (A,B,C,D)
array[WORKSHOPS] of int: capacity_hours = [100, 150, 80, 200];

% Production rates (units/hour): rows=workshops (A,B,C,D), cols=components (1..3)
array[WORKSHOPS, COMPONENTS] of int: rate_units_per_hour =
  array2d(WORKSHOPS, COMPONENTS,
    [ 10, 15,  5,   % A
      15, 10,  5,   % B
      20,  5, 10,   % C
      10, 15, 20    % D
    ]
  );

% Upper bound for hours allocated to any (workshop,component) pair (safe bound)
int: maxCapacity = max(w in WORKSHOPS)(capacity_hours[w]);

% Precomputed upper bound on total units per component (for variable domains)
array[COMPONENTS] of int: max_units_per_component =
  [ sum(w in WORKSHOPS)(rate_units_per_hour[w,c] * capacity_hours[w]) | c in COMPONENTS ];

% Upper bound on completed products (min across components)
int: max_products = min(c in COMPONENTS)(max_units_per_component[c]);


% Variables
% Hours allocated by each workshop to each component (non-negative, bounded)
array[WORKSHOPS, COMPONENTS] of var 0..maxCapacity: hours_allocated;

% Total units produced for each component (non-negative, bounded)
array[COMPONENTS] of var 0..max(max_units_per_component): units_produced;

% Number of completed products (each product requires 1 unit of each component)
var 0..max_products: products_completed;


% Constraints
% 1) Workshop capacity constraints: total allocated hours per workshop cannot exceed capacity
constraint
  forall(w in WORKSHOPS) (
    sum(c in COMPONENTS)(hours_allocated[w,c]) <= capacity_hours[w]
  );

% 2) Component production accounting: units produced equals sum over workshops of (rate * hours)
constraint
  forall(c in COMPONENTS) (
    units_produced[c] =
      sum(w in WORKSHOPS)(rate_units_per_hour[w,c] * hours_allocated[w,c])
  );

% 3) Product completion linkage: each product needs 1 unit of each component
constraint
  forall(c in COMPONENTS) (
    products_completed <= units_produced[c]
  );


% Objective
solve maximize products_completed;