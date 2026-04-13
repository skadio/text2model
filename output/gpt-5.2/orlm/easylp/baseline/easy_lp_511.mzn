% Resource allocation optimization (all data embedded)

int: cost_raw = 20;
int: cost_lab = 30;
int: cost_mac = 10;

int: raw_lb = 0;    int: raw_ub = 2000;
int: lab_lb = 0;    int: lab_ub = 1500;
int: mac_lb = 0;    int: mac_ub = 700;

var raw_lb..raw_ub: RawMaterials;
var lab_lb..lab_ub: Labour;
var mac_lb..mac_ub: Machines;

constraint RawMaterials + Labour >= 1000;
constraint abs(Labour - Machines) <= 500;
constraint RawMaterials - 2 * Machines >= 400;

var int: TotalCost = cost_raw * RawMaterials + cost_lab * Labour + cost_mac * Machines;

solve minimize TotalCost;

output [
  "RawMaterials = ", show(RawMaterials), "\n",
  "Labour = ", show(Labour), "\n",
  "Machines = ", show(Machines), "\n",
  "MinimumTotalCost = $", show(TotalCost), "\n"
];