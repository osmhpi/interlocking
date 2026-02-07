// Auto-generated Rust interface for entity type-related interface ports

use crate::{configuration_types::*, enums::*, eval_context::EvalContext, triggerable::Triggerable};

#[derive(Clone)]
pub struct Point_SCICCStruct {
    pub entity: EntitiesPointItem,
    pub CurrentPosition: EulynxEndPosition, // output
}

impl Point_SCICCStruct {
    pub fn new(entity: EntitiesPointItem) -> Self {
        Self {
            entity,
            CurrentPosition: EulynxEndPosition::NO_END_POSITION,
        }
    }
    pub fn complete_cycle(&mut self, ctx: &EvalContext) {
        self.CurrentPosition = EulynxEndPosition::NO_END_POSITION;
        if (match (Some(ctx.Point_SCIP.get(&self.entity.name).unwrap().DetectedEndPosition), Some(Triggerable::Triggered(EulynxEndPosition::LEFT))) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false) {
            self.CurrentPosition = EulynxEndPosition::LEFT;
        }
        if (match (Some(ctx.Point_SCIP.get(&self.entity.name).unwrap().DetectedEndPosition), Some(Triggerable::Triggered(EulynxEndPosition::RIGHT))) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false) {
            self.CurrentPosition = EulynxEndPosition::RIGHT;
        }
        if (match (Some(ctx.Point_SCIP.get(&self.entity.name).unwrap().DetectedEndPosition), Some(Triggerable::Triggered(EulynxEndPosition::NO_END_POSITION))) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false) {
            self.CurrentPosition = EulynxEndPosition::NO_END_POSITION;
        }
    }
}
