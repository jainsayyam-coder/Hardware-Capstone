PROGRAM PLC_PRG
VAR
    // HMI commands: use momentary buttons (TRUE while pressed)
    EntryButton : BOOL := FALSE;
    ExitButton  : BOOL := FALSE;
    ResetButton : BOOL := FALSE;

    EntryEdge : R_TRIG;
    ExitEdge  : R_TRIG;
    ResetEdge : R_TRIG;

    Slots : ARRAY[1..4] OF BOOL := [FALSE, FALSE, FALSE, FALSE];
    i : INT;
    FreeSlot : INT;
    ExitSlot : INT;

    Occupied : INT := 0;
    Available : INT := 4;
    ParkingFull : BOOL := FALSE;
    ParkingEmpty : BOOL := TRUE;

    EntryBarrier : BOOL := FALSE;
    ExitBarrier : BOOL := FALSE;

    EntryTimer : TP;
    ExitTimer : TP;
    EntryPulse : BOOL := FALSE;
    ExitPulse : BOOL := FALSE;

    Car1 : BOOL := FALSE;
    Car2 : BOOL := FALSE;
    Car3 : BOOL := FALSE;
    Car4 : BOOL := FALSE;

    EntryAccepted : BOOL := FALSE;
    ExitAccepted : BOOL := FALSE;
END_VAR

EntryEdge(CLK := EntryButton);
ExitEdge(CLK := ExitButton);
ResetEdge(CLK := ResetButton);

// Reset only on a new reset-button press
IF ResetEdge.Q THEN
    FOR i := 1 TO 4 DO
        Slots[i] := FALSE;
    END_FOR;
END_IF;

// Recalculate status
Occupied := 0;
FOR i := 1 TO 4 DO
    IF Slots[i] THEN
        Occupied := Occupied + 1;
    END_IF;
END_FOR;
Available := 4 - Occupied;
ParkingFull := (Available = 0);
ParkingEmpty := (Occupied = 0);

// Find first free slot
FreeSlot := 0;
FOR i := 1 TO 4 DO
    IF NOT Slots[i] THEN
        FreeSlot := i;
        EXIT;
    END_IF;
END_FOR;

// Entry event
EntryAccepted := EntryEdge.Q AND (FreeSlot > 0) AND NOT ResetEdge.Q;
IF EntryAccepted THEN
    Slots[FreeSlot] := TRUE;
END_IF;

// Find highest-numbered occupied slot to remove on exit
ExitSlot := 0;
FOR i := 4 TO 1 BY -1 DO
    IF Slots[i] THEN
        ExitSlot := i;
        EXIT;
    END_IF;
END_FOR;

// Exit event
ExitAccepted := ExitEdge.Q AND (ExitSlot > 0) AND NOT ResetEdge.Q;
IF ExitAccepted THEN
    Slots[ExitSlot] := FALSE;
END_IF;

// Recalculate after entry/exit so HMI updates in the same scan
Occupied := 0;
FOR i := 1 TO 4 DO
    IF Slots[i] THEN
        Occupied := Occupied + 1;
    END_IF;
END_FOR;
Available := 4 - Occupied;
ParkingFull := (Available = 0);
ParkingEmpty := (Occupied = 0);

Car1 := Slots[1];
Car2 := Slots[2];
Car3 := Slots[3];
Car4 := Slots[4];

// Barrier opens for 2 seconds on an accepted entry/exit event
EntryTimer(IN := EntryAccepted, PT := T#2S);
ExitTimer(IN := ExitAccepted, PT := T#2S);
EntryPulse := EntryTimer.Q;
ExitPulse := ExitTimer.Q;

EntryBarrier := EntryPulse;
ExitBarrier := ExitPulse;
