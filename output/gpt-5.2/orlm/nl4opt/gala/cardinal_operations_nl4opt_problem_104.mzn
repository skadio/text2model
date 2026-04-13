% Party transport optimization (all data embedded)

int: limoCap = 12;
int: busCap  = 18;
int: minPeople = 400;

% At least 70% of vehicles must be limousines:
% limo / (limo + bus) >= 0.7  <=>  10*limo >= 7*(limo+bus)  <=>  3*limo >= 7*bus
int: minLimoRatio_num = 70;
int: ratioDen = 100;

% Safe upper bounds: if all limos, need ceil(400/12)=34; if all buses, need ceil(400/18)=23.
% Use a slightly larger bound to keep it simple and safe.
int: UB = 100;

var 0..UB: limos;
var 0..UB: buses;

constraint limoCap * limos + busCap * buses >= minPeople;

% 100*limos >= 70*(limos + buses)  <=> 30*limos >= 70*buses  <=> 3*limos >= 7*buses
constraint ratioDen * limos >= minLimoRatio_num * (limos + buses);

var 0..2*UB: totalVehicles = limos + buses;

solve minimize totalVehicles;

output [
  "limousines = ", show(limos), "\n",
  "buses      = ", show(buses), "\n",
  "total      = ", show(totalVehicles), "\n",
  "capacity   = ", show(limoCap*limos + busCap*buses), "\n"
];