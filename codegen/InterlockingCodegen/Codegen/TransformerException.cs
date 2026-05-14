namespace FormalInterlocking.Codegen;

[Serializable]
public class TransformerException : Exception
{
  public TransformerException()
  {
  }

  public TransformerException(string? message) : base(message)
  {
  }

  public TransformerException(string? message, Exception? innerException) : base(message, innerException)
  {
  }
}
