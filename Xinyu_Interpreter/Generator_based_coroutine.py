import time
import random
from collections import deque


def sleep(interval):
    start_time = time.time()
    cur_time = start_time
    while cur_time < start_time + interval:
        # Here we use sleep to simulate io delay
        yield
        cur_time = time.time()


def get_from(queue):
    while not queue:  # while len(queue) == 0:
        # We can also use send to transmit the data read
        # So we can get the data here
        yield
    return queue.popleft()

# ----------------------------------------------

def engine(proc_list):
    proc_cnt = len(proc_list)
    finished_cnt = 0
    while finished_cnt < proc_cnt:
        # Schedule all routines in order
        for i, proc in enumerate(proc_list):
            if not proc:
                continue
            try:
                # Schedule the processing routine
                next(proc)
            except StopIteration:
                # The processing is finished
                proc_list[i] = None
                finished_cnt += 1
        time.sleep(0.01)

# ----------------------------------------------

def produce(queue, n):
    for x in range(1, n + 1):
        # produce an item
        print(f'producing {x}/{n}')
        # simulate i/o operation using sleep
        yield from sleep(random.random())
        item = str(x)
        # put the item in the queue
        queue.append(item)
        
    # indicate the producer is done
    queue.append(None)


def consume(queue):
    while True:
        # wait for an item from the producer
        item = yield from get_from(queue)
        if item is None:
            # the producer emits None to indicate that it is done
            break

        # process the item
        print(f'consuming item {item}...')
        # simulate i/o operation using sleep
        yield from sleep(random.random())


if __name__ == "__main__":
  queue = deque([])
  engine([produce(queue, 10), consume(queue)])
  print("Finished!")
