
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Triggerable<T> {
    Triggered(T),
    NotTriggered(T),
}
