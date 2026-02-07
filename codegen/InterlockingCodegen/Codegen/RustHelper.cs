using FormalInterlocking.Model;

namespace FormalInterlocking.Codegen;

public static class RustHelper
{
    public static string GetRustDefaultValue(Variable v)
    {
        if (v.Type == "timestamp")
        {
            return "timestamp { milliseconds: None }";
        }

        if (!string.IsNullOrEmpty(v.Default))
        {
            // Use the default value as-is (assume it's valid Rust syntax, e.g. OccupancyStatus::VACANT)
            return v.Default;
        }
        // Fallback: use Default::default()
        return "Default::default()";
    }

    public static string GetRustBoolDefault(Term t)
    {
        return t.Default ? "true" : "false";
    }
}
