% Magic school birds optimization (all data embedded)

int: pigeon_capacity = 2;
int: pigeon_cost = 3;

int: owl_capacity = 5;
int: owl_cost = 5;

int: treats_available = 1000;
float: max_owl_fraction = 0.40;
int: min_pigeons = 20;

% Decision variables: numbers of each bird
var 0..treats_available div pigeon_cost: pigeons;
var 0..treats_available div owl_cost: owls;

% Total letters sent
var 0..(treats_available div min(pigeon_cost, owl_cost)) * max(pigeon_capacity, owl_capacity): letters =
    pigeon_capacity * pigeons + owl_capacity * owls;

constraint pigeons >= min_pigeons;

% Treat budget
constraint pigeon_cost * pigeons + owl_cost * owls <= treats_available;

% At most 40% of birds can be owls: owls <= 0.4 * (pigeons + owls)
% Use integer form: 5*owls <= 2*(pigeons + owls)  <=> 3*owls <= 2*pigeons
constraint 3 * owls <= 2 * pigeons;

solve maximize letters;

output [
  "pigeons=", show(pigeons), "\n",
  "owls=", show(owls), "\n",
  "letters=", show(letters), "\n",
  "treats_used=", show(pigeon_cost*pigeons + owl_cost*owls), "\n"
];