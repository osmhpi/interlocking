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

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum RouteAdmission {
    INACTIVE,
    ADMIT_TO_A,
    ADMIT_TO_B,
    ADMIT_TO_C,
    ADMIT_END,
    ROUTE_TO_A,
    ROUTE_TO_B,
    ROUTE_TO_C,
    ROUTE_END,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum RouteChecking {
    INACTIVE,
    CHECK_START,
    CHECK_FROM_A,
    CHECK_FROM_B,
    CHECK_FROM_C,
    ROUTE_SET_FROM_START,
    ROUTE_SET_FROM_A,
    ROUTE_SET_FROM_B,
    ROUTE_SET_FROM_C,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum RouteSearch {
    INACTIVE,
    SEARCH,
    RESPONSE,
    ROUTE_SET,
    ROUTE_MONITORED,
}
