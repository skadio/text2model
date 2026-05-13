int: ParticipantsPerCircular;
int: ParticipantsPerRectangular;
int: BoardsPerCircular;
int: BoardsPerRectangular;
int: GuestsPerCircular;
int: GuestsPerRectangular;
int: SpacePerCircular;
int: SpacePerRectangular;
int: TotalSpace;
int: MinParticipants;
int: MinBoards;

var 0..TotalSpace: CircularTables;
var 0..TotalSpace: RectangularTables;

constraint CircularTables * SpacePerCircular + RectangularTables * SpacePerRectangular <= TotalSpace;
constraint CircularTables * ParticipantsPerCircular + RectangularTables * ParticipantsPerRectangular >= MinParticipants;
constraint CircularTables * BoardsPerCircular + RectangularTables * BoardsPerRectangular >= MinBoards;

var int: TotalGuests = CircularTables * GuestsPerCircular + RectangularTables * GuestsPerRectangular;

solve maximize TotalGuests;

output [
    "CircularTables: ", show(CircularTables), "\n",
    "RectangularTables: ", show(RectangularTables), "\n",
    "TotalGuests: ", show(TotalGuests), "\n"
];