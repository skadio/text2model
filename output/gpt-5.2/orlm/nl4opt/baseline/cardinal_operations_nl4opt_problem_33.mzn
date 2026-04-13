% Farm planning: maximize revenue from turnips and pumpkins

int: total_acres = 500;

int: water_available = 40000;          % minutes
int: pesticide_budget = 34000;         % dollars

int: water_turnips = 50;              % minutes per acre
int: water_pumpkins = 90;             % minutes per acre

int: pesticide_turnips = 80;          % dollars per acre
int: pesticide_pumpkins = 50;         % dollars per acre

int: revenue_turnips = 300;           % dollars per acre
int: revenue_pumpkins = 450;          % dollars per acre

var 0..total_acres: acres_turnips;
var 0..total_acres: acres_pumpkins;

constraint acres_turnips + acres_pumpkins <= total_acres;

constraint water_turnips * acres_turnips + water_pumpkins * acres_pumpkins
          <= water_available;

constraint pesticide_turnips * acres_turnips + pesticide_pumpkins * acres_pumpkins
          <= pesticide_budget;

var int: total_revenue = revenue_turnips * acres_turnips + revenue_pumpkins * acres_pumpkins;

solve maximize total_revenue;

output [
  "acres_turnips=", show(acres_turnips), "\n",
  "acres_pumpkins=", show(acres_pumpkins), "\n",
  "total_revenue=", show(total_revenue), "\n"
];