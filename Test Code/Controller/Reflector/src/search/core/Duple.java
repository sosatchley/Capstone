package search.core;

public class Duple<X,Y> {
	private X x;
	private Y y;
	
	public Duple(X x, Y y) {
		this.x = x;
		this.y = y;
	}
	
	public X getFirst() {return x;}
	public Y getSecond() {return y;}
	
	public void setFirst(X update) {this.x = update;}
	public void setSecond(Y update) {this.y = update;}
	
	public String toString() {
	        String string =  x.toString() + " : " + y.toString();
	        return string;
	}
}
