include "globals.mzn";

% Data (embedded as required)
int: lab_papers = 7;
int: lab_treats = 5;

int: gold_papers = 10;
int: gold_treats = 6;

int: treats_available = 1500;
int: min_gold = 50;

% Decision variables
var 0..treats_available div lab_treats: lab;     % number of labradors
var min_gold..treats_available div gold_treats: gold; % number of golden retrievers

% Constraints
constraint lab_treats * lab + gold_treats * gold <= treats_available;

% At most 60% can be labradors: lab <= 0.6*(lab+gold) -> 2*lab <= 3*gold
constraint 2 * lab <= 3 * gold;

% Objective: maximize newspapers delivered
var 0..lab_papers*(treats_available div lab_treats) + gold_papers*(treats_available div gold_treats): total_papers;
constraint total_papers = lab_papers * lab + gold_papers * gold;

solve maximize total_papers;

output [
  "labradors = ", show(lab), "\n",
  "golden_retrievers = ", show(gold), "\n",
  "total_papers = ", show(total_papers), "\n",
  "treats_used = ", show(lab_treats*lab + gold_treats*gold), " / ", show(treats_available), "\n"
];