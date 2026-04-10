% Handmade sports equipment production optimization (embedded data)

int: material_available = 1500;
int: hours_available = 750;

int: material_basketball = 5;
int: hours_basketball = 1;

int: material_football = 3;
int: hours_football = 2;

int: min_footballs = 50;

% Upper bounds from resources
int: max_basketballs = min(material_available div material_basketball,
                          hours_available div hours_basketball);
int: max_footballs = min(material_available div material_football,
                         hours_available div hours_football);

var 0..max_basketballs: basketballs;
var 0..max_footballs: footballs;

constraint material_basketball * basketballs + material_football * footballs <= material_available;
constraint hours_basketball * basketballs + hours_football * footballs <= hours_available;

constraint basketballs >= 3 * footballs;
constraint footballs >= min_footballs;

var int: total_produced = basketballs + footballs;

solve maximize total_produced;

output [
  "basketballs=", show(basketballs), "\n",
  "footballs=", show(footballs), "\n",
  "total_produced=", show(total_produced), "\n"
];