MACHINE SCICC_Signal
SEES Enums
VARIABLES
  signal_open
INVARIANT
  signal_open : BOOL
INITIALIZATION
  signal_open := FALSE
OPERATIONS
  ComputeOutputs(SignalControl_State) =
    BEGIN
      IF bool(SignalControl_State = OpenCloseState_OPEN) = TRUE THEN
        signal_open := TRUE
      ELSIF bool(SignalControl_State /= OpenCloseState_OPEN) = TRUE THEN
        signal_open := FALSE
      ELSE
        signal_open := FALSE
      END
    END
END//MACHINE
