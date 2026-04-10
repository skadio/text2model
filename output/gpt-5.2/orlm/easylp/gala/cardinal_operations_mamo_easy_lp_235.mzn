% Farm crop allocation - minimize revenue (integer acres)

int: total_limit = 1000;

int: rev_wheat  = 2;
int: rev_corn   = 3;
int: rev_barley = 1;

% Decision variables (whole acres)
var 0..total_limit: wheat;
var 0..total_limit: corn;
var 0..total_limit: barley;

% Total acreage constraint
constraint wheat + corn + barley <= total_limit;

% Demand/rotation constraints as stated
% "twice the area planted with wheat plus the area planted with corn should be at least 500"
constraint 2 * wheat + corn >= 500;

% "the area planted with wheat plus twice that of barley should not exceed 600"
constraint wheat + 2 * barley <= 600;

% Revenue (dollars)
var 0..(rev_wheat*total_limit + rev_corn*total_limit + rev_barley*total_limit): revenue;
constraint revenue = rev_wheat*wheat + rev_corn*corn + rev_barley*barley;

solve minimize revenue;

output [
  "Minimum revenue ($): ", show(revenue), "\n",
  "wheat acres = ", show(wheat), "\n",
  "corn acres = ", show(corn), "\n",
  "barley acres = ", show(barley), "\n"
];