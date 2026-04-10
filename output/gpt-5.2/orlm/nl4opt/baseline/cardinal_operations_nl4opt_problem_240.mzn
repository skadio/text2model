int: steel_required = 520;
int: waste_limit = 400;

int: steel_per_chop = 25;
int: waste_per_chop = 25;

int: steel_per_cutter = 5;
int: waste_per_cutter = 3;

% Decision variables: number of each machine type to purchase/use
var 0..1000: chop_saws;
var 0..1000: steel_cutters;

constraint
  steel_per_chop * chop_saws + steel_per_cutter * steel_cutters >= steel_required;

constraint
  waste_per_chop * chop_saws + waste_per_cutter * steel_cutters <= waste_limit;

% Minimize total number of machines
solve minimize chop_saws + steel_cutters;

output [
  "chop_saws=", show(chop_saws), "\n",
  "steel_cutters=", show(steel_cutters), "\n",
  "total_machines=", show(chop_saws + steel_cutters), "\n",
  "steel_cut=", show(steel_per_chop * chop_saws + steel_per_cutter * steel_cutters), "\n",
  "waste=", show(waste_per_chop * chop_saws + waste_per_cutter * steel_cutters), "\n"
];