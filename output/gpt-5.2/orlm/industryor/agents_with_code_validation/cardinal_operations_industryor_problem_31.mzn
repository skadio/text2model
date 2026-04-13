% Linear programming model: allocate workshop hours to components to maximize completed products

% Sets
int: nWorkshops = 4;
int: nComponents = 3;
set of int: WORKSHOPS = 1..nWorkshops;
set of int: COMPONENTS = 1..nComponents;

% Data (embedded)
array[WORKSHOPS] of float: capacity_hours = [100.0, 150.0, 80.0, 200.0];

% rate_units_per_hour[w,c]
array[WORKSHOPS, COMPONENTS] of float: rate_units_per_hour =
  [| 10.0, 15.0,  5.0
   | 15.0, 10.0,  5.0
   | 20.0,  5.0, 10.0
   | 10.0, 15.0, 20.0 |];

% Safe upper bounds
float: max_capacity = max(w in WORKSHOPS)(capacity_hours[w]);
float: max_rate = max(w in WORKSHOPS, c in COMPONENTS)(rate_units_per_hour[w,c]);
float: max_total_hours = sum(w in WORKSHOPS)(capacity_hours[w]);
float: max_units_any_component = max_total_hours * max_rate;

% Decision variables
array[WORKSHOPS, COMPONENTS] of var 0.0..max_capacity: hours_alloc;

% Units produced per component
array[COMPONENTS] of var 0.0..max_units_any_component: units_component;

% Completed products
var 0.0..max_units_any_component: products;

% Constraints
constraint
  forall(w in WORKSHOPS) (
    sum(c in COMPONENTS)(hours_alloc[w,c]) <= capacity_hours[w]
  );

constraint
  forall(c in COMPONENTS) (
    units_component[c] = sum(w in WORKSHOPS)(hours_alloc[w,c] * rate_units_per_hour[w,c])
  );

constraint
  forall(c in COMPONENTS) (
    products <= units_component[c]
  );

% Objective
solve :: float_search([hours_alloc[w,c] | w in WORKSHOPS, c in COMPONENTS], first_fail, indomain_min, complete)
maximize products;