package search.core;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map.Entry;

public class Distogram<T> implements Iterable<T> {
	private HashMap<T,Double> counts = new HashMap<>();

	public Distogram() {}

	public void bump(T value) {
		bumpBy(value, 1.0);
	}
	
	public void bumpBy(T value, Double numBumps) {
		counts.put(value, getCountFor(value) + numBumps);
	}
	
	public Double getCountFor(T value) {
		return counts.getOrDefault(value, 0.0);
	}
	
	public Double getTotalCounts() {
		Double total = 0.0;
		for (Entry<T,Double> entry: counts.entrySet()) {
			total += entry.getValue();
		}
		return total;
	}

	public int size() {
		return counts.size();
	}
	
	@Override
	public Iterator<T> iterator() {
		return counts.keySet().iterator();
	}
	
	public T getPluralityWinner() {
	        T maxEntry = null;
        	        for (T entry : counts.keySet()) {
        	                if (maxEntry == null || counts.get(entry).compareTo(counts.get(maxEntry)) > 0) {
        	                        maxEntry = entry;
        	                }
        	        }
	        return maxEntry;
	}
	
	public T oppositeOfPlurality() {
                T minEntry = null;
                for (T entry : counts.keySet()) {
                        if (minEntry == null || counts.get(entry).compareTo(counts.get(minEntry)) < 0) {
                                minEntry = entry;
                        }
                }
        return minEntry;
}
}
