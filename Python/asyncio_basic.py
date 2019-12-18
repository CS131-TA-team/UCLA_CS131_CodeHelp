'''
from Kimmo's previous year's slides
thank you Kimmo for the example
'''

import asyncio
import time

async def count():
	print("One")
	await asyncio.sleep(1) # Any IO-intensive task here
	print("Two")

async def main():
	await asyncio.gather(count(), count(), count())

if __name__ == "__main__":
	s = time.perf_counter()
	asyncio.run(main()) # Add to an event loop
	elapsed = time.perf_counter() - s
	print(f"{__file__} executed in {elapsed:0.2f} seconds.")