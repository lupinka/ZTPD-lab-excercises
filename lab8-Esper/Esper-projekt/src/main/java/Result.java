public class Result {
    public Boolean value;

    public Result(boolean b) {
        this.value = b;
    }

    @Override
    public String toString() {
        return this.value.toString();
    }

    public Boolean getValue() {
        return value;
    }

    public void setValue(Boolean value) {
        this.value = value;
    }
}
