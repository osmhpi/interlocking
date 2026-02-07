using Newtonsoft.Json;

namespace FormalInterlocking.Model
{
  [JsonConverter(typeof(DefaultValueConverter))]
  public class DefaultValue : IEquatable<DefaultValue>
  {
    public string? StringValue { get; }
    public int? IntValue { get; }
    public bool? BoolValue { get; }

    public DefaultValue(string value) { StringValue = value; }
    public DefaultValue(int value) { IntValue = value; }
    public DefaultValue(bool value) { BoolValue = value; }

    public override string ToString() =>
      StringValue ?? IntValue?.ToString() ?? BoolValue?.ToString() ?? "null";

    public override bool Equals(object? obj) => Equals(obj as DefaultValue);
    public bool Equals(DefaultValue? other) =>
      other != null && StringValue == other.StringValue && IntValue == other.IntValue && BoolValue == other.BoolValue;
    public override int GetHashCode() => (StringValue, IntValue, BoolValue).GetHashCode();
  }

  public class DefaultValueConverter : JsonConverter<DefaultValue>
  {
    public override DefaultValue ReadJson(JsonReader reader, Type objectType, DefaultValue? existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
      switch (reader.TokenType)
      {
        case JsonToken.String:
          return new DefaultValue((string)reader.Value!);
        case JsonToken.Integer:
          return new DefaultValue(Convert.ToInt32(reader.Value));
        case JsonToken.Boolean:
          return new DefaultValue((bool)reader.Value!);
        default:
          throw new JsonSerializationException($"Invalid default value: {reader.Value}");
      }
    }

    public override void WriteJson(JsonWriter writer, DefaultValue? value, JsonSerializer serializer)
    {
      if (value == null)
      {
        writer.WriteNull();
      }
      else if (value.StringValue != null)
      {
        writer.WriteValue(value.StringValue);
      }
      else if (value.IntValue != null)
      {
        writer.WriteValue(value.IntValue);
      }
      else if (value.BoolValue != null)
      {
        writer.WriteValue(value.BoolValue);
      }
      else
      {
        writer.WriteNull();
      }
    }
  }
}
