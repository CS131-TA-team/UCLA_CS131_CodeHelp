'''
adapted from Kimmo's previous year's slides
thank you Kimmo for the example
'''

import asyncio
import time

async def count(task_id):
	print("One {}".format(task_id))
	await asyncio.sleep(1./float(task_id)) # Any IO-intensive task here
	print("Two {}".format(task_id))

async def main():
	await asyncio.gather(count(1), count(2), count(3))

if __name__ == "__main__":
	s = time.perf_counter()
	asyncio.run(main()) # Add to an event loop
	elapsed = time.perf_counter() - s
	print(f"{__file__} executed in {elapsed:0.2f} seconds.")