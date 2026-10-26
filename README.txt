SMART CAR PARKING — CODESYS V3.5 STARTER PACK
================================================

Contents
--------
1. PLC_PRG.st
   Structured Text logic for four parking slots, entry/exit events,
   counters, full/empty status, and 2-second barrier commands.

2. parking_3d_demo.html
   A standalone animated 3D-style browser preview of a four-slot
   smart parking lot. This is a visual demo, NOT a CODESYS visualization.

Important limitation
--------------------
CODESYS standard Visualization is primarily 2D. A true 3D scene is not
automatically created by importing ST code. Depending on your installed
CODESYS version and target, a 3D view usually needs a supported 3D
visualization component or an external visualization application.
This pack provides the PLC logic and a visual prototype; it is not a
native .project file and will need the visualization objects configured
inside your existing CODESYS project.

Use in CODESYS V3.5
-------------------
1. Open your existing project.
2. Open Application > PLC_PRG.
3. Copy the contents of PLC_PRG.st into the ST editor, replacing the old
   program body and variable declarations.
4. Add the Standard library if R_TRIG or TP are unresolved:
   Application > Library Manager > Add Library > Standard.
5. Build the application.
6. In Visualization, add buttons bound to:
      PLC_PRG.EntryButton
      PLC_PRG.ExitButton
      PLC_PRG.ResetButton
   Configure them as momentary press/release actions (TRUE on press,
   FALSE on release). Reset should also be momentary.
7. Add slot car shapes/images and set their Invisible expressions:
      NOT PLC_PRG.Car1
      NOT PLC_PRG.Car2
      NOT PLC_PRG.Car3
      NOT PLC_PRG.Car4
   Add text displays bound to:
      PLC_PRG.Available
      PLC_PRG.Occupied
   Bind full warning visibility to PLC_PRG.ParkingFull.
8. Login to a supported runtime, download, start the PLC, and open the
   visualization.

Logic notes
-----------
- Each rising edge of EntryButton fills the first free slot.
- Each rising edge of ExitButton empties the highest-numbered occupied
  slot. This is a simplified simulation, not physical vehicle tracking.
- Barrier outputs are TRUE for two seconds after an accepted event.
- Use proper safety interlocks, physical sensors, limit switches and
  risk assessment before any real barrier installation.
