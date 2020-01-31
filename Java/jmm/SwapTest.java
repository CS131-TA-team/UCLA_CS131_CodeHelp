import java.util.concurrent.ThreadLocalRandom;
import java.lang.management.ThreadMXBean;

class SwapTest implements Runnable {
    private long nTransitions;
    private State state;
    private ThreadMXBean bean;
    private long cputime;

    SwapTest(long n, State s, ThreadMXBean b) {
	nTransitions = n;
	state = s;
	bean = b;
    }

    public void run() {
	var n = state.size();
	if (n <= 1)
	    return;
	var rng = ThreadLocalRandom.current();
	var id = Thread.currentThread().getId();

	var start = bean.getThreadCpuTime(id);
	for (var i = nTransitions; 0 < i; i--)
	    state.swap(rng.nextInt(0, n), rng.nextInt(0, n));
	var end = bean.getThreadCpuTime(id);

	cputime = end - start;
    }

    public long cpuTime() {
	return cputime;
    }
}
