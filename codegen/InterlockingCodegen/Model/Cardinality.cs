using System;
using Newtonsoft.Json;

namespace FormalInterlocking.Model
{
    [JsonConverter(typeof(CardinalityConverter))]
    public class Cardinality : IEquatable<Cardinality>
    {
        public int? Value { get; }
        public bool IsUnbounded => Value == null;

        public Cardinality(int value) { Value = value; }
        private Cardinality() { Value = null; } // unbounded

        public static Cardinality Unbounded => new Cardinality();

        public override string ToString() => IsUnbounded ? "unbounded" : Value.ToString();
        public override bool Equals(object? obj) => Equals(obj as Cardinality);
        public bool Equals(Cardinality? other) => other != null && Value == other.Value;
        public override int GetHashCode() => Value.GetHashCode();
    }

    public class CardinalityConverter : JsonConverter<Cardinality>
    {
        public override Cardinality ReadJson(JsonReader reader, Type objectType, Cardinality? existingValue, bool hasExistingValue, JsonSerializer serializer)
        {
            if (reader.TokenType == JsonToken.String && (string?)reader.Value == "unbounded")
                return Cardinality.Unbounded;
            if (reader.TokenType == JsonToken.Integer)
                return new Cardinality(Convert.ToInt32(reader.Value));
            throw new JsonSerializationException($"Invalid cardinality value: {reader.Value}");
        }

        public override void WriteJson(JsonWriter writer, Cardinality? value, JsonSerializer serializer)
        {
            if (value == null || value.IsUnbounded)
                writer.WriteValue("unbounded");
            else
                writer.WriteValue(value.Value);
        }
    }
}
