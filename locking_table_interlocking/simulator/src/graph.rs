use crate::{eval_context::EvalContext, timestamp::timestamp};

pub trait Graph {
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp);
    fn transition(&mut self, now: timestamp);
}
