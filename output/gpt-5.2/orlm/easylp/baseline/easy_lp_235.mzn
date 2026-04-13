% Farm crop allocation - minimize revenue
% All data embedded

int: TOTAL_ACRES = 1000;

int: rev_wheat  = 2;
int: rev_corn   = 3;
int: rev_barley = 1;

var 0..TOTAL_ACRES: wheat;
var 0..TOTAL_ACRES: corn;
var 0..TOTAL_ACRES: barley;

constraint wheat + corn + barley <= TOTAL_ACRES;

% "wheat at least half of wheat+corn" as given in statement:
% 2*wheat + corn >= 500
constraint 2*wheat + corn >= 500;

% Barley constraint as given in statement:
% wheat + 2*barley <= 600
constraint wheat + 2*barley <= 600;

var int: revenue = rev_wheat*wheat + rev_corn*corn + rev_barley*barley;

solve minimize revenue;

output [
  "wheat=", show(wheat), " corn=", show(corn), " barley=", show(barley), "\n",
  "min_revenue_dollars=", show(revenue), "\n"
];