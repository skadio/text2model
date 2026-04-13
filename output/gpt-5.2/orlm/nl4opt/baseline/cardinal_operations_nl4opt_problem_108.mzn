% Meat slicer purchase optimization (all data embedded)

int: slices_manual = 5;
int: slices_auto   = 8;

int: grease_manual = 3;
int: grease_auto   = 6;

int: min_slices = 50;
int: max_grease = 35;

% Decision variables: number of slicers to buy
var 0..100: manual;
var 0..100: automatic;

constraint slices_manual * manual + slices_auto * automatic >= min_slices;
constraint grease_manual * manual + grease_auto * automatic <= max_grease;

% Manual slicers must be less than automatic slicers
constraint manual < automatic;

solve minimize manual + automatic;

output [
  "manual=", show(manual), "\n",
  "automatic=", show(automatic), "\n",
  "total=", show(manual + automatic), "\n",
  "slices_per_min=", show(slices_manual * manual + slices_auto * automatic), "\n",
  "grease_per_min=", show(grease_manual * manual + grease_auto * automatic), "\n"
];