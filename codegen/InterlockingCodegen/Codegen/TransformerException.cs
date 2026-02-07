namespace FormalInterlocking.Codegen;

[Serializable]
internal class TransformerException : Exception
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
