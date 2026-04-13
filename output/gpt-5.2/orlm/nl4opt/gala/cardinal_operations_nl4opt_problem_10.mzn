include "globals.mzn";

% Data (embedded as requested)
int: pigeon_capacity = 2;
int: pigeon_cost = 3;

int: owl_capacity = 5;
int: owl_cost = 5;

int: treats_available = 1000;
int: min_pigeons = 20;

% At most 40% of the birds can be owls: owls <= 0.4 * (owls + pigeons)
% Use integer arithmetic: 5*owls <= 2*(owls + pigeons)  <=> 3*owls <= 2*pigeons
% (equivalent and avoids reals)
% Decision variables
var 0..treats_available div pigeon_cost: pigeons;
var 0..treats_available div owl_cost: owls;

% Constraints
constraint pigeons >= min_pigeons;
constraint pigeon_cost * pigeons + owl_cost * owls <= treats_available;
constraint 3 * owls <= 2 * pigeons;   % owl fraction <= 40%

% Objective: maximize total letters
var 0..pigeon_capacity*(treats_available div pigeon_cost)
     + owl_capacity*(treats_available div owl_cost): total_letters;
constraint total_letters = pigeon_capacity * pigeons + owl_capacity * owls;

solve maximize total_letters;

output [
  "pigeons = ", show(pigeons), "\n",
  "owls = ", show(owls), "\n",
  "total_birds = ", show(pigeons + owls), "\n",
  "treats_used = ", show(pigeon_cost*pigeons + owl_cost*owls), " / ", show(treats_available), "\n",
  "total_letters = ", show(total_letters), "\n"
];