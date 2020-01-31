class SynchronizedState implements State {
    private long[] value;

    SynchronizedState(int length) { value = new long[length]; }

    public int size() { return value.length; }

    public long[] current() { return value; }

    public synchronized void swap(int i, int j) {
	value[i]--;
	value[j]++;
    }
}
