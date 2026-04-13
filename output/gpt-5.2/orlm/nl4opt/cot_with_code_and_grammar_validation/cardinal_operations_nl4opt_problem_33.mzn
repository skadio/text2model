% Parameters
int: land = 500;
int: water_avail = 40000;
int: pesticide_avail = 34000;

int: water_turnips = 50;
int: pesticide_turnips = 80;
int: revenue_turnips = 300;

int: water_pumpkins = 90;
int: pesticide_pumpkins = 50;
int: revenue_pumpkins = 450;

% Variables
var 0..land: acres_turnips;
var 0..land: acres_pumpkins;

% Constraints
constraint acres_turnips + acres_pumpkins <= land;

constraint water_turnips * acres_turnips + water_pumpkins * acres_pumpkins <= water_avail;

constraint pesticide_turnips * acres_turnips + pesticide_pumpkins * acres_pumpkins <= pesticide_avail;

% Objective
solve maximize revenue_turnips * acres_turnips + revenue_pumpkins * acres_pumpkins;