<<<<<<< develop
public enum ErrorCode {
  AGENT_PLACEMENT(0, "Agent cannot be placed outside of the field.");
  Agent

  private final int code;
  private final String description;

  private ErrorCode(int code, String description) {
    this.code = code;
    this.description = description;
  }

  public String getDescription() {
     return description;
  }

  public int getCode() {
     return code;
  }

  @Override
  public String toString() {
    return code + ": " + description;
  }
}
=======
public enum ErrorCode {
  AGENT_PLACEMENT(0, "Agent cannot be placed outside of the field.");
  Agent

  private final int code;
  private final String description;

  private ErrorCode(int code, String description) {
    this.code = code;
    this.description = description;
  }

  public String getDescription() {
     return description;
  }

  public int getCode() {
     return code;
  }

  @Override
  public String toString() {
    return code + ": " + description;
  }
}
>>>>>>> Obstacle Update
