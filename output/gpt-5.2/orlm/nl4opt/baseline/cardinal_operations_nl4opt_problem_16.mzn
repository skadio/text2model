% Pool chemicals: minimize total time to be effective.
% Chlorine: 1 minute per unit
% Water softener: 2 minutes per unit
% Constraint: chlorine <= half of softener  => 2*chlorine <= softener
% Requirements: chlorine >= 200; total chemicals = 500
% Note about order is irrelevant since total time is additive.

int: total_chemicals = 500;
int: min_chlorine = 200;

var 0..total_chemicals: chlorine;
var 0..total_chemicals: softener;

constraint chlorine + softener = total_chemicals;
constraint chlorine >= min_chlorine;
constraint 2 * chlorine <= softener;

var int: total_time = chlorine * 1 + softener * 2;

solve minimize total_time;

output [
  "chlorine = ", show(chlorine), "\n",
  "softener = ", show(softener), "\n",
  "total_time = ", show(total_time), " minutes\n"
];