// Auto-generated Rust enums

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum EulynxEndPosition {
    LEFT,
    RIGHT,
    NO_END_POSITION,
    UNINTENDED,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum EulynxCommandedEndPosition {
    NOT_COMMANDED,
    LEFT,
    RIGHT,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum OccupancyStatus {
    OCCUPIED,
    VACANT,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum RouteState {
    SET,
    PREPARING,
    RELEASED,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ActiveInactive {
    INACTIVE,
    ACTIVE,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PointState {
    LEFT,
    RIGHT,
    UNDETERMINED,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum OpenCloseState {
    OPEN,
    CLOSED,
}
