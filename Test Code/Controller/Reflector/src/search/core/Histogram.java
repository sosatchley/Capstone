package search.core;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map.Entry;

public class Histogram<T> implements Iterable<T> {
        private HashMap<T,Integer> counts = new HashMap<>();

        public Histogram() {}
        
        public Histogram(Histogram<T> other) {
                this.counts.putAll(other.counts);
                if (this.counts.size() != other.counts.size()) {
                        throw new IllegalStateException("Huh? " + this.counts.size() + ": " + other.counts.size());
                }
        }
        
        public void bump(T value) {
                bumpBy(value, 1);
        }
        
        public void bumpBy(T value, int numBumps) {
                counts.put(value, getCountFor(value) + numBumps);
        }
        
        public int getCountFor(T value) {
                return counts.getOrDefault(value, 0);
        }
        
        public int getTotalCounts() {
                int total = 0;
                for (Entry<T,Integer> entry: counts.entrySet()) {
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
