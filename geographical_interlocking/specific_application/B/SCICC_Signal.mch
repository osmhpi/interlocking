MACHINE SCICC_Signal
SEES Enums
VARIABLES
  SignalOpen
INVARIANT
  SignalOpen : BOOL
INITIALIZATION
  SignalOpen := FALSE
OPERATIONS
  ComputeOutputs(SignalControl_State) = BEGIN
IF bool(SignalControl_State = OpenCloseState_OPEN) = TRUE THEN
        SignalOpen := TRUE
      ELSIF bool(SignalControl_State /= OpenCloseState_OPEN) = TRUE THEN
        SignalOpen := FALSE
      ELSE
        SignalOpen := FALSE
      END
    END
END//MACHINE
