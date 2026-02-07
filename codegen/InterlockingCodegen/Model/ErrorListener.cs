using Antlr4.Runtime;

namespace FormalInterlocking.Model;

class ErrorListener : IAntlrErrorListener<IToken>
{
  private readonly Action<int, int, string> _errorAction;

  public ErrorListener(Action<int, int, string> errorAction)
  {
    _errorAction = errorAction;
  }

  public void SyntaxError(TextWriter output, IRecognizer recognizer, IToken offendingSymbol, int line, int charPositionInLine, string msg, RecognitionException e)
  {
    _errorAction(line, charPositionInLine, msg);
  }
}
