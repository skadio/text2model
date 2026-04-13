% Hand sanitizer production optimization (all data embedded)

int: water_available = 2000;
int: alcohol_available = 2100;

int: water_per_liquid = 40;
int: alcohol_per_liquid = 50;
int: hands_per_liquid = 30;

int: water_per_foam = 60;
int: alcohol_per_foam = 40;
int: hands_per_foam = 20;

int: max_liquid = 30;

var 0..max_liquid: liquid;

% Upper bound for foam from resources: min(2000/60, 2100/40) = min(33, 52) = 33
var 0..33: foam;

constraint water_per_liquid * liquid + water_per_foam * foam <= water_available;
constraint alcohol_per_liquid * liquid + alcohol_per_foam * foam <= alcohol_available;

% Foam must exceed liquid
constraint foam > liquid;

var int: total_hands = hands_per_liquid * liquid + hands_per_foam * foam;

solve maximize total_hands;

output [
  "liquid=", show(liquid), "\n",
  "foam=", show(foam), "\n",
  "total_hands=", show(total_hands), "\n"
];